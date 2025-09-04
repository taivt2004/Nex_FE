import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class RequestInterceptor extends Interceptor {
  RequestInterceptor();
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['x-device-type'] = Platform.isIOS ? 'IOS' : 'Android';
    super.onRequest(options, handler);
  }
}
