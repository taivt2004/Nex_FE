import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/core/data/service/api.dart';
import 'package:nexpaylab/app/core/network/auth_interceptor.dart';
import 'package:nexpaylab/app/core/network/dio_client.dart';
import 'package:nexpaylab/app/core/network/request_interceptor.dart';
import 'package:nexpaylab/app/database/database.dart';
import 'package:nexpaylab/constants.dart';
import 'package:nexpaylab/injector.dart';
import 'package:nexpaylab/share/theme/theme.mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @singleton
  Database get database => Database();

  @lazySingleton
  @preResolve
  Future<SharedPreferences> get sharedPreference async =>
      SharedPreferences.getInstance();

  @lazySingleton
  ThemeModel get appTheme => ThemeModel();

  @lazySingleton
  ApiService get apiService => ApiService(
    DioClient.build([getIt<AuthInterceptor>(), getIt<RequestInterceptor>()]),
    baseUrl: baseUrlApiLocal,
  );
}
