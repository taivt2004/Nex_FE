import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/repository/app_config_repos.dart';
import 'package:nexpaylab/shared/constants/core_constants.dart';
import 'package:nexpaylab/shared/utils/result.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'app_config_event.dart';
part 'app_config_state.dart';

@injectable
class AppConfigBloc extends Bloc<AppConfigEvent, AppConfigState> {
  AppConfigBloc(this._appConfigRepository) : super(const AppConfigState()) {
    on<AppConfigStarted>(_onAppConfigStarted);
  }
  
  final AppConfigRepository _appConfigRepository;

  Future<void> _onAppConfigStarted(
    AppConfigStarted event,
    Emitter<AppConfigState> emit,
  ) async {
    emit(state.copyWith(status: AppConfigStatus.loading));
    try {
      final result = await _appConfigRepository.getAppConfigs([
        keyLatestAppVersion,
        keyForceAppUpdate,
        keyStoreUrlIos,
        keyStoreUrlAndroid,
      ]);

      await result.when(
        success: (Map<String, String> configs) async {
          final packageInfo = await PackageInfo.fromPlatform();
          final currentVersion = packageInfo.version;

          final latestVersion = configs[keyLatestAppVersion]?.toString();
          final forceUpdate = configs[keyForceAppUpdate]?.toString() == 'on';

          final storeUrl = Platform.isAndroid
              ? (configs[keyStoreUrlAndroid]?.isNotEmpty ?? false
                  ? configs[keyStoreUrlAndroid]!
                  : 'https://play.google.com/store/apps/details?id=${packageInfo.packageName}')
              : (configs[keyStoreUrlIos]?.isNotEmpty ?? false
                  ? configs[keyStoreUrlIos]!
                  : 'https://apps.apple.com/app/id6476123456'); // Replace with actual App ID when available

          if (_isUpdateRequired(currentVersion, latestVersion)) {
            emit(state.copyWith(
              status: AppConfigStatus.updateRequired,
              storeUrl: storeUrl,
              isForceUpdate: forceUpdate,
            ));
          } else {
            emit(state.copyWith(status: AppConfigStatus.success));
          }
        },
        failure: (e) async {
          // If config fetch fails, we usually proceed to app (maybe with default config)
          // or show error. Here assuming we proceed.
          emit(state.copyWith(status: AppConfigStatus.success));
        },
      );
    } catch (e) {
      emit(state.copyWith(status: AppConfigStatus.failure));
    }
  }

  bool _isUpdateRequired(String currentVersion, String? requiredVersion) {
    if (requiredVersion == null || requiredVersion.isEmpty) return false;
    try {
      final current = _parseVersion(currentVersion);
      final required = _parseVersion(requiredVersion);

      for (var i = 0; i < 3; i++) {
        final c = i < current.length ? current[i] : 0;
        final r = i < required.length ? required[i] : 0;
        if (c < r) return true;
        if (c > r) return false;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  List<int> _parseVersion(String version) {
    return version.split('.').map((e) => int.tryParse(e) ?? 0).toList();
  }
}
