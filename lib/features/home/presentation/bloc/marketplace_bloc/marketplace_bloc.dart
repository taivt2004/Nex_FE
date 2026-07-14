
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/base/data_list.dart';
import 'package:nexpaylab/app/data/model/coin/coin_list_item.dart';
import 'package:nexpaylab/app/data/repository/coin_repos.dart';
import 'package:nexpaylab/shared/logger.dart';
import 'package:nexpaylab/shared/utils/result.dart';

part 'marketplace_event.dart';
part 'marketplace_state.dart';


@injectable
class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  MarketplaceBloc(this._coinRepository)
      : super(const MarketplaceState()) {
    on<FetchMarketplace>(_onFetch, transformer: droppable());
    on<LoadMoreMarketplace>(_onLoadMore, transformer: droppable());
    on<RefreshMarketplace>(_onRefresh, transformer: droppable());
  }

  final CoinRepository _coinRepository;
  static const int _limit = 20;

  Future<void> _onFetch(
    FetchMarketplace event,
    Emitter<MarketplaceState> emit,
  ) async {
    const page = 1;
    emit(state.copyWith(status: MarketplaceStatus.loading));

    try {
      final remoteResult = await _coinRepository.getCoinList(
        page: page,
        limit: _limit.toString(),
      );

      await remoteResult.when(
        success: (DataList<CoinListItem> dataList) async {
          final fetchedCoins = dataList.data;

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
          emit(
            state.copyWith(
              status: MarketplaceStatus.failure,
              errorMessage: error.toString(),
            ),
          );
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
    final remoteResult = await _coinRepository.getCoinList(
      page: nextPage,
      limit: _limit.toString(),
    );

    remoteResult.when(
      success: (DataList<CoinListItem> dataList) {
        final newCoins = dataList.data;
      
        if (newCoins.isEmpty) {
          emit(
            state.copyWith(
              loadingMore: false,
              hasReachedMax: true,
            ),);
          return;
        }

        final allCoins = List<CoinListItem>.from(state.coins)..addAll(newCoins);

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
