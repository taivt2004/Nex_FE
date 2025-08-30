import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/core/data/localstore/app.config.local.dart';
import 'package:nexpaylab/app/core/data/model/app.config.dart';
import 'package:nexpaylab/app/core/data/service/api.dart';
import 'package:nexpaylab/constants.dart';
import 'package:nexpaylab/share/utils/result.dart';
import 'package:nexpaylab/share/utils/strings.dart';

mixin AppConfigRepository {
  Future<Result<List<ConfigItem>>> getAppConfigs();
}

@Injectable(as: AppConfigRepository)
class AppConfigRepositoryImp implements AppConfigRepository {
  AppConfigRepositoryImp(
    this.localStore,
    this.apiService,
  );

  final ApiService apiService;
  final AppConfigLocalStore localStore;

  @override
  Future<Result<List<ConfigItem>>> getAppConfigs() async {
    return Result.guardFuture(() async {
      final keys =
          '${toStrings(userConfigKeys)},${toStrings(systemConfigKeys)}';
      final configs = await apiService.getAppConfigs(keys);
      await localStore.saveInBatch(configs);
      return configs;
    });
  }
}
