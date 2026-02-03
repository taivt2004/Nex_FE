import 'package:json_annotation/json_annotation.dart';
import 'package:nexpaylab/app/data/model/user/user.dart';

part 'auth_res.g.dart';

@JsonSerializable()
class AuthRes {
  AuthRes({required this.token, required this.user});

  factory AuthRes.fromJson(Map<String, dynamic> json) =>
      _$AuthResFromJson(json);

  final String token;
  final User user;

  Map<String, dynamic> toJson() => _$AuthResToJson(this);
}
