import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nexpaylab/app/database/tables/config_table.dart';
import 'package:nexpaylab/app/database/tables/user_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart' as sql;

part 'database.g.dart';

const _appSecretKeyStorageKey = 'app_secret_key';

@DriftDatabase(tables: [AppConfigs, Users])
class Database extends _$Database {
  Database() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  final rootIsolateToken = RootIsolateToken.instance!;
  return LazyDatabase(() async {
    final dbKey = await _obtainOrCreateDbKey();
    await _setupSqlCipher();
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Check if the database file is valid (encrypted with the correct key)
    if (file.existsSync()) {
      try {
        final db = sql.sqlite3.open(file.path);
        try {
          final escapedKey = dbKey.replaceAll("'", "''");
          db
            ..execute("PRAGMA key = '$escapedKey';")
            ..select('SELECT count(*) FROM sqlite_master');
        } finally {
          db.dispose();
        }
      } on sql.SqliteException catch (e) {
        // Code 26: SQLITE_NOTADB (File is not a database)
        // Code 11: SQLITE_CORRUPT (Database disk image is malformed)
        if (e.resultCode == 26 || e.resultCode == 11) {
          try {
            await file.delete();
          } catch (_) {
            // Ignore delete errors
          }
        }
      } catch (_) {
        // Fallback for other errors: try to delete if we can't open/read
        try {
          await file.delete();
        } catch (_) {}
      }
    }

    return NativeDatabase.createInBackground(
      file,
      isolateSetup: () async {
        BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
        await _setupSqlCipher();
      },
      setup: (rawDb) {
        final escapedKey = dbKey.replaceAll("'", "''");
        rawDb.execute("PRAGMA key = '$escapedKey';");
        rawDb.config.doubleQuotedStringLiterals = false;
      },
    );
  });
}

Future<String> _obtainOrCreateDbKey() async {
  const storage = FlutterSecureStorage();
  final existing = await storage.read(key: _appSecretKeyStorageKey);
  if (existing != null && existing.isNotEmpty) {
    return existing;
  }

  final random = Random.secure();
  final bytes = List<int>.generate(32, (_) => random.nextInt(256));
  final key = base64UrlEncode(bytes);
  
  await storage.write(key: _appSecretKeyStorageKey, value: key);
  return key;
}

Future<void> _setupSqlCipher() async {
  if (Platform.isAndroid) {
    await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
    open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
  } else if (Platform.isIOS) {
    // Force SQLCipher on iOS
    open.overrideFor(OperatingSystem.iOS, DynamicLibrary.process);
  }
}
