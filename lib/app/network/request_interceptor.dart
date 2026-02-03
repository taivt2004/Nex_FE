import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/service/local_storage_service.dart';

@injectable
class RequestInterceptor extends Interceptor {
  RequestInterceptor(this._localStorageService);

  final LocalStorageService _localStorageService;
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-device-type'] = Platform.isIOS ? 'IOS' : 'Android';
    options.headers['Accept-Language'] = _localStorageService.getString('app_language') ?? 'en';
    super.onRequest(options, handler);
  }
}
