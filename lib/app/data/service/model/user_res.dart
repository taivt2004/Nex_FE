import 'package:json_annotation/json_annotation.dart';
import 'package:nexpaylab/app/data/model/user.dart';

part 'user_res.g.dart';

@JsonSerializable()
class UserRes {
  UserRes({required this.token, required this.user});

  factory UserRes.fromJson(Map<String, dynamic> json) =>
      _$UserResFromJson(json);

  final String token;
  final User user;

  Map<String, dynamic> toJson() => _$UserResToJson(this);
}
