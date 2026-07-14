import 'package:json_annotation/json_annotation.dart';

part 'chart_history.g.dart';

@JsonSerializable()
class ChartHistory {
  ChartHistory({
    required this.coinId,
    required this.range,
    required this.interval,
    required this.timeStartAligned,
    required this.timeEndAligned,
    required this.points,
  });

  factory ChartHistory.fromJson(Map<String, dynamic> json) => _$ChartHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$ChartHistoryToJson(this);

  @JsonKey(name: 'coin_id')
  final String coinId;
  final String range;
  final String interval;
  final int timeStartAligned;
  final int timeEndAligned;
  final List<HistoryPoint> points;
}

@JsonSerializable()
class HistoryPoint {
  HistoryPoint({
    required this.s,
    required this.v,
  });

  factory HistoryPoint.fromJson(Map<String, dynamic> json) => _$HistoryPointFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryPointToJson(this);

  final int s;
  final List<double> v;
}
