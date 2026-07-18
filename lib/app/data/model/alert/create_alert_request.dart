class CreateAlertRequest {
  const CreateAlertRequest({
    required this.userId,
    required this.coinId,
    required this.alertDirection,
    required this.timeWindowMinutes,
    required this.changePct,
    required this.frequency,
    required this.cooldownSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'coinId': coinId,
      'alertDirection': alertDirection,
      'timeWindowMinutes': timeWindowMinutes,
      'changePct': changePct,
      'frequency': frequency,
      'cooldownSeconds': cooldownSeconds,
    };
  }

  final int userId;
  final String coinId;
  final String alertDirection;
  final int timeWindowMinutes;
  final double changePct;
  final String frequency;
  final int cooldownSeconds;
}
