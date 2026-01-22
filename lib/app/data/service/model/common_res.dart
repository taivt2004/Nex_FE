import 'package:json_annotation/json_annotation.dart';

part 'common_res.g.dart';

@JsonSerializable()
class CommonRes {
  CommonRes(this.message, this.code);

  factory CommonRes.fromJson(Map<String, dynamic> json) => _$CommonResFromJson(json);
  final String message;
  final int code;

  Map<String, dynamic> toJson() => _$CommonResToJson(this);
}
