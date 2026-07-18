import 'package:dio/dio.dart';
import 'package:nexpaylab/app/data/model/alert/create_alert_request.dart';

class AlertApiService {
  AlertApiService(this._dio, {required this.baseUrl});

  final Dio _dio;
  final String baseUrl;

  Future<Map<String, dynamic>> login({
    String? email,
    String? externalId,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${baseUrl}v1/auth/login',
      data: {
        if (email != null && email.isNotEmpty) 'email': email,
        if (externalId != null && externalId.isNotEmpty) 'externalId': externalId,
      },
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> createAlert(CreateAlertRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${baseUrl}v1/alerts/subscribe',
      data: request.toJson(),
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> getUserAlerts(int userId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${baseUrl}v1/alerts/my-subscriptions/$userId',
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> getUserAlertsByCoin(int userId, String coinId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${baseUrl}v1/alerts/my-subscriptions/$userId/$coinId',
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> getAlertEvents(int userId, {int limit = 50}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${baseUrl}v1/alerts/events/$userId',
      queryParameters: {'limit': limit},
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> updateAlert(
    int id,
    Map<String, dynamic> payload,
  ) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '${baseUrl}v1/alerts/subscription/$id',
      data: payload,
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> deleteAlert(int id) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      '${baseUrl}v1/alerts/subscription/$id',
    );
    return response.data ?? <String, dynamic>{};
  }
}
