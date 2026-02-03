import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/base/data_list.dart';
import 'package:nexpaylab/app/data/model/coin/coin_res.dart';
import 'package:nexpaylab/app/data/repository/coin_repos.dart';
import 'package:nexpaylab/app/database/coin_local.dart';
import 'package:nexpaylab/shared/logger.dart';
import 'package:nexpaylab/shared/utils/result.dart';

part 'marketplace_event.dart';
part 'marketplace_state.dart';


@injectable
class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  MarketplaceBloc(this._coinRepository, this._coinLocal)
      : super(const MarketplaceState()) {
    on<FetchMarketplace>(_onFetch, transformer: droppable());
    on<LoadMoreMarketplace>(_onLoadMore, transformer: droppable());
    on<RefreshMarketplace>(_onRefresh, transformer: droppable());
  }

  final CoinRepository _coinRepository;
  final CoinLocal _coinLocal;
  static const int _limit = 20;

  Future<void> _onFetch(
    FetchMarketplace event,
    Emitter<MarketplaceState> emit,
  ) async {
    const page = 1;
    emit(state.copyWith(status: MarketplaceStatus.loading));

    // 1. CACHE-FIRST STRATEGY: Try to load data from local storage first.
    // This ensures the user sees content immediately (optimistic UI), improving perceived performance.
    try {
      final cachedData = await _coinLocal.getCoinsLocal(
        page,
        _limit,
      );
      final cachedCoins = cachedData?.data ?? [];

      if (cachedCoins.isNotEmpty) {
        // Show local data immediately
        emit(state.copyWith(
          status: MarketplaceStatus.success,
          coins: cachedCoins,
          page: page,
          hasReachedMax: cachedCoins.length < _limit,
          errorMessage: '',
        ));
      }
    } catch (e) {
      talker.warning('Load local data failed, proceeding to remote', e);
    }

    try {
      // 2. ALWAYS FETCH REMOTE: Proceed to fetch fresh data from the API regardless of local cache status.
      // This ensures the app eventually displays the most up-to-date information.
      final remoteResult = await _coinRepository.getCoinsRemote(page, _limit);

      await remoteResult.when(
        success: (DataList<CoinRes> dataList) async {
          final fetchedCoins = dataList.data;

          // 3. SYNC TO LOCAL: Save the fresh data to local storage for future use.
          try {
            await _coinLocal.saveCoinsLocal(page, _limit, dataList);
          } catch (e) {
            talker.error('Save local failed', e);
          }

          // 4. UPDATE UI: Refresh the UI with the latest data from the server.
          emit(
            state.copyWith(
              status: MarketplaceStatus.success,
              coins: fetchedCoins,
              page: page,
              hasReachedMax:
                  fetchedCoins.length < _limit || fetchedCoins.length >= (dataList.meta?.total ?? 0),
              errorMessage: '',
            ),
          );
        },
        failure: (error) {
          // If fetching remote fails...
          
          // Case A: No local data available -> Show error screen
          if (state.coins.isEmpty) {
            emit(
              state.copyWith(
                status: MarketplaceStatus.failure,
                errorMessage: error.toString(),
              ),
            );
          } else {
            // Case B: Local data is already showing -> Keep showing it (don't break UI), just log error
            talker.error('Fetch marketplace failed: $error');
          }
        },
      );
    } catch (e) {
      talker.error('MarketplaceBloc _onFetch error', e);
    if (state.coins.isEmpty) {
      emit(
        state.copyWith(
          status: MarketplaceStatus.failure,
          errorMessage: e.toString(),
        ),);}}}

  Future<void> _onLoadMore(
    LoadMoreMarketplace event,
    Emitter<MarketplaceState> emit,
  ) async {
    if (state.hasReachedMax) return;
    if(state.status != MarketplaceStatus.success) return;
    if (state.loadingMore) return;
    
    try {
    emit(state.copyWith(loadingMore: true));

    final nextPage = state.page + 1;
    final remoteResult = await _coinRepository.getCoinsRemote(nextPage, _limit);

    remoteResult.when(
      success: (DataList<CoinRes> dataList) {
        final newCoins = dataList.data;
      
        if (newCoins.isEmpty) {
          emit(
            state.copyWith(
              loadingMore: false,
              hasReachedMax: true,
            ),);
          return;
        }

        final allCoins = List<CoinRes>.from(state.coins)..addAll(newCoins);

        emit(
          state.copyWith(
            coins: allCoins,
            page: nextPage,
            loadingMore: false,
            hasReachedMax: newCoins.length < _limit ||
                allCoins.length >= (dataList.meta?.total ?? 0),
          ),);},
      failure: (error) {
        talker.error('Load more marketplace failed: $error');
        emit(state.copyWith(loadingMore: false));
      },
    );
  } catch (e, s) {
    talker.error('MarketplaceBloc _onLoadMore error', e, s);
    emit(state.copyWith(loadingMore: false));
}}

  Future<void> _onRefresh(
    RefreshMarketplace event,
    Emitter<MarketplaceState> emit,
  ) async { 
    if(state.status != MarketplaceStatus.success) return;
    if (state.loadingMore) return;
    await _onFetch(const FetchMarketplace(), emit);
  }
}
