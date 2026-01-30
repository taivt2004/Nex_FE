import 'package:json_annotation/json_annotation.dart';

part 'coin.g.dart';

@JsonSerializable()
class CoinRes {
  CoinRes({
    required this.symbol,
    required this.base,
    required this.quote,
    required this.price,
    required this.change24h,
    required this.volume24h,
    required this.quoteVolume24h,
    required this.exchange,
  });
  
  factory CoinRes.fromJson(Map<String, dynamic> json) => _$CoinResFromJson(json);
  Map<String, dynamic> toJson() => _$CoinResToJson(this);

  final String symbol;
  final String base;
  final String quote;
  final double price;

  @JsonKey(name: 'change_24h')
  final double change24h;

  @JsonKey(name: 'volume_24h')
  final double volume24h; // Base Volume

  @JsonKey(name: 'quote_volume_24h')
  final double quoteVolume24h; // Quote Volume (USDT)

  final String exchange;

  
  String get name => base;
  

  double get volume => quoteVolume24h; 
}
