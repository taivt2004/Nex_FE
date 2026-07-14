import 'package:json_annotation/json_annotation.dart';

part 'coin_detail.g.dart';

double _numToDouble(Object? value) => (value as num?)?.toDouble() ?? 0;
String _stringOrEmpty(Object? value) => value?.toString() ?? '';

@JsonSerializable()
class CoinDetail {
  CoinDetail({
    required this.metadata,
    required this.statistics,
    required this.changes,
    required this.chartBaseline,
  });

  factory CoinDetail.fromJson(Map<String, dynamic> json) => _$CoinDetailFromJson(json);
  Map<String, dynamic> toJson() => _$CoinDetailToJson(this);

  final CoinMetadata metadata;
  final CoinStatistics statistics;
  final CoinChanges changes;
  @JsonKey(name: 'chart_baseline')
  final double chartBaseline;
}

@JsonSerializable()
class CoinMetadata {
  CoinMetadata({
    required this.id,
    required this.name,
    required this.symbol,
    required this.imgUrl,
    required this.description,
    required this.links,
    required this.contract,
  });

  factory CoinMetadata.fromJson(Map<String, dynamic> json) => _$CoinMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$CoinMetadataToJson(this);

  final String id;
  final String name;
  final String symbol;
  @JsonKey(name: 'img_url')
  final String imgUrl;
  @JsonKey(fromJson: _stringOrEmpty)
  final String description;
  final CoinLinks links;
  @JsonKey(fromJson: _stringOrEmpty)
  final String contract;
}

@JsonSerializable()
class CoinLinks {
  CoinLinks({
    required this.website,
    required this.twitter,
    required this.reddit,
  });

  factory CoinLinks.fromJson(Map<String, dynamic> json) => _$CoinLinksFromJson(json);
  Map<String, dynamic> toJson() => _$CoinLinksToJson(this);

  @JsonKey(fromJson: _stringOrEmpty)
  final String website;
  @JsonKey(fromJson: _stringOrEmpty)
  final String twitter;
  @JsonKey(fromJson: _stringOrEmpty)
  final String reddit;
}

@JsonSerializable()
class CoinStatistics {
  CoinStatistics({
    required this.price,
    required this.rank,
    required this.marketCap,
    required this.fdv,
    required this.dominance,
    required this.volume24h,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.ath,
    required this.atl,
  });

  factory CoinStatistics.fromJson(Map<String, dynamic> json) => _$CoinStatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$CoinStatisticsToJson(this);

  final double price;
  final int rank;
  @JsonKey(name: 'market_cap')
  final double marketCap;
  @JsonKey(fromJson: _numToDouble)
  final double fdv;
  @JsonKey(fromJson: _numToDouble)
  final double dominance;
  @JsonKey(name: 'volume_24h')
  final double volume24h;
  @JsonKey(name: 'circulating_supply')
  final double circulatingSupply;
  @JsonKey(name: 'total_supply')
  final double totalSupply;
  @JsonKey(name: 'max_supply')
  final double maxSupply;
  final AthInfo ath;
  final AthInfo atl;
}

@JsonSerializable()
class AthInfo {
  AthInfo({
    required this.price,
    required this.date,
  });

  factory AthInfo.fromJson(Map<String, dynamic> json) => _$AthInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AthInfoToJson(this);

  @JsonKey(fromJson: _numToDouble)
  final double price;
  @JsonKey(fromJson: _stringOrEmpty)
  final String date;
}

@JsonSerializable()
class CoinChanges {
  CoinChanges({
    required this.h1,
    required this.h24,
    required this.d7,
  });

  factory CoinChanges.fromJson(Map<String, dynamic> json) => _$CoinChangesFromJson(json);
  Map<String, dynamic> toJson() => _$CoinChangesToJson(this);

  @JsonKey(name: '1h')
  final double h1;
  @JsonKey(name: '24h')
  final double h24;
  @JsonKey(name: '7d')
  final double d7;
}
