import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  static Dio build(List<Interceptor> interceptors) {
    final options = BaseOptions(
      contentType: 'application/json',
      responseType: ResponseType.json,
    )
      ..connectTimeout = const Duration(seconds: 60000)
      ..sendTimeout = const Duration(seconds: 60000)
      ..receiveTimeout = const Duration(seconds: 60000);

    final cacheOptions = CacheOptions(
      // A default store is required for interceptor.
      store: MemCacheStore(),

      // All subsequent fields are optional to get a standard behaviour.

      // Default.
      policy: CachePolicy.request,
      // Returns a cached response on error for given status codes.
      // Defaults to `[]`.
      hitCacheOnErrorCodes: const [500],
      // Allows to return a cached response on network errors (e.g. offline usage).
      // Defaults to `false`.
      hitCacheOnNetworkFailure: true,
      // Overrides any HTTP directive to delete entry past this duration.
      // Useful only when origin server has no cache config or custom behaviour is desired.
      // Defaults to `null`.
      maxStale: const Duration(days: 7),
      // Default. Allows 3 cache sets and ease cleanup.
      priority: CachePriority.normal,
      // Default. Body and headers encryption with your own algorithm.
      cipher: null,
      // Default. Key builder to retrieve requests.
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      // Default. Allows to cache POST requests.
      // Assigning a [keyBuilder] is strongly recommended when `true`.
      allowPostMethod: false,
    );

    if (kDebugMode) {
      interceptors.addAll(
        [
          PrettyDioLogger(
            // request: true,
            // requestHeader: true,
            // requestBody: true,
            responseHeader: false,
            error: true,
            compact: true,
          ),
        ],
      );
    }

    interceptors.add(DioCacheInterceptor(options: cacheOptions));

    final dio = Dio(options)..interceptors.addAll(interceptors);
    return dio;
  }
}
