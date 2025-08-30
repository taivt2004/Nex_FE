import 'package:json_annotation/json_annotation.dart';
part 'app.config.g.dart';

@JsonSerializable()
class ConfigItem {
  final String key;
  final String value;

  ConfigItem({required this.key, required this.value});

  factory ConfigItem.fromJson(Map<String, dynamic> json) => _$ConfigItemFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigItemToJson(this);

  static Map<String, dynamic> listToMap(List<ConfigItem> items) {
    final Map<String, dynamic> result = {};
    for (var item in items) {
      result[item.key] = item.value;
    }
    return result;
  }
}
