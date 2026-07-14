// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartData _$ChartDataFromJson(Map<String, dynamic> json) => ChartData(
  coinId: json['coin_id'] as String,
  range: json['range'] as String,
  interval: json['interval'] as String,
  baseLine: (json['base_line'] as num).toDouble(),
  points: (json['points'] as List<dynamic>)
      .map((e) => ChartPoint.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ChartDataToJson(ChartData instance) => <String, dynamic>{
  'coin_id': instance.coinId,
  'range': instance.range,
  'interval': instance.interval,
  'base_line': instance.baseLine,
  'points': instance.points,
};

ChartPoint _$ChartPointFromJson(Map<String, dynamic> json) => ChartPoint(
  time: (json['time'] as num).toInt(),
  value: (json['value'] as num).toDouble(),
);

Map<String, dynamic> _$ChartPointToJson(ChartPoint instance) =>
    <String, dynamic>{'time': instance.time, 'value': instance.value};
