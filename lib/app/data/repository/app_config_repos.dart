import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/localstore/app_config_local_store.dart';
import 'package:nexpaylab/app/data/model/common/config_item_res.dart';
import 'package:nexpaylab/app/data/service/api.dart';
import 'package:nexpaylab/shared/utils/result.dart';

mixin AppConfigRepository {
  Future<Result<Map<String, String>>> getAppConfigs(List<String> keys);
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
  Future<Result<Map<String, String>>> getAppConfigs(List<String> keys) async {
    return Result.guardFuture(() async {
      final keysStr = keys.join(',');
      final res = await apiService.getAppConfigs(keysStr);
      final configsMap = res.data?.configs ?? <String, dynamic>{};
      
      final configs = configsMap.map((key, value) => MapEntry(key, value.toString()));

      await localStore.saveInBatch(configs.entries.map((e) => ConfigItemRes(key: e.key, value: e.value)).toList());
      return configs;  
    });
  }
}
