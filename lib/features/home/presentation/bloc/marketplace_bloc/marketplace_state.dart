part of 'marketplace_bloc.dart';

enum MarketplaceStatus { initial, loading, success, failure }

class MarketplaceState extends Equatable {
  const MarketplaceState({
    this.status = MarketplaceStatus.initial,
    this.coins = const <CoinRes>[],
    this.page = 1,
    this.hasReachedMax = false,
    this.loadingMore = false,
    this.errorMessage = '',
  });

  final MarketplaceStatus status;
  final List<CoinRes> coins;
  final int page;
  final bool hasReachedMax;
  final bool loadingMore;
  final String errorMessage;

  MarketplaceState copyWith({
    MarketplaceStatus? status,
    List<CoinRes>? coins,
    int? page,
    bool? hasReachedMax,
    bool? loadingMore,
    String? errorMessage,
  }) {
    return MarketplaceState(
      status: status ?? this.status,
      coins: coins ?? this.coins,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      loadingMore: loadingMore ?? this.loadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [status, coins, page, hasReachedMax, loadingMore, errorMessage];
}
