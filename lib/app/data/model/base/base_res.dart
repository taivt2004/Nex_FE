import 'package:json_annotation/json_annotation.dart';
import 'package:nexpaylab/app/data/model/base/meta.dart';

part 'base_res.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseRes<T> {
  BaseRes({
    required this.code,
    required this.message,
    this.success,
    this.data,
    this.meta,
  });
  
  factory BaseRes.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResFromJson(json, fromJsonT);

  final bool? success;
  final int code;
  final String message;
  final T? data;
  final Meta? meta;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseResToJson(this, toJsonT);
}
