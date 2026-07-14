// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coin_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoinDetail _$CoinDetailFromJson(Map<String, dynamic> json) => CoinDetail(
  metadata: CoinMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
  statistics: CoinStatistics.fromJson(
    json['statistics'] as Map<String, dynamic>,
  ),
  changes: CoinChanges.fromJson(json['changes'] as Map<String, dynamic>),
  chartBaseline: (json['chart_baseline'] as num).toDouble(),
);

Map<String, dynamic> _$CoinDetailToJson(CoinDetail instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
      'statistics': instance.statistics,
      'changes': instance.changes,
      'chart_baseline': instance.chartBaseline,
    };

CoinMetadata _$CoinMetadataFromJson(Map<String, dynamic> json) => CoinMetadata(
  id: json['id'] as String,
  name: json['name'] as String,
  symbol: json['symbol'] as String,
  imgUrl: json['img_url'] as String,
  description: json['description'] as String,
  links: CoinLinks.fromJson(json['links'] as Map<String, dynamic>),
  contract: json['contract'] as String,
);

Map<String, dynamic> _$CoinMetadataToJson(CoinMetadata instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symbol': instance.symbol,
      'img_url': instance.imgUrl,
      'description': instance.description,
      'links': instance.links,
      'contract': instance.contract,
    };

CoinLinks _$CoinLinksFromJson(Map<String, dynamic> json) => CoinLinks(
  website: json['website'] as String,
  twitter: json['twitter'] as String,
  reddit: json['reddit'] as String,
);

Map<String, dynamic> _$CoinLinksToJson(CoinLinks instance) => <String, dynamic>{
  'website': instance.website,
  'twitter': instance.twitter,
  'reddit': instance.reddit,
};

CoinStatistics _$CoinStatisticsFromJson(Map<String, dynamic> json) =>
    CoinStatistics(
      price: (json['price'] as num).toDouble(),
      rank: (json['rank'] as num).toInt(),
      marketCap: (json['market_cap'] as num).toDouble(),
      fdv: (json['fdv'] as num).toDouble(),
      dominance: (json['dominance'] as num).toDouble(),
      volume24h: (json['volume_24h'] as num).toDouble(),
      circulatingSupply: (json['circulating_supply'] as num).toDouble(),
      totalSupply: (json['total_supply'] as num).toDouble(),
      maxSupply: (json['max_supply'] as num).toDouble(),
      ath: AthInfo.fromJson(json['ath'] as Map<String, dynamic>),
      atl: AthInfo.fromJson(json['atl'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CoinStatisticsToJson(CoinStatistics instance) =>
    <String, dynamic>{
      'price': instance.price,
      'rank': instance.rank,
      'market_cap': instance.marketCap,
      'fdv': instance.fdv,
      'dominance': instance.dominance,
      'volume_24h': instance.volume24h,
      'circulating_supply': instance.circulatingSupply,
      'total_supply': instance.totalSupply,
      'max_supply': instance.maxSupply,
      'ath': instance.ath,
      'atl': instance.atl,
    };

AthInfo _$AthInfoFromJson(Map<String, dynamic> json) => AthInfo(
  price: (json['price'] as num).toDouble(),
  date: json['date'] as String,
);

Map<String, dynamic> _$AthInfoToJson(AthInfo instance) => <String, dynamic>{
  'price': instance.price,
  'date': instance.date,
};

CoinChanges _$CoinChangesFromJson(Map<String, dynamic> json) => CoinChanges(
  h1: (json['1h'] as num).toDouble(),
  h24: (json['24h'] as num).toDouble(),
  d7: (json['7d'] as num).toDouble(),
);

Map<String, dynamic> _$CoinChangesToJson(CoinChanges instance) =>
    <String, dynamic>{
      '1h': instance.h1,
      '24h': instance.h24,
      '7d': instance.d7,
    };
