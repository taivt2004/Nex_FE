class AlertUser {
  const AlertUser({
    required this.id,
    required this.externalId,
    required this.email,
    required this.displayName,
  });

  factory AlertUser.fromJson(Map<String, dynamic> json) {
    return AlertUser(
      id: (json['id'] as num?)?.toInt() ?? 0,
      externalId: json['externalId']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
    );
  }

  final int id;
  final String externalId;
  final String email;
  final String displayName;
}
