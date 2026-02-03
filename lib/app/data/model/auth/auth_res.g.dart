// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthRes _$AuthResFromJson(Map<String, dynamic> json) => AuthRes(
  token: json['token'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthResToJson(AuthRes instance) => <String, dynamic>{
  'token': instance.token,
  'user': instance.user,
};
