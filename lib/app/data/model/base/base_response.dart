import 'package:json_annotation/json_annotation.dart';
import 'package:nexpaylab/app/data/model/base/meta.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  BaseResponse({
    required this.code,
    required this.message,
    this.success,
    this.data,
    this.meta,
  });
  
  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$BaseResponseFromJson(json, fromJsonT);

  final bool? success;
  final int code;
  final String message;
  final T? data;
  final Meta? meta;

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);
}
