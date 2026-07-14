// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartHistory _$ChartHistoryFromJson(Map<String, dynamic> json) => ChartHistory(
  coinId: json['coin_id'] as String,
  range: json['range'] as String,
  interval: json['interval'] as String,
  timeStartAligned: (json['timeStartAligned'] as num).toInt(),
  timeEndAligned: (json['timeEndAligned'] as num).toInt(),
  points: (json['points'] as List<dynamic>)
      .map((e) => HistoryPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ChartHistoryToJson(ChartHistory instance) =>
    <String, dynamic>{
      'coin_id': instance.coinId,
      'range': instance.range,
      'interval': instance.interval,
      'timeStartAligned': instance.timeStartAligned,
      'timeEndAligned': instance.timeEndAligned,
      'points': instance.points,
    };

HistoryPoint _$HistoryPointFromJson(Map<String, dynamic> json) => HistoryPoint(
  s: (json['s'] as num).toInt(),
  v: (json['v'] as List<dynamic>).map((e) => (e as num).toDouble()).toList(),
);

Map<String, dynamic> _$HistoryPointToJson(HistoryPoint instance) =>
    <String, dynamic>{'s': instance.s, 'v': instance.v};
