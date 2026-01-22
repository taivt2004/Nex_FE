import 'package:json_annotation/json_annotation.dart';

part 'register_req.g.dart';

@JsonSerializable()
class RegisterReq {
  RegisterReq({required this.username, required this.password});

  factory RegisterReq.fromJson(Map<String, dynamic> json) => _$RegisterReqFromJson(json);

  final String username;
  final String password;

  Map<String, dynamic> toJson() => _$RegisterReqToJson(this);
}
