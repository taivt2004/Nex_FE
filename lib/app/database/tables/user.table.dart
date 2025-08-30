import 'package:drift/drift.dart';

class Users extends Table {
  IntColumn get id => integer()();
  TextColumn get username => text()();
  TextColumn get fullname => text().nullable()();
  IntColumn get vip => integer().nullable()();
  TextColumn get avatar => text().nullable()();
  IntColumn get balance => integer().nullable()();
  TextColumn get sex => text().nullable()();
  TextColumn get nationality => text().nullable()();
  TextColumn get birthday => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
