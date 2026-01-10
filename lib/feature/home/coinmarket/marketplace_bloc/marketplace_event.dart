part of 'marketplace_bloc.dart';

abstract class MarketplaceEvent {
  const MarketplaceEvent();
}

// Sự kiện khi mới vào trang hoặc Pull-to-refresh
class MarketplaceFetched extends MarketplaceEvent {}

// Sự kiện khi người dùng cuộn xuống dưới cùng để tải thêm
class MarketplaceLoadMore extends MarketplaceEvent {}