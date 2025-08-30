class UserAuth {
  UserAuth({
    required this.token,
    required this.userId,
  });

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      token: json['token'] as String,
      userId: json['userId'] as int,
    );
  }
  final String token;
  final int userId;

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'userId': userId,
    };
  }
}
