import 'package:json_annotation/json_annotation.dart';
part 'app_config.g.dart';

@JsonSerializable()
class ConfigItemRes {
  ConfigItemRes({required this.key, required this.value});

  factory ConfigItemRes.fromJson(Map<String, dynamic> json) => _$ConfigItemResFromJson(json);

  final String key;
  final String value;

  Map<String, dynamic> toJson() => _$ConfigItemResToJson(this);

  static Map<String, dynamic> listToMap(List<ConfigItemRes> items) {
    final result = <String, dynamic>{};
    for (final item in items) {
      result[item.key] = item.value;
    }
    return result;
  }
}

@JsonSerializable()
class ConfigItemReq {
  ConfigItemReq({required this.key, required this.value});

  factory ConfigItemReq.fromJson(Map<String, dynamic> json) => _$ConfigItemReqFromJson(json);

  final String key;
  final String value;

  Map<String, dynamic> toJson() => _$ConfigItemReqToJson(this);
}
