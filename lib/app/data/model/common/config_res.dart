import 'package:json_annotation/json_annotation.dart';

part 'config_res.g.dart';

@JsonSerializable()
class ConfigRes {
  ConfigRes({this.configs});
  

  factory ConfigRes.fromJson(Map<String, dynamic> json) => _$ConfigResFromJson(json);
  final Map<String, dynamic>? configs;
  Map<String, dynamic> toJson() => _$ConfigResToJson(this);
}
