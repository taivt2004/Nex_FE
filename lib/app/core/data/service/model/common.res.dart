import 'package:json_annotation/json_annotation.dart';

part 'common.res.g.dart';

@JsonSerializable()
class CommondRes {
  CommondRes(this.message, this.code);

  factory CommondRes.fromJson(Map<String, dynamic> json) => _$CommondResFromJson(json);
  final String message;
  final int code;

  Map<String, dynamic> toJson() => _$CommondResToJson(this);
}
