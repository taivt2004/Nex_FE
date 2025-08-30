import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nexpaylab/app/core/network/exception.handler.dart';

part 'result.freezed.dart';

@freezed
abstract class Result<T> with _$Result<T> {
  const Result._();

  const factory Result.success(T data) = Success<T>;

  const factory Result.failure({@required dynamic error}) = Failure<T>;

  static Result<T> guard<T>(T Function() body) {
    try {
      return Result.success(body());
    } on Exception catch (e) {
      dynamic error = e;
      if (e is DioException) {
        final ext = ExceptionHandler.dioException(e);
        if (ext.serverity.index >= ExceptServerity.warning.index) {
          error = ext.errorMessage;
        } else {
          error = ext;
        }
      }
      return Result.failure(error: error);
    }
  }

  static Future<Result<T>> guardFuture<T>(Future<T> Function() future) async {
    try {
      return Result.success(await future());
    } on Exception catch (e) {
      dynamic error = e;
      if (e is DioException) {
        final ext = ExceptionHandler.dioException(e);
        if (ext.serverity.index >= ExceptServerity.warning.index) {
          error = ext.errorMessage;
        } else {
          error = ext;
        }
      }
      return Result.failure(error: error);
    }
  }

  bool get isSuccess => when(success: (data) => true, failure: (e) => false);

  bool get isFailure => !isSuccess;

  void ifSuccess(T Function(T data) body) {
    maybeWhen(
      success: (data) => body(data),
      orElse: () {
        // no-op
      },
    );
  }

  void ifFailure(dynamic Function(dynamic e) body) {
    maybeWhen(
      failure: (e) => body(e),
      orElse: () {
        // no-op
      },
    );
  }
}

extension ResultObjectExt<T> on T {
  Result<T> get asSuccess => Result.success(this);

  Result<T> asFailure(Exception e) => Result.failure(error: e);
}
