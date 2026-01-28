import 'package:json_annotation/json_annotation.dart';

part 'login_req.g.dart';

@JsonSerializable()
class LoginReq {
  LoginReq({required this.username, required this.password});

  factory LoginReq.fromJson(Map<String, dynamic> json) => _$LoginReqFromJson(json);

  final String username;
  final String password;
  
  Map<String, dynamic> toJson() => _$LoginReqToJson(this);
}
