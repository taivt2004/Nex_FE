import 'package:dio/dio.dart';
import 'package:nexpaylab/share/logger.dart';

enum ExceptServerity { normal, warning, critical }

class ExceptionHandler implements Exception {
  // Constructor with named parameters and default values
  ExceptionHandler({
    required String errorMessage,
    this.exceptServerity = ExceptServerity.warning,
  }) : _errorMessage = errorMessage;

  // Factory constructor for handling DioExceptions
  factory ExceptionHandler.dioException(DioException error) {
    final errorMessage = _getDioErrorMessage(error);
    final severity = _determineSeverity(error);

    return ExceptionHandler(
      errorMessage: errorMessage,
      exceptServerity: severity,
    );
  }

  final String _errorMessage;
  final ExceptServerity exceptServerity;

  // Getters to access private fields
  String get errorMessage => _errorMessage;
  ExceptServerity get serverity => exceptServerity;

  // Static method to map DioErrorType to user-friendly error messages
  static String _getDioErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return 'Request đã bị huỷ';
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Kết nối timeout';
      case DioExceptionType.sendTimeout:
        return 'Kết nối bị gián đoạn. Vui lòng kiểm tra lại kết nối mạng';
      case DioExceptionType.connectionError:
        return 'Kết nối mạng không ổn định';
      case DioExceptionType.badCertificate:
        return 'Lỗi chứng chỉ';
      case DioExceptionType.unknown:
        return 'Xử lý không thành công';
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
    }
  }

  // Static method to handle the specifics of bad responses
  static String _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;

    // Handle specific HTTP errors
    switch (statusCode) {
      case 304:
        return 'Chưa có dữ liệu mới'; // Not Modified
      case 503:
        return 'Hệ thống đang bận. Vui lòng quay lại sau';
      case 401:
        return 'Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại tài khoản';
      case 400:
        return _handleBadRequest(error);
      default:
        return _parseErrorMessage(error);
    }
  }

  // Helper method to parse error message for 400 responses
  static String _handleBadRequest(DioException error) {
    try {
      final res = error.response?.data as Map<String, dynamic>?;
      return (res?['error'] as String?) ??
          'Hệ thống đang bận. Vui lòng quay lại sau';
    } catch (e) {
      talker.warning('Error parsing bad response: $e');
      return 'Hệ thống đang bận. Vui lòng quay lại sau';
    }
  }

  // Helper method to parse generic error message for any error type
  static String _parseErrorMessage(DioException error) {
    try {
      return error.response?.data as String? ??
          'Hệ thống đang bận. Vui lòng quay lại sau';
    } catch (e) {
      talker.warning('Error parsing message: $e');
      return 'Hệ thống đang bận. Vui lòng quay lại sau';
    }
  }

  // Static method to determine the severity of the error based on the response
  static ExceptServerity _determineSeverity(DioException error) {
    if (error.response?.statusCode == 304) {
      return ExceptServerity.normal;
    }
    return ExceptServerity.warning;
  }
}
