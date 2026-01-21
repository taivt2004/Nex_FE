import 'package:json_annotation/json_annotation.dart';
part 'app_config.g.dart';

@JsonSerializable()
class ConfigItem {
  ConfigItem({required this.key, required this.value});

  factory ConfigItem.fromJson(Map<String, dynamic> json) => _$ConfigItemFromJson(json);

  final String key;
  final String value;

  Map<String, dynamic> toJson() => _$ConfigItemToJson(this);

  static Map<String, dynamic> listToMap(List<ConfigItem> items) {
    final result = <String, dynamic>{};
    for (final item in items) {
      result[item.key] = item.value;
    }
    return result;
  }
}
