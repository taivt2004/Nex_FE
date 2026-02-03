import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';
import 'package:nexpaylab/app/session/user_session.dart';
import 'package:nexpaylab/shared/constants/core_constants.dart';
import 'package:nexpaylab/shared/logger.dart';

@injectable
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this.userSession, {required this.appConfigRepository});

  final AppConfigLocalStore appConfigRepository;
  final UserSession userSession;

  Future<String?> getToken() async {
    final tokenConfig =
        await appConfigRepository.getConfigByKey(tokenKey).getSingleOrNull();
    return tokenConfig?.value ?? '';
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers['Authorization'] = 'Bearer ${await getToken()}';

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    talker.debug('onError ${err.type} ${err.response?.statusCode}');
    if (err.response?.statusCode == 401) {
      _expiredToken();
    }
    super.onError(err, handler);
  }

  void _expiredToken() {
    userSession.clearSession();
  }
}
