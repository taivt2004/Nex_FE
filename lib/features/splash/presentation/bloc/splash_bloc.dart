import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/repository/app_config_repos.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';
import 'package:nexpaylab/shared/constants/core_constants.dart';
import 'package:nexpaylab/shared/utils/result.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'splash_event.dart';
part 'splash_state.dart';

@injectable
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(this._appConfigRepository, this._appConfigLocalStore)
      : super(const SplashState()) {
    on<SplashStarted>(_onSplashStarted);
    on<SplashSkippedUpdate>(_onSplashSkippedUpdate);
  }

  final AppConfigRepository _appConfigRepository;
  final AppConfigLocalStore _appConfigLocalStore;

  Future<void> _onSplashStarted(
      SplashStarted event, Emitter<SplashState> emit) async {
    emit(state.copyWith(status: SplashStatus.loading));
    try {
      // 1. Fetch Configs
      final result = await _appConfigRepository.getAppConfigs([
        keyLatestAppVersion,
        keyForceAppUpdate,
        keyStoreUrlIos,
        keyStoreUrlAndroid,
      ]);

      await result.when(
        success: (configs) async {
          // 2. Check Version
          final packageInfo = await PackageInfo.fromPlatform();
          final currentVersion = packageInfo.version;

          final latestVersion = configs[keyLatestAppVersion]?.toString();
          final forceUpdate = configs[keyForceAppUpdate]?.toString() == 'on';

          final storeUrl = Platform.isAndroid
              ? configs[keyStoreUrlAndroid]?.toString()
              : configs[keyStoreUrlIos]?.toString();

          if (_isUpdateRequired(currentVersion, latestVersion)) {
            emit(state.copyWith(
              status: SplashStatus.updateRequired,
              storeUrl: storeUrl,
              isForceUpdate: forceUpdate,
            ));
            return;
          }
          await _checkAuthAndNavigate(emit);
        },
        failure: (e) async {
          emit(state.copyWith(status: SplashStatus.unauthenticated));
        },
      );
    } catch (e) {
      emit(state.copyWith(
          status: SplashStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onSplashSkippedUpdate(
      SplashSkippedUpdate event, Emitter<SplashState> emit) async {
    await _checkAuthAndNavigate(emit);
  }

  Future<void> _checkAuthAndNavigate(Emitter<SplashState> emit) async {
    // 3. Check Auth / Wallet
    final passphraseConfig = await _appConfigLocalStore
        .getConfigByKey(keyLocalPassphrase)
        .getSingleOrNull();

    if (passphraseConfig != null && passphraseConfig.value.isNotEmpty) {
      emit(state.copyWith(status: SplashStatus.authenticated));
    } else {
      emit(state.copyWith(status: SplashStatus.unauthenticated));
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
