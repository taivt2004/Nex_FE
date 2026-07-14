// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_list_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinListItem _$CoinListItemFromJson(Map<String, dynamic> json) => CoinListItem(
  id: json['id'] as String,
  name: json['name'] as String,
  symbol: json['symbol'] as String,
  price: (json['price'] as num).toDouble(),
  rank: (json['rank'] as num).toInt(),
  imgUrl: json['img_url'] as String,
  marketCap: (json['market_cap'] as num).toDouble(),
  volume24h: (json['volume_24h'] as num).toDouble(),
  change1h: _numToDouble(json['change_1h']),
  change24h: _numToDouble(json['change_24h']),
);

Map<String, dynamic> _$CoinListItemToJson(CoinListItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symbol': instance.symbol,
      'price': instance.price,
      'rank': instance.rank,
      'img_url': instance.imgUrl,
      'market_cap': instance.marketCap,
      'volume_24h': instance.volume24h,
      'change_1h': instance.change1h,
      'change_24h': instance.change24h,
    };
