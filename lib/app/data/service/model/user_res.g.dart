// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRes _$UserResFromJson(Map<String, dynamic> json) => UserRes(
  token: json['token'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserResToJson(UserRes instance) => <String, dynamic>{
  'token': instance.token,
  'user': instance.user,
};
