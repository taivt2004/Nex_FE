// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i409;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:nexpaylab/app/data/repository/app_config_repos.dart' as _i282;
import 'package:nexpaylab/app/data/repository/coin_repos.dart' as _i117;
import 'package:nexpaylab/app/data/repository/user_repos.dart' as _i514;
import 'package:nexpaylab/app/data/service/api.dart' as _i833;
import 'package:nexpaylab/app/data/service/local_storage_service.dart' as _i411;
import 'package:nexpaylab/app/database/app_config_local.dart' as _i338;
import 'package:nexpaylab/app/database/database.dart' as _i867;
import 'package:nexpaylab/app/database/user_local.dart' as _i260;
import 'package:nexpaylab/app/di/app_module.dart' as _i566;
import 'package:nexpaylab/app/network/auth_interceptor.dart' as _i710;
import 'package:nexpaylab/app/network/network_checker.dart' as _i459;
import 'package:nexpaylab/app/network/request_interceptor.dart' as _i548;
import 'package:nexpaylab/app/session/user_session.dart' as _i75;
import 'package:nexpaylab/features/auth/presentation/bloc/register_bloc.dart'
    as _i717;
import 'package:nexpaylab/features/auth/presentation/page/login_page.dart'
    as _i1020;
import 'package:nexpaylab/features/auth/presentation/page/register_page.dart'
    as _i744;
import 'package:nexpaylab/features/home/coinmarket/marketplace_bloc/marketplace_bloc.dart'
    as _i350;
import 'package:nexpaylab/features/home/presentation/bloc/home_bloc.dart'
    as _i120;
import 'package:nexpaylab/shared/language/language_model.dart' as _i846;
import 'package:nexpaylab/shared/theme/theme_mode.dart' as _i805;
import 'package:nexpaylab/shared/ui/app_lifecycle.dart' as _i458;
import 'package:nexpaylab/shared/utils/device_collector.dart' as _i973;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => appModule.prefs,
      preResolve: true,
    );
    gh.factory<_i973.DeviceInfoCollector>(() => _i973.DeviceInfoCollector());
    gh.singleton<_i867.Database>(() => appModule.database);
    gh.singleton<_i411.LocalStorageService>(
      () => appModule.localStorageService,
    );
    gh.singleton<_i458.AppLifecycle>(() => _i458.AppLifecycle());
    gh.lazySingleton<_i805.ThemeModel>(() => appModule.themeModel);
    gh.lazySingleton<_i846.LanguageModel>(() => appModule.languageModel);
    gh.lazySingleton<_i833.ApiService>(() => appModule.apiService);
    gh.lazySingleton<_i459.NetworkStateStream>(
      () => _i459.NetworkStateStream(),
    );
    gh.lazySingleton<_i75.UserSessionStream>(() => _i75.UserSessionStream());
    gh.singleton<_i459.NetworkChecker>(
      () => _i459.NetworkChecker(gh<_i459.NetworkStateStream>()),
    );
    gh.factory<_i548.RequestInterceptor>(
      () => _i548.RequestInterceptor(gh<_i411.LocalStorageService>()),
    );
    gh.factory<_i1020.LoginPage>(() => _i1020.LoginPage(key: gh<_i409.Key>()));
    gh.factory<_i744.RegisterPage>(
      () => _i744.RegisterPage(key: gh<_i409.Key>()),
    );
    gh.factory<_i338.AppConfigLocalStore>(
      () => _i338.AppConfigLocalStoreImp(db: gh<_i867.Database>()),
    );
    gh.factory<_i117.CoinRepository>(
      () => _i117.CoinRepositoryImp(apiService: gh<_i833.ApiService>()),
    );
    gh.factory<_i350.MarketplaceBloc>(
      () => _i350.MarketplaceBloc(gh<_i117.CoinRepository>()),
    );
    gh.factory<_i260.UserLocalStore>(
      () => _i260.UserLocalStoreImp(database: gh<_i867.Database>()),
    );
    gh.factory<_i282.AppConfigRepository>(
      () => _i282.AppConfigRepositoryImp(
        gh<_i338.AppConfigLocalStore>(),
        gh<_i833.ApiService>(),
      ),
    );
    gh.factory<_i514.UserRepository>(
      () => _i514.UserRepositoryImp(
        gh<_i260.UserLocalStore>(),
        appConfigLocalStore: gh<_i338.AppConfigLocalStore>(),
        apiService: gh<_i833.ApiService>(),
      ),
    );
    gh.lazySingleton<_i75.UserSession>(
      () => _i75.UserSession(
        gh<_i338.AppConfigLocalStore>(),
        gh<_i75.UserSessionStream>(),
        gh<_i260.UserLocalStore>(),
      ),
    );
    gh.factory<_i710.AuthInterceptor>(
      () => _i710.AuthInterceptor(
        gh<_i75.UserSession>(),
        appConfigRepository: gh<_i338.AppConfigLocalStore>(),
      ),
    );
    gh.factory<_i120.HomeBloc>(
      () => _i120.HomeBloc(
        gh<_i282.AppConfigRepository>(),
        gh<_i459.NetworkChecker>(),
        gh<_i338.AppConfigLocalStore>(),
        gh<_i75.UserSession>(),
      ),
    );
    gh.factory<_i717.RegisterBloc>(
      () => _i717.RegisterBloc(
        gh<_i514.UserRepository>(),
        gh<_i75.UserSession>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i566.AppModule {}
