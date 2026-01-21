import 'package:json_annotation/json_annotation.dart';
import 'package:nexpaylab/app/data/model/coin.dart';

part 'coin_res.g.dart';

@JsonSerializable(explicitToJson: true)
class CoinResponse {
  CoinResponse({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
  });

  factory CoinResponse.fromJson(Map<String, dynamic> json) =>
      _$CoinResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CoinResponseToJson(this);

  final bool success;
  final int code;
  final String message;
  final CoinPageData data;

  List<CoinItemResponse> get items => data.items;
  int get limit => data.limit;
  int get page => data.page;
  int get total => data.total;
}

@JsonSerializable(explicitToJson: true)
class CoinPageData {
  CoinPageData({
    required this.items,
    required this.limit,
    required this.page,
    required this.total,
  });

  factory CoinPageData.fromJson(Map<String, dynamic> json) =>
      _$CoinPageDataFromJson(json);
  Map<String, dynamic> toJson() => _$CoinPageDataToJson(this);

  final List<CoinItemResponse> items;
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
