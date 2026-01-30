import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/common/app_config.dart';
import 'package:nexpaylab/app/database/database.dart';

abstract class AppConfigLocalStore {
  SingleOrNullSelectable<ConfigItemRes?> getConfigByKey(String key);
  SingleOrNullSelectable<dynamic> getValueByKey(String key);
  Future<void> saveInBatch(List<ConfigItemRes> configs);
  Future<int> saveValue(String key, String value);
  Future<int> clearConfig(String key);
  Future<int> clearConfigAll();
  Stream<List<AppConfig>> watchConfigs(List<String> keys);
}

@Injectable(as: AppConfigLocalStore)
class AppConfigLocalStoreImp extends AppConfigLocalStore {
  AppConfigLocalStoreImp({required this.db});

  final Database db;

  @override
  SingleOrNullSelectable<ConfigItemRes?> getConfigByKey(String key) {
    final query = db.select(db.appConfigs)..where((t) => t.key.equals(key));
    return query.map((it) {
      return ConfigItemRes(key: it.key, value: it.value);
    });
  }

    @override
  Stream<List<AppConfig>> watchConfigs(List<String> keys) {
    return (db.select(db.appConfigs)..where((tbl) => tbl.key.isIn(keys))).watch();
  }


  @override
  SingleOrNullSelectable<dynamic> getValueByKey(String key) {
    final query = db.select(db.appConfigs)..where((t) => t.key.equals(key));
    return query;
  }

  @override
  Future<void> saveInBatch(List<ConfigItemRes> configs) async {
    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.appConfigs,
        configs
            .map(
              (it) => AppConfig(
                key: it.key,
                value: it.value,
              ),
            )
            .toList(),
      );
    });
  }

  @override
  Future<int> clearConfig(String key) {
    return (db.delete(db.appConfigs)..where((t) => t.key.equals(key))).go();
  }

  @override
  Future<int> saveValue(String key, String value) {
    return db.into(db.appConfigs).insertOnConflictUpdate(
          AppConfig(
            key: key,
            value: value,
          ),
        );
  }

  @override
  Future<int> clearConfigAll() {
    return db.delete(db.appConfigs).go();
  }
}
