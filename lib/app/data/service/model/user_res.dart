import 'package:json_annotation/json_annotation.dart';
import 'package:nexpaylab/app/data/model/user.dart';

part 'user_res.g.dart';

@JsonSerializable()
class UserResponse {
  UserResponse({required this.token, required this.user});

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  final String token;
  final User user;

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
