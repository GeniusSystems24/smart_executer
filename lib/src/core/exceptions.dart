/// Exception types for SmartExecuter operations.
///
/// This library provides a comprehensive set of exceptions for handling
/// various error scenarios in async operations.
library;

import 'package:dio/dio.dart';

/// Base exception for all SmartExecuter errors.
sealed class SmartException implements Exception {
  /// Creates a new [SmartException] with the given [message] and optional [cause].
  const SmartException(this.message, [this.cause, this.stackTrace]);

  /// Human-readable error message.
  final String message;

  /// The underlying cause of this exception.
  final Object? cause;

  /// Stack trace when the exception occurred.
  final StackTrace? stackTrace;

  @override
  String toString() => 'SmartException: $message';
}

/// Exception thrown when there is no internet connection.
final class ConnectionException extends SmartException {
  /// Creates a new [ConnectionException].
  const ConnectionException([
    super.message = 'No internet connection',
    super.cause,
    super.stackTrace,
  ]);

  @override
  String toString() => 'ConnectionException: $message';
}

/// Exception thrown when a connection timeout occurs.
final class ConnectionTimeoutException extends SmartException {
  /// Creates a new [ConnectionTimeoutException].
  const ConnectionTimeoutException([
    super.message = 'Connection timeout',
    super.cause,
    super.stackTrace,
  ]);

  @override
  String toString() => 'ConnectionTimeoutException: $message';
}

/// Exception thrown when a send timeout occurs.
final class SendTimeoutException extends SmartException {
  /// Creates a new [SendTimeoutException].
  const SendTimeoutException([
    super.message = 'Send timeout',
    super.cause,
    super.stackTrace,
  ]);

  @override
  String toString() => 'SendTimeoutException: $message';
}

/// Exception thrown when a receive timeout occurs.
final class ReceiveTimeoutException extends SmartException {
  /// Creates a new [ReceiveTimeoutException].
  const ReceiveTimeoutException([
    super.message = 'Receive timeout',
    super.cause,
    super.stackTrace,
  ]);

  @override
  String toString() => 'ReceiveTimeoutException: $message';
}

/// Exception thrown when the request is cancelled.
final class CancelledException extends SmartException {
  /// Creates a new [CancelledException].
  const CancelledException([
    super.message = 'Request was cancelled',
    super.cause,
    super.stackTrace,
  ]);

  @override
  String toString() => 'CancelledException: $message';
}

/// Exception thrown when the server returns an error response.
final class ResponseException extends SmartException {
  /// Creates a new [ResponseException].
  const ResponseException({
    String message = 'Server error',
    this.statusCode,
    this.responseData,
    Object? cause,
    StackTrace? stackTrace,
  }) : super(message, cause, stackTrace);

  /// HTTP status code from the response.
  final int? statusCode;

  /// Response data from the server.
  final dynamic responseData;

  /// Returns true if this is an authentication error (401).
  bool get isUnauthorized => statusCode == 401;

  /// Returns true if this is a forbidden error (403).
  bool get isForbidden => statusCode == 403;

  /// Returns true if this is a not found error (404).
  bool get isNotFound => statusCode == 404;

  /// Returns true if this is a server error (5xx).
  bool get isServerError => statusCode != null && statusCode! >= 500;

  @override
  String toString() => 'ResponseException: $message (status: $statusCode)';
}

/// Exception thrown when the session has expired (401 Unauthorized).
final class SessionExpiredException extends SmartException {
  /// Creates a new [SessionExpiredException].
  const SessionExpiredException([
    super.message = 'Session expired. Please sign in again.',
    super.cause,
    super.stackTrace,
  ]);

  @override
  String toString() => 'SessionExpiredException: $message';
}

/// Exception for unknown or unhandled errors.
final class UnknownException extends SmartException {
  /// Creates a new [UnknownException].
  const UnknownException([
    super.message = 'An unknown error occurred',
    super.cause,
    super.stackTrace,
  ]);

  @override
  String toString() => 'UnknownException: $message';
}

/// Utility class for converting exceptions.
abstract final class ExceptionMapper {
  /// Converts a [DioException] to the appropriate [SmartException].
  static SmartException fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return ConnectionTimeoutException(
          e.message ?? 'Connection timeout',
          e,
          e.stackTrace,
        );
      case DioExceptionType.sendTimeout:
        return SendTimeoutException(
          e.message ?? 'Send timeout',
          e,
          e.stackTrace,
        );
      case DioExceptionType.receiveTimeout:
        return ReceiveTimeoutException(
          e.message ?? 'Receive timeout',
          e,
          e.stackTrace,
        );
      case DioExceptionType.cancel:
        return CancelledException(
          e.message ?? 'Request cancelled',
          e,
          e.stackTrace,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return SessionExpiredException(
            'Session expired',
            e,
            e.stackTrace,
          );
        }
        return ResponseException(
          message: e.response?.data?.toString() ??
              e.message ??
              'Server error',
          statusCode: statusCode,
          responseData: e.response?.data,
          cause: e,
          stackTrace: e.stackTrace,
        );
      case DioExceptionType.connectionError:
        return ConnectionException(
          e.message ?? 'Connection error',
          e,
          e.stackTrace,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return UnknownException(
          e.message ?? 'Unknown error',
          e,
          e.stackTrace,
        );
    }
  }

  /// Converts any exception to a [SmartException].
  static SmartException fromException(Object e, [StackTrace? stackTrace]) {
    if (e is SmartException) return e;
    if (e is DioException) return fromDioException(e);
    return UnknownException(e.toString(), e, stackTrace);
  }
}
