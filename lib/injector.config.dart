// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i409;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:nexpaylab/app/core/data/localstore/app.config.local.dart'
    as _i774;
import 'package:nexpaylab/app/core/data/localstore/user.local.dart' as _i107;
import 'package:nexpaylab/app/core/data/repository/app.config.repos.dart'
    as _i563;
import 'package:nexpaylab/app/core/data/repository/user.repos.dart' as _i496;
import 'package:nexpaylab/app/core/data/service/api.dart' as _i289;
import 'package:nexpaylab/app/core/network.checker.dart' as _i715;
import 'package:nexpaylab/app/core/network/auth_interceptor.dart' as _i881;
import 'package:nexpaylab/app/core/network/request_interceptor.dart' as _i697;
import 'package:nexpaylab/app/core/user.session.dart' as _i505;
import 'package:nexpaylab/app/database/database.dart' as _i867;
import 'package:nexpaylab/app/di/app_module.dart' as _i566;
import 'package:nexpaylab/feature/home/presentation/bloc/home_bloc.dart'
    as _i554;
import 'package:nexpaylab/feature/login.register/bloc/login_bloc.dart' as _i894;
import 'package:nexpaylab/feature/login.register/bloc/register_bloc.dart'
    as _i444;
import 'package:nexpaylab/feature/login.register/page/login.page.dart' as _i23;
import 'package:nexpaylab/feature/login.register/page/register.page.dart'
    as _i794;
import 'package:nexpaylab/share/theme/theme.mode.dart' as _i466;
import 'package:nexpaylab/share/ui/app.lifecycle.dart' as _i1031;
import 'package:nexpaylab/share/utils/device.collector.dart' as _i844;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i697.RequestInterceptor>(() => _i697.RequestInterceptor());
    gh.factory<_i844.DeviceInfoCollector>(() => _i844.DeviceInfoCollector());
    gh.singleton<_i867.Database>(() => appModule.database);
    gh.singleton<_i1031.AppLifecycle>(() => _i1031.AppLifecycle());
    await gh.lazySingletonAsync<_i460.SharedPreferences>(
      () => appModule.sharedPreference,
      preResolve: true,
    );
    gh.lazySingleton<_i466.ThemeModel>(() => appModule.appTheme);
    gh.lazySingleton<_i289.ApiService>(() => appModule.apiService);
    gh.lazySingleton<_i505.UserSessionStream>(() => _i505.UserSessionStream());
    gh.lazySingleton<_i715.NetworkStateStream>(
      () => _i715.NetworkStateStream(),
    );
    gh.factory<_i774.AppConfigLocalStore>(
      () => _i774.AppConfigLocalStoreImp(db: gh<_i867.Database>()),
    );
    gh.factory<_i23.LoginPage>(() => _i23.LoginPage(key: gh<_i409.Key>()));
    gh.factory<_i794.RegisterPage>(
      () => _i794.RegisterPage(key: gh<_i409.Key>()),
    );
    gh.factory<_i107.UserLocalStore>(
      () => _i107.UserLocalStoreImp(database: gh<_i867.Database>()),
    );
    gh.singleton<_i715.NetworkChecker>(
      () => _i715.NetworkChecker(gh<_i715.NetworkStateStream>()),
    );
    gh.factory<_i563.AppConfigRepository>(
      () => _i563.AppConfigRepositoryImp(
        gh<_i774.AppConfigLocalStore>(),
        gh<_i289.ApiService>(),
      ),
    );
    gh.lazySingleton<_i505.UserSession>(
      () => _i505.UserSession(
        gh<_i774.AppConfigLocalStore>(),
        gh<_i505.UserSessionStream>(),
        gh<_i107.UserLocalStore>(),
      ),
    );
    gh.factory<_i496.UserRepository>(
      () => _i496.UserRepositoryImp(
        gh<_i107.UserLocalStore>(),
        appConfigLocalStore: gh<_i774.AppConfigLocalStore>(),
        apiService: gh<_i289.ApiService>(),
      ),
    );
    gh.factory<_i554.HomeBloc>(
      () => _i554.HomeBloc(
        gh<_i563.AppConfigRepository>(),
        gh<_i715.NetworkChecker>(),
        gh<_i774.AppConfigLocalStore>(),
        gh<_i505.UserSession>(),
      ),
    );
    gh.factory<_i881.AuthInterceptor>(
      () => _i881.AuthInterceptor(
        gh<_i505.UserSession>(),
        appConfigRepository: gh<_i774.AppConfigLocalStore>(),
      ),
    );
    gh.factory<_i894.LoginBloc>(
      () =>
          _i894.LoginBloc(gh<_i496.UserRepository>(), gh<_i505.UserSession>()),
    );
    gh.factory<_i444.RegisterBloc>(
      () => _i444.RegisterBloc(
        gh<_i496.UserRepository>(),
        gh<_i505.UserSession>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i566.AppModule {}
