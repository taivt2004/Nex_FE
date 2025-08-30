import 'package:json_annotation/json_annotation.dart';
import 'package:nexpaylab/app/database/database.dart' as data;

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    required this.id,
    required this.username,
    this.balance,
    this.fullname,
    this.vip,
    this.avatar,
    this.sex,
    this.nationality,
    this.birthday,
    this.phone,
    this.email,
    this.address,
  });

  factory User.fromData(data.User it) {
    return User(
      id: it.id,
      username: it.username,
      vip: it.vip,
      avatar: it.avatar,
      fullname: it.fullname,
      balance: it.balance,
      sex: it.sex,
      nationality: it.nationality,
      birthday: it.birthday,
      phone: it.phone,
      email: it.email,
      address: it.address,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  final int id;
  final String username;
  final String? fullname;
  String? avatar;
  final int? vip;
  int? balance;
  final String? sex;
  final String? nationality;
  final String? birthday;
  final String? phone;
  final String? email;
  final String? address;

  Map<String, dynamic> toJson() => _$UserToJson(this);

  data.User toData() {
    return data.User(
      id: id,
      username: username,
      fullname: fullname,
      avatar: avatar,
      vip: vip,
      balance: balance,
      sex: sex,
      nationality: nationality,
      birthday: birthday,
      phone: phone,
      email: email,
      address: address,
    );
  }
}
