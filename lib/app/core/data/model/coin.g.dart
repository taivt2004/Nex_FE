// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coin _$CoinFromJson(Map<String, dynamic> json) => Coin(
  symbol: json['symbol'] as String,
  base: json['base'] as String,
  quote: json['quote'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  change24h: (json['change24h'] as num).toDouble(),
  volume24h: (json['volume24h'] as num?)?.toDouble(),
  exchange: json['exchange'] as String?,
);

Map<String, dynamic> _$CoinToJson(Coin instance) => <String, dynamic>{
  'symbol': instance.symbol,
  'base': instance.base,
  'quote': instance.quote,
  'name': instance.name,
  'price': instance.price,
  'change24h': instance.change24h,
  'volume24h': instance.volume24h,
  'exchange': instance.exchange,
};
