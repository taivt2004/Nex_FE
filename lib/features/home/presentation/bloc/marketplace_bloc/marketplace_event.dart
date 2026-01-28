part of 'marketplace_bloc.dart';

abstract class MarketplaceEvent extends Equatable {
  const MarketplaceEvent();
  @override
  List<Object?> get props => [];
}

final class FetchMarketplace extends MarketplaceEvent {
  const FetchMarketplace();
}

final class LoadMoreMarketplace extends MarketplaceEvent {
  const LoadMoreMarketplace();
}

final class RefreshMarketplace extends MarketplaceEvent {
  const RefreshMarketplace();
}
