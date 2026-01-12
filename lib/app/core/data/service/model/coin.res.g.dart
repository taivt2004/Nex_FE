// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin.res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinResponse _$CoinResponseFromJson(Map<String, dynamic> json) => CoinResponse(
  success: json['success'] as bool,
  code: (json['code'] as num).toInt(),
  message: json['message'] as String,
  data: CoinPageData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CoinResponseToJson(CoinResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };

CoinPageData _$CoinPageDataFromJson(Map<String, dynamic> json) => CoinPageData(
  items: (json['items'] as List<dynamic>)
      .map((e) => CoinItemResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  limit: (json['limit'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$CoinPageDataToJson(CoinPageData instance) =>
    <String, dynamic>{
      'items': instance.items,
      'limit': instance.limit,
      'page': instance.page,
      'total': instance.total,
    };

CoinItemResponse _$CoinItemResponseFromJson(Map<String, dynamic> json) =>
    CoinItemResponse(
      symbol: json['symbol'] as String,
      base: json['base'] as String,
      quote: json['quote'] as String,
      price: (json['price'] as num).toDouble(),
      change24h: (json['change_24h'] as num).toDouble(),
      volume24h: (json['volume_24h'] as num).toDouble(),
      quoteVolume24h: (json['quote_volume_24h'] as num).toDouble(),
      exchange: json['exchange'] as String,
    );

Map<String, dynamic> _$CoinItemResponseToJson(CoinItemResponse instance) =>
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
