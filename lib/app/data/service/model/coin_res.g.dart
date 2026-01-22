// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinRes _$CoinResFromJson(Map<String, dynamic> json) => CoinRes(
  success: json['success'] as bool,
  code: (json['code'] as num).toInt(),
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>)
      .map((e) => CoinItemRes.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: CoinMetaRes.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CoinResToJson(CoinRes instance) => <String, dynamic>{
  'success': instance.success,
  'code': instance.code,
  'message': instance.message,
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta.toJson(),
};

CoinMetaRes _$CoinMetaResFromJson(Map<String, dynamic> json) => CoinMetaRes(
  limit: (json['limit'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$CoinMetaResToJson(CoinMetaRes instance) =>
    <String, dynamic>{
      'limit': instance.limit,
      'page': instance.page,
      'total': instance.total,
    };

CoinItemRes _$CoinItemResFromJson(Map<String, dynamic> json) => CoinItemRes(
  symbol: json['symbol'] as String,
  base: json['base'] as String,
  quote: json['quote'] as String,
  price: (json['price'] as num).toDouble(),
  change24h: (json['change_24h'] as num).toDouble(),
  volume24h: (json['volume_24h'] as num).toDouble(),
  quoteVolume24h: (json['quote_volume_24h'] as num).toDouble(),
  exchange: json['exchange'] as String,
);

Map<String, dynamic> _$CoinItemResToJson(CoinItemRes instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'base': instance.base,
      'quote': instance.quote,
      'price': instance.price,
      'change_24h': instance.change24h,
      'volume_24h': instance.volume24h,
      'quote_volume_24h': instance.quoteVolume24h,
      'exchange': instance.exchange,
    };
