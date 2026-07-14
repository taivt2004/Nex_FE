import 'package:json_annotation/json_annotation.dart';

part 'coin_list_item.g.dart';

double _numToDouble(Object? value) => (value as num?)?.toDouble() ?? 0;

@JsonSerializable()
class CoinListItem {
  CoinListItem({
    required this.id,
    required this.name,
    required this.symbol,
    required this.price,
    required this.rank,
    required this.imgUrl,
    required this.marketCap,
    required this.volume24h,
    required this.change1h,
    required this.change24h,
  });

  factory CoinListItem.fromJson(Map<String, dynamic> json) => _$CoinListItemFromJson(json);
  Map<String, dynamic> toJson() => _$CoinListItemToJson(this);

  final String id;
  final String name;
  final String symbol;
  final double price;
  final int rank;
  @JsonKey(name: 'img_url')
  final String imgUrl;
  @JsonKey(name: 'market_cap')
  final double marketCap;
  @JsonKey(name: 'volume_24h')
  final double volume24h;
  @JsonKey(name: 'change_1h', fromJson: _numToDouble)
  final double change1h;
  @JsonKey(name: 'change_24h', fromJson: _numToDouble)
  final double change24h;
}
