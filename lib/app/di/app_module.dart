import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/service/api.dart';
import 'package:nexpaylab/app/data/service/local_storage_service.dart';
import 'package:nexpaylab/app/database/database.dart';
import 'package:nexpaylab/app/di/dependency_injection.dart';
import 'package:nexpaylab/app/network/auth_interceptor.dart';
import 'package:nexpaylab/app/network/dio_client.dart';
import 'package:nexpaylab/app/network/request_interceptor.dart';
import 'package:nexpaylab/shared/constants/core_constants.dart';
import 'package:nexpaylab/shared/language/language_model.dart';
import 'package:nexpaylab/shared/theme/theme_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class AppModule {
  @singleton
  Database get database => Database();

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @singleton
  LocalStorageService get localStorageService =>
      SharedPreferencesService(getIt<SharedPreferences>());
  
  @lazySingleton
  ThemeModel get themeModel => ThemeModel(getIt<LocalStorageService>());
  
  @lazySingleton
  LanguageModel get languageModel => LanguageModel(getIt<LocalStorageService>());

  @lazySingleton
  ApiService get apiService => ApiService(
    DioClient.build([getIt<AuthInterceptor>(), getIt<RequestInterceptor>()]),
    baseUrl: coinServiceURL,
  );
}
