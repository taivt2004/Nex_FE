import 'package:json_annotation/json_annotation.dart';

part 'meta.g.dart';

@JsonSerializable()
class Meta {
  Meta({
    required this.limit,
    required this.page,
    required this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  final int limit;
  final int page;
  final int total;

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
