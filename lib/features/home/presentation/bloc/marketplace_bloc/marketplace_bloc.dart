import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/coin.dart';
import 'package:nexpaylab/app/data/repository/coin_repos.dart';
import 'package:nexpaylab/app/data/service/model/coin_res.dart';
import 'package:nexpaylab/shared/logger.dart';
import 'package:nexpaylab/shared/utils/result.dart';

part 'marketplace_event.dart';
part 'marketplace_state.dart';

@injectable
class MarketplaceBloc extends Bloc<MarketplaceEvent, MarketplaceState> {
  MarketplaceBloc(this._coinRepository) : super(const MarketplaceState()) {
    on<FetchMarketplace>(_onFetched, transformer: droppable());
    on<LoadMoreMarketplace>(_onLoadMore, transformer: droppable());
  }

  final CoinRepository _coinRepository;
  static const int _limit = 20;
  static const int _cacheTTLSeconds = 30;

  Future<void> _onFetched(
    FetchMarketplace event,
    Emitter<MarketplaceState> emit,
  ) async {
    try {
      emit(state.copyWith(status: MarketplaceStatus.loading, stale: false));

      // 1. Check Local & Freshness
      final localData = await _coinRepository.getCoinsLocal(1, _limit);
      final lastTime = await _coinRepository.getLastFetchTime(1, _limit);
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final isFresh = (now - lastTime) <= _cacheTTLSeconds;

      // If fresh, use local immediately
      if (localData != null && isFresh) {
        _emitSuccess(emit, localData, stale: false);
        return;
      }

      // 2. Fetch Remote
      final result = await _coinRepository.getCoinsRemote(1, _limit);

      result.when(
        success: (CoinRes res) {
          // Save to local
          _coinRepository.saveCoinsLocal(1, _limit, res);
          _emitSuccess(emit, res, stale: false);
        },
        failure: (error) {
          // Fallback to local if available (even if stale)
          if (localData != null) {
            _emitSuccess(emit, localData, stale: true);
          } else {
            emit(
                state.copyWith(status: MarketplaceStatus.failure, stale: false));
          }
        },
      );
    } catch (e, s) {
      talker.error('MarketplaceBloc _onFetched error', e, s);
      emit(state.copyWith(status: MarketplaceStatus.failure, stale: false));
    }
  }

  void _emitSuccess(
    Emitter<MarketplaceState> emit,
    CoinRes res, {
    required bool stale,
  }) {
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
        // If empty remote but we have old data, maybe retry? 
        // Logic kept from original: delayed retry
        if (!stale) { 
           Future.delayed(const Duration(seconds: 2), () {
             add(FetchMarketplace());
           });
        }
      } else {
        emit(
          state.copyWith(
            status: MarketplaceStatus.success,
            coins: const [],
            currentPage: 1,
            hasReachedMax: false,
            loadingMore: false,
            stale: stale,
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
          stale: stale,
        ),
      );
    }
  }

  Future<void> _onLoadMore(
    LoadMoreMarketplace event,
    Emitter<MarketplaceState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      final nextPage =
          state.currentPage + 1; // Mark that load-more is in progress
      emit(state.copyWith(loadingMore: true));
      final result = await _coinRepository.getCoinsRemote(nextPage, _limit);

      result.maybeWhen(
        success: (CoinRes res) {
          // Save to local for consistency
          _coinRepository.saveCoinsLocal(nextPage, _limit, res);

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
        orElse: () {
          emit(state.copyWith(loadingMore: false));
        },
      );
    } catch (e, s) {
      talker.error('MarketplaceBloc _onLoadMore error', e, s);
      emit(state.copyWith(loadingMore: false, status: MarketplaceStatus.failure));
    }
  }
}
