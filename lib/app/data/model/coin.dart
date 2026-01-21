import 'package:json_annotation/json_annotation.dart';

part 'coin.g.dart';

@JsonSerializable()
class Coin {
  Coin({
    required this.symbol,
    required this.base,
    required this.quote,
    required this.name,
    required this.price,
    required this.change24h,
    this.volume24h,
    this.exchange,
  });

  factory Coin.fromJson(Map<String, dynamic> json) => _$CoinFromJson(json);
  Map<String, dynamic> toJson() => _$CoinToJson(this);

  final String symbol;
  final String base;
  final String quote;
  final String name;
  final double price;
  final double change24h;
  final double? volume24h;
  final String? exchange;
}
