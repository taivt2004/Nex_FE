import 'package:json_annotation/json_annotation.dart';

part 'chart_data.g.dart';

@JsonSerializable()
class ChartData {
  ChartData({
    required this.coinId,
    required this.range,
    required this.interval,
    required this.baseLine,
    required this.points,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) => _$ChartDataFromJson(json);
  Map<String, dynamic> toJson() => _$ChartDataToJson(this);

  @JsonKey(name: 'coin_id')
  final String coinId;
  final String range;
  final String interval;
  @JsonKey(name: 'base_line')
  final double baseLine;
  final List<ChartPoint> points;
}

@JsonSerializable()
class ChartPoint {
  ChartPoint({
    required this.time,
    required this.value,
  });

  factory ChartPoint.fromJson(Map<String, dynamic> json) => _$ChartPointFromJson(json);
  Map<String, dynamic> toJson() => _$ChartPointToJson(this);

  final int time;
  final double value;
}
