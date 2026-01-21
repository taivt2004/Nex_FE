import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/coin.dart';
import 'package:nexpaylab/app/data/repository/coin_repos.dart';
import 'package:nexpaylab/app/data/service/model/coin_res.dart';
import 'package:nexpaylab/shared/utils/result.dart';

part 'marketplace_event.dart';
part 'marketplace_state.dart';

@injectable
class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  MarketplaceBloc(this._coinRepository) : super(const MarketplaceState()) {
    on<FetchMarketplace>(_onFetched);
    on<LoadMoreMarketplace>(_onLoadMore);
  }

  final CoinRepository _coinRepository;
  static const int _limit = 20;

  Future<void> _onFetched(
    FetchMarketplace event,
    Emitter<MarketplaceState> emit,
  ) async {
    emit(state.copyWith(status: MarketplaceStatus.loading, stale: false));

    final result = await _coinRepository.getCoins(1, _limit);

    result.maybeWhen(
      success: (CoinResponse res) {
        final coins = res.items.map((e) => e.toEntity()).toList();
        if (res.total == 0 || coins.isEmpty) {
          if (state.coins.isNotEmpty) {
            emit(
              state.copyWith(
                status: MarketplaceStatus.success,
                coins: state.coins,
                currentPage: state.currentPage,
                hasReachedMax: state.hasReachedMax,
                loadingMore: false,
                stale: true,
              ),
            );
            Future.delayed(const Duration(seconds: 2), () {
              add(FetchMarketplace());
            });
          } else {
            emit(
              state.copyWith(
                status: MarketplaceStatus.success,
                coins: const [],
                currentPage: 1,
                hasReachedMax: false,
                loadingMore: false,
                stale: true,
              ),
            );
          }
        } else {
          emit(
            state.copyWith(
              status: MarketplaceStatus.success,
              coins: coins,
              currentPage: 1,
              hasReachedMax: coins.length >= res.total,
              stale: false,
            ),
          );
        }
      },
      failure: (error) =>
          emit(state.copyWith(status: MarketplaceStatus.failure, stale: false)),
      orElse: () {},
    );
  }

  Future<void> _onLoadMore(
    LoadMoreMarketplace event,
    Emitter<MarketplaceState> emit,
  ) async {
    if (state.hasReachedMax ||
        state.status == MarketplaceStatus.loading ||
        state.loadingMore) {
      return;
    }

    final nextPage =
        state.currentPage + 1; // Mark that load-more is in progress
    emit(state.copyWith(loadingMore: true));
    final result = await _coinRepository.getCoins(nextPage, _limit);

    result.maybeWhen(
      success: (CoinResponse res) {
        final newCoins = res.items.map((e) => e.toEntity()).toList();

        if (res.total == 0 || newCoins.isEmpty) {
          emit(
            state.copyWith(
              status: MarketplaceStatus.success,
              loadingMore: false,
              stale: true,
            ),
          );  
          return;
        }
        final allCoins = List<Coin>.from(state.coins)..addAll(newCoins);

        final reached =
            allCoins.length >= res.total || newCoins.length < _limit;

        emit(
          state.copyWith(
            status: MarketplaceStatus.success,
            coins: allCoins,
            currentPage: nextPage,
            // Logic chuẩn: Nếu tổng list hiện tại >= total của BE thì dừng
            hasReachedMax: reached,
            loadingMore: false,
            stale: false,
          ),
        );
      },
      failure: (error) => emit(
        state.copyWith(
          status: MarketplaceStatus.failure,
          loadingMore: false,
          stale: false,
        ),
      ),
      orElse: () {},
    );
  }
}
