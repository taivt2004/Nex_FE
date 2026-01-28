import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/base/base_response.dart';
import 'package:nexpaylab/app/data/model/coin/coin.dart';
import 'package:nexpaylab/app/data/repository/coin_repos.dart';
import 'package:nexpaylab/shared/logger.dart';
import 'package:nexpaylab/shared/utils/result.dart';

part 'marketplace_event.dart';
part 'marketplace_state.dart';


@injectable
class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  MarketplaceBloc(this._marketplaceRepository)
      : super(const MarketplaceState()) {
    on<FetchMarketplace>(_onFetch, transformer: droppable());
    on<LoadMoreMarketplace>(_onLoadMore, transformer: droppable());
    on<RefreshMarketplace>(_onRefresh, transformer: droppable());
  }

  final CoinRepository _marketplaceRepository;
  static const int _limit = 20;

  Future<void> _onFetch(
    FetchMarketplace event,
    Emitter<MarketplaceState> emit,
  ) async {
    const page = 1;
    emit(state.copyWith(status: MarketplaceStatus.loading));

    // try to get local data first
    try {
      final localRes = await _marketplaceRepository.getCoinsLocal(
        page,
        _limit,
      );
      final localItems = localRes?.data ?? [];

      if (localItems.isNotEmpty) {
        emit(state.copyWith(
          status: MarketplaceStatus.success,
          coins: localItems,
          page: page,
          hasReachedMax: localItems.length < _limit,
          errorMessage: '',
        ));
      }
    } catch (e) {
      talker.warning('Load local data failed, proceeding to remote', e);
    }

    try {
      // if local data is empty or failed, try to get remote data
      final remoteResult = await _marketplaceRepository.getCoinsRemote(page, _limit);
      
      await remoteResult.when(
        success: (BaseResponse<List<Coin>> res) async {
          final items = res.data ?? [];

          // save to local for next time
          try {
            await _marketplaceRepository.saveCoinsLocal(page, _limit, res);
          } catch (e) {
            talker.error('Save local failed', e);
          }

          emit(
            state.copyWith(
              status: MarketplaceStatus.success,
              coins: items,
              page: page,
              hasReachedMax:
                  items.length < _limit || items.length >= (res.meta?.total ?? 0),
              errorMessage: '',
            ),
          );
        },
        failure: (error) {
          // if local data is empty, show error
          if (state.coins.isEmpty) {
            emit(
              state.copyWith(
                status: MarketplaceStatus.failure,
                errorMessage: error.toString(),
              ),
            );
          } else {
            // If we already have local data, keep the UI as it is,
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
    final result = await _marketplaceRepository.getCoinsRemote(nextPage, _limit);

    result.when(
      success: (BaseResponse<List<Coin>> res) {
        final newItems = res.data ?? [];
      
        if (newItems.isEmpty) {
          emit(
            state.copyWith(
              loadingMore: false,
              hasReachedMax: true,
            ),);
          return;
        }

        final allCoins = List<Coin>.from(state.coins)..addAll(newItems);

        emit(
          state.copyWith(
            coins: allCoins,
            page: nextPage,
            loadingMore: false,
            hasReachedMax: newItems.length < _limit ||
                allCoins.length >= (res.meta?.total ?? 0),
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
