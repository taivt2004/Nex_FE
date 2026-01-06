part of 'marketplace_bloc.dart';

enum MarketplaceStatus { initial, loading, success, failure }

class MarketplaceState {
  const MarketplaceState({
    this.status = MarketplaceStatus.initial,
    this.coins = const [],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.loadingMore = false,
    this.stale = false,
  });

  final MarketplaceStatus status;
  final List<Coin> coins;
  final bool hasReachedMax;
  final int currentPage;
  final bool loadingMore;
  final bool stale;
  MarketplaceState copyWith({
    MarketplaceStatus? status,
    List<Coin>? coins,
    bool? hasReachedMax,
    int? currentPage,
    bool? loadingMore,
    bool? stale,
  }) {
    return MarketplaceState(
      status: status ?? this.status,
      coins: coins ?? this.coins,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      loadingMore: loadingMore ?? this.loadingMore,
      stale: stale ?? this.stale,
    );
  }
}
