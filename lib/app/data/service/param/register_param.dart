import 'package:json_annotation/json_annotation.dart';

part 'register_param.g.dart';

@JsonSerializable()
class RegisterParam {
  RegisterParam({required this.username, required this.password});

  factory RegisterParam.fromJson(Map<String, dynamic> json) => _$RegisterParamFromJson(json);

  final String username;
  final String password;

  Map<String, dynamic> toJson() => _$RegisterParamToJson(this);
}
