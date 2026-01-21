import 'package:dio/dio.dart';
import 'package:nexpaylab/shared/logger.dart';

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

  // Static method to map DioErrorType to user-friendly error messages (returns KEYS)
  static String _getDioErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return 'errRequestCancelled';
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'errConnectionTimeout';
      case DioExceptionType.sendTimeout:
        return 'errConnectionInterrupted';
      case DioExceptionType.connectionError:
        return 'errNetworkUnstable';
      case DioExceptionType.badCertificate:
        return 'errCertificate';
      case DioExceptionType.unknown:
        return 'errProcessFailed';
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
        return 'errNoNewData'; // Not Modified
      case 503:
        return 'errSystemBusy';
      case 401:
        return 'errSessionExpired';
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
      // If server returns a specific message, we return it directly.
      // NOTE: This might be localized by server or raw string.
      // If we want strict localization, we should map server codes to keys.
      // For now, assuming server returns readable string or we fallback to key.
      return (res?['error'] as String?) ?? 'errSystemBusy';
    } catch (e) {
      talker.warning('Error parsing bad response: $e');
      return 'errSystemBusy';
    }
  }

  // Helper method to parse generic error message for any error type
  static String _parseErrorMessage(DioException error) {
    try {
      return error.response?.data as String? ?? 'errSystemBusy';
    } catch (e) {
      talker.warning('Error parsing message: $e');
      return 'errSystemBusy';
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
