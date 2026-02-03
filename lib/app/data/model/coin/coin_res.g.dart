// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinRes _$CoinResFromJson(Map<String, dynamic> json) => CoinRes(
  symbol: json['symbol'] as String,
  base: json['base'] as String,
  quote: json['quote'] as String,
  price: (json['price'] as num).toDouble(),
  change24h: (json['change_24h'] as num).toDouble(),
  volume24h: (json['volume_24h'] as num).toDouble(),
  quoteVolume24h: (json['quote_volume_24h'] as num).toDouble(),
  exchange: json['exchange'] as String,
);

Map<String, dynamic> _$CoinResToJson(CoinRes instance) => <String, dynamic>{
  'symbol': instance.symbol,
  'base': instance.base,
  'quote': instance.quote,
  'price': instance.price,
  'change_24h': instance.change24h,
  'volume_24h': instance.volume24h,
  'quote_volume_24h': instance.quoteVolume24h,
  'exchange': instance.exchange,
};
