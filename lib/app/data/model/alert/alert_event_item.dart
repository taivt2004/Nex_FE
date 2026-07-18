double _eventToDouble(Object? value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

int _eventToInt(Object? value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

DateTime? _eventToDateTime(Object? value) {
  final raw = value?.toString() ?? '';
  if (raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}

class AlertEventItem {
  const AlertEventItem({
    required this.id,
    required this.subscriptionId,
    required this.userId,
    required this.coinId,
    required this.alertType,
    required this.observedPrice,
    required this.observedChangePct,
    required this.timeWindowMinutes,
    required this.triggeredAt,
    required this.alertDirection,
    required this.frequency,
  });

  factory AlertEventItem.fromJson(Map<String, dynamic> json) {
    return AlertEventItem(
      id: _eventToInt(json['id']),
      subscriptionId: _eventToInt(json['subscriptionId']),
      userId: _eventToInt(json['userId']),
      coinId: json['coinId']?.toString() ?? '',
      alertType: json['alertType']?.toString() ?? '',
      observedPrice: _eventToDouble(json['observedPrice']),
      observedChangePct: json['observedChangePct'] == null
          ? null
          : _eventToDouble(json['observedChangePct']),
      timeWindowMinutes: _eventToInt(json['timeWindowMinutes']),
      triggeredAt: _eventToDateTime(json['triggeredAt']),
      alertDirection: json['alertDirection']?.toString() ?? 'above',
      frequency: json['frequency']?.toString() ?? 'once',
    );
  }

  final int id;
  final int subscriptionId;
  final int userId;
  final String coinId;
  final String alertType;
  final double observedPrice;
  final double? observedChangePct;
  final int timeWindowMinutes;
  final DateTime? triggeredAt;
  final String alertDirection;
  final String frequency;

  bool get isAbove => alertDirection == 'above';
  String get timeWindowLabel => timeWindowMinutes == 1440 ? '24 giờ' : '1 giờ';
}
