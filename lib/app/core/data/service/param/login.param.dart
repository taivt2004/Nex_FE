import 'package:json_annotation/json_annotation.dart';

part 'login.param.g.dart';

@JsonSerializable()
class LoginParam {
  LoginParam({required this.username, required this.password});

  factory LoginParam.fromJson(Map<String, dynamic> json) => _$LoginParamFromJson(json);

  final String username;
  final String password;

  Map<String, dynamic> toJson() => _$LoginParamToJson(this);
}
