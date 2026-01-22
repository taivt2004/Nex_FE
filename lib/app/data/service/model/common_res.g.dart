// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommonRes _$CommonResFromJson(Map<String, dynamic> json) =>
    CommonRes(json['message'] as String, (json['code'] as num).toInt());

Map<String, dynamic> _$CommonResToJson(CommonRes instance) => <String, dynamic>{
  'message': instance.message,
  'code': instance.code,
};
