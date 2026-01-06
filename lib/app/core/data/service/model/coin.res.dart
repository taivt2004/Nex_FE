import 'package:json_annotation/json_annotation.dart';
import 'package:nexpaylab/app/core/data/model/coin.dart';

part 'coin.res.g.dart';

@JsonSerializable()
class CoinResponse {
  CoinResponse({
    required this.data,
    required this.limit,
    required this.page,
    required this.total,
  });

  factory CoinResponse.fromJson(Map<String, dynamic> json) =>
      _$CoinResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CoinResponseToJson(this);
  final List<CoinItemResponse> data;
  final int limit;
  final int page;
  final int total;
}

@JsonSerializable()
class CoinItemResponse {
  CoinItemResponse({
    required this.symbol,
    required this.base,
    required this.quote,
    required this.price,
    required this.change24h,
    required this.volume24h,
    required this.quoteVolume24h,
    required this.exchange,
  });

  factory CoinItemResponse.fromJson(Map<String, dynamic> json) =>
      _$CoinItemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CoinItemResponseToJson(this);
  final String symbol;
  final String base;
  final String quote;
  final double price;

  @JsonKey(name: 'change_24h')
  final double change24h;

  @JsonKey(name: 'volume_24h')
  final double volume24h;

  @JsonKey(name: 'quote_volume_24h')
  final double quoteVolume24h;

  final String exchange;

  // Hàm quan trọng nhất để chuyển sang UI Model
  Coin toEntity() {
    return Coin(
      symbol: symbol,
      base: base,
      quote: quote,
      name: base,
      price: price,
      change24h: change24h,
      volume24h: quoteVolume24h,
      exchange: exchange,
    );
  }
}
