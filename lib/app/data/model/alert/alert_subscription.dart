int _toInt(Object? value) {
  if (value == null) return 0;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(Object? value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

bool _toBool(Object? value) {
  if (value is bool) return value;
  return value?.toString().toLowerCase() == 'true';
}

DateTime? _toDateTime(Object? value) {
  final raw = value?.toString() ?? '';
  if (raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}

class AlertSubscription {
  const AlertSubscription({
    required this.id,
    required this.userId,
    required this.coinId,
    required this.changePct,
    required this.alertDirection,
    required this.frequency,
    required this.timeWindowMinutes,
    required this.cooldownSeconds,
    required this.isActive,
    required this.conditionMet,
    required this.lastAlertAt,
  });

  factory AlertSubscription.fromCreateOrUpdateJson(Map<String, dynamic> json) {
    return AlertSubscription(
      id: _toInt(json['id']),
      userId: _toInt(json['user_id']),
      coinId: json['coin_id']?.toString() ?? '',
      changePct: _toDouble(json['change_pct']),
      alertDirection: json['alert_direction']?.toString() ?? 'above',
      frequency: json['frequency']?.toString() ?? 'once',
      timeWindowMinutes: _toInt(json['time_window_minutes']),
      cooldownSeconds: _toInt(json['alert_cooldown_seconds']),
      isActive: _toBool(json['is_active']),
      conditionMet: _toBool(json['condition_met']),
      lastAlertAt: _toDateTime(json['last_alert_at']),
    );
  }

  factory AlertSubscription.fromListJson(Map<String, dynamic> json) {
    final coinId = (json['coinId'] ?? json['coin_id'])?.toString() ?? '';
    final changePct = _toDouble(json['changePct'] ?? json['change_pct']);
    final alertDirection =
        (json['alertDirection'] ?? json['alert_direction'])?.toString() ?? 'above';
    final frequency = json['frequency']?.toString() ?? 'once';
    final timeWindowMinutes =
        _toInt(json['timeWindowMinutes'] ?? json['time_window_minutes']);
    final cooldownSeconds = _toInt(
      json['cooldownSeconds'] ??
          json['cooldown_seconds'] ??
          json['alert_cooldown_seconds'],
    );
    final isActive = _toBool(json['isActive'] ?? json['is_active']);
    final lastAlertAt = _toDateTime(json['lastAlertAt'] ?? json['last_alert_at']);

    return AlertSubscription(
      id: _toInt(json['id']),
      userId: 0,
      coinId: coinId,
      changePct: changePct,
      alertDirection: alertDirection,
      frequency: frequency,
      timeWindowMinutes: timeWindowMinutes,
      cooldownSeconds: cooldownSeconds,
      isActive: isActive,
      conditionMet: false,
      lastAlertAt: lastAlertAt,
    );
  }

  final int id;
  final int userId;
  final String coinId;
  final double changePct;
  final String alertDirection;
  final String frequency;
  final int timeWindowMinutes;
  final int cooldownSeconds;
  final bool isActive;
  final bool conditionMet;
  final DateTime? lastAlertAt;

  String get timeWindowLabel => timeWindowMinutes == 1440 ? '24h' : '1h';
  bool get isRepeat => frequency == 'repeat';
  bool get isAbove => alertDirection == 'above';
}
