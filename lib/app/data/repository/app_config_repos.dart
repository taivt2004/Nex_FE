import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/common/app_config.dart';
import 'package:nexpaylab/app/data/service/api.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';
import 'package:nexpaylab/shared/constants/core_constants.dart';
import 'package:nexpaylab/shared/utils/result.dart';
import 'package:nexpaylab/shared/utils/string_utils.dart';

mixin AppConfigRepository {
  Future<Result<List<ConfigItemRes>>> getAppConfigs();
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
  Future<Result<List<ConfigItemRes>>> getAppConfigs() async {
    return Result.guardFuture(() async {
      final keys =
          '${toStrings(userConfigKeys)},${toStrings(systemConfigKeys)}';
      final configs = await apiService.getAppConfigs(keys);
      await localStore.saveInBatch(configs);
      return configs;
    });
  }
}
