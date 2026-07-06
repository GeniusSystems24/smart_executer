/// Backward-compatible exception API for Smart Executer.
///
/// Domain exception models are framework independent. Flutter presentation
/// metadata and Dio mapping remain available here to preserve the package's
/// existing public API.
library;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/src/domain/models/smart_exception.dart';
import 'package:smart_executer/src/infrastructure/errors/dio_exception_mapper.dart';

export 'package:smart_executer/src/domain/models/smart_exception.dart';

/// Identifies the public type of a [SmartException].
///
/// The enhanced enum is intentionally retained in the compatibility layer so
/// existing constant expressions and property access remain unchanged.
enum SmartExceptionType {
  connection(color: Color(0xFFFF9800), icon: Icons.wifi_off_rounded),

  /// Corresponds to [ConnectionTimeoutException].
  connectionTimeout(
      color: Color(0xFFFF5722), icon: Icons.timer_off_rounded),

  /// Corresponds to [SendTimeoutException].
  sendTimeout(color: Color(0xFFFF5722), icon: Icons.upload_rounded),
  receiveTimeout(color: Color(0xFFFF5722), icon: Icons.download_rounded),
  cancelled(color: Color(0xFF78909C), icon: Icons.cancel_rounded),
  response(color: Color(0xFFF44336), icon: Icons.cloud_off_rounded),

  /// Corresponds to [SessionExpiredException].
  sessionExpired(
      color: Color(0xFF1976D2), icon: Icons.lock_outline_rounded),

  /// Corresponds to [UnknownException].
  unknown(color: Color(0xFFF44336), icon: Icons.error_outline_rounded);

  const SmartExceptionType({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}

/// Preserves `exception.exceptionType` while the domain uses a pure category.
extension SmartExceptionTypeAccess on SmartException {
  SmartExceptionType get exceptionType => switch (kind) {
        SmartFailureKind.connection => SmartExceptionType.connection,
        SmartFailureKind.connectionTimeout =>
          SmartExceptionType.connectionTimeout,
        SmartFailureKind.sendTimeout => SmartExceptionType.sendTimeout,
        SmartFailureKind.receiveTimeout => SmartExceptionType.receiveTimeout,
        SmartFailureKind.cancelled => SmartExceptionType.cancelled,
        SmartFailureKind.response => SmartExceptionType.response,
        SmartFailureKind.sessionExpired => SmartExceptionType.sessionExpired,
        SmartFailureKind.unknown => SmartExceptionType.unknown,
      };
}

/// Utility class for converting exceptions.
///
/// This compatibility facade delegates Dio-specific work to the
/// infrastructure mapper while preserving the original public API.
abstract final class ExceptionMapper {
  /// Converts a [DioException] to the appropriate [SmartException].
  static SmartException fromDioException(
    DioException exception, [
    ExceptionMetadata metadata = const ExceptionMetadata(),
  ]) {
    // Auto-extract endpoint and method from Dio request if not provided
    final enrichedMetadata = metadata.copyWith(
      endpoint: metadata.endpoint ?? e.requestOptions.path,
      requestMethod: metadata.requestMethod ?? e.requestOptions.method,
      timestamp: metadata.timestamp ?? DateTime.now(),
    );

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ConnectionTimeoutException(
          e.message ?? 'Connection timeout',
          e,
          e.stackTrace,
          enrichedMetadata,
        );
      case DioExceptionType.sendTimeout:
        return SendTimeoutException(
          e.message ?? 'Send timeout',
          e,
          e.stackTrace,
          enrichedMetadata,
        );
      case DioExceptionType.receiveTimeout:
        return ReceiveTimeoutException(
          e.message ?? 'Receive timeout',
          e,
          e.stackTrace,
          enrichedMetadata,
        );
      case DioExceptionType.cancel:
        return CancelledException(
          e.message ?? 'Request cancelled',
          e,
          e.stackTrace,
          enrichedMetadata,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return SessionExpiredException(
            'Session expired',
            e,
            e.stackTrace,
            enrichedMetadata,
          );
        }
        return ResponseException(
          message: e.response?.data?.toString() ?? e.message ?? 'Server error',
          statusCode: statusCode,
          responseData: e.response?.data,
          cause: e,
          stackTrace: e.stackTrace,
          metadata: enrichedMetadata,
        );
      case DioExceptionType.connectionError:
        return ConnectionException(
          e.message ?? 'Connection error',
          e,
          e.stackTrace,
          enrichedMetadata,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnknownException(
          e.message ?? 'Unknown error',
          e,
          e.stackTrace,
          enrichedMetadata,
        );
    }
  }

  /// Converts any exception to a [SmartException].
  static SmartException fromException(
    Object exception, [
    StackTrace? stackTrace,
    ExceptionMetadata metadata = const ExceptionMetadata(),
  ]) {
    if (exception is SmartException) {
      return metadata.hasData ? exception.withMetadata(metadata) : exception;
    }
    if (exception is DioException) {
      return DioExceptionMapper.map(exception, metadata);
    }

    final enrichedMetadata = metadata.copyWith(
      timestamp: metadata.timestamp ?? DateTime.now(),
    );
    return UnknownException(
      exception.toString(),
      exception,
      stackTrace,
      enrichedMetadata,
    );
  }
}
