import 'package:json_annotation/json_annotation.dart';
import 'package:nexpaylab/app/data/model/coin.dart';

part 'coin_res.g.dart';

@JsonSerializable(explicitToJson: true)
class CoinRes {
  CoinRes({
    required this.success,
    required this.code,
    required this.message,
    required this.data,
    required this.meta,
  });

  factory CoinRes.fromJson(Map<String, dynamic> json) =>
      _$CoinResFromJson(json);
  Map<String, dynamic> toJson() => _$CoinResToJson(this);

  final bool success;
  final int code;
  final String message;
  final List<CoinItemRes> data;
  final CoinMetaRes meta;

  List<CoinItemRes> get items => data;
  int get limit => meta.limit;
  int get page => meta.page;
  int get total => meta.total;
}

@JsonSerializable(explicitToJson: true)
class CoinMetaRes {
  CoinMetaRes({
    required this.limit,
    required this.page,
    required this.total,
  });

  factory CoinMetaRes.fromJson(Map<String, dynamic> json) =>
      _$CoinMetaResFromJson(json);
  Map<String, dynamic> toJson() => _$CoinMetaResToJson(this);

  final int limit;
  final int page;
  final int total;
}

@JsonSerializable()
class CoinItemRes {
  CoinItemRes({
    required this.symbol,
    required this.base,
    required this.quote,
    required this.price,
    required this.change24h,
    required this.volume24h,
    required this.quoteVolume24h,
    required this.exchange,
  });

  factory CoinItemRes.fromJson(Map<String, dynamic> json) =>
      _$CoinItemResFromJson(json);
  Map<String, dynamic> toJson() => _$CoinItemResToJson(this);
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
