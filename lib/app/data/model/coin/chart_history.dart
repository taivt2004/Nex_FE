import 'package:json_annotation/json_annotation.dart';

part 'chart_history.g.dart';

List<double> _numListToDoubleList(Object? values) {
  final raw = values;
  if (raw is! List) return const <double>[];
  return raw
      .map<double>((value) {
        if (value is num) return value.toDouble();
        if (value is String) return double.tryParse(value) ?? 0.0;
        return 0.0;
      })
      .toList(growable: false);
}

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

  @JsonKey(name: 'coin_id', defaultValue: '')
  final String coinId;
  @JsonKey(defaultValue: '')
  final String range;
  @JsonKey(defaultValue: '')
  final String interval;
  @JsonKey(defaultValue: 0)
  final int timeStartAligned;
  @JsonKey(defaultValue: 0)
  final int timeEndAligned;
  @JsonKey(defaultValue: <HistoryPoint>[])
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

  @JsonKey(defaultValue: 0)
  final int s;
  @JsonKey(fromJson: _numListToDoubleList, defaultValue: <double>[])
  final List<double> v;
}
