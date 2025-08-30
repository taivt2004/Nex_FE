// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num).toInt(),
  username: json['username'] as String,
  balance: (json['balance'] as num?)?.toInt(),
  fullname: json['fullname'] as String?,
  vip: (json['vip'] as num?)?.toInt(),
  avatar: json['avatar'] as String?,
  sex: json['sex'] as String?,
  nationality: json['nationality'] as String?,
  birthday: json['birthday'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  address: json['address'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'fullname': instance.fullname,
  'avatar': instance.avatar,
  'vip': instance.vip,
  'balance': instance.balance,
  'sex': instance.sex,
  'nationality': instance.nationality,
  'birthday': instance.birthday,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
};
