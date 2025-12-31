/// Exception types for SmartExecuter operations.
///
/// This library provides a comprehensive set of exceptions for handling
/// various error scenarios in async operations.
library;

import 'package:dio/dio.dart';

/// Metadata that can be attached to exceptions for debugging and logging.
///
/// Example:
/// ```dart
/// final metadata = ExceptionMetadata(
///   operationName: 'fetchUser',
///   endpoint: '/api/users/123',
///   userId: 'user_456',
///   extra: {'attempt': 3},
/// );
/// ```
final class ExceptionMetadata {
  /// Creates new [ExceptionMetadata].
  const ExceptionMetadata({
    this.operationName,
    this.endpoint,
    this.requestMethod,
    this.userId,
    this.sessionId,
    this.timestamp,
    this.extra,
  });

  /// Creates an empty metadata instance.
  static const empty = ExceptionMetadata();

  /// Name of the operation that failed (e.g., 'fetchUser', 'createOrder').
  final String? operationName;

  /// API endpoint that was called (e.g., '/api/users/123').
  final String? endpoint;

  /// HTTP method used (e.g., 'GET', 'POST').
  final String? requestMethod;

  /// ID of the user performing the operation.
  final String? userId;

  /// Current session ID.
  final String? sessionId;

  /// Timestamp when the operation started.
  final DateTime? timestamp;

  /// Additional custom data.
  final Map<String, dynamic>? extra;

  /// Returns true if this metadata has any data.
  bool get hasData =>
      operationName != null ||
      endpoint != null ||
      requestMethod != null ||
      userId != null ||
      sessionId != null ||
      timestamp != null ||
      (extra != null && extra!.isNotEmpty);

  /// Converts this metadata to a Map for logging or serialization.
  Map<String, dynamic> toMap() {
    return {
      if (operationName != null) 'operationName': operationName,
      if (endpoint != null) 'endpoint': endpoint,
      if (requestMethod != null) 'requestMethod': requestMethod,
      if (userId != null) 'userId': userId,
      if (sessionId != null) 'sessionId': sessionId,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
      if (extra != null && extra!.isNotEmpty) ...extra!,
    };
  }

  /// Creates a copy with some fields replaced.
  ExceptionMetadata copyWith({
    String? operationName,
    String? endpoint,
    String? requestMethod,
    String? userId,
    String? sessionId,
    DateTime? timestamp,
    Map<String, dynamic>? extra,
  }) {
    return ExceptionMetadata(
      operationName: operationName ?? this.operationName,
      endpoint: endpoint ?? this.endpoint,
      requestMethod: requestMethod ?? this.requestMethod,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      timestamp: timestamp ?? this.timestamp,
      extra: extra ?? this.extra,
    );
  }

  @override
  String toString() {
    if (!hasData) return 'ExceptionMetadata(empty)';
    final parts = <String>[];
    if (operationName != null) parts.add('operation: $operationName');
    if (endpoint != null) parts.add('endpoint: $endpoint');
    if (requestMethod != null) parts.add('method: $requestMethod');
    if (userId != null) parts.add('userId: $userId');
    return 'ExceptionMetadata(${parts.join(', ')})';
  }
}

/// Base exception for all SmartExecuter errors.
sealed class SmartException implements Exception {
  /// Creates a new [SmartException] with the given [message] and optional [cause].
  const SmartException(
    this.message, [
    this.cause,
    this.stackTrace,
    this.metadata = const ExceptionMetadata(),
  ]);

  /// Human-readable error message.
  final String message;

  /// The underlying cause of this exception.
  final Object? cause;

  /// Stack trace when the exception occurred.
  final StackTrace? stackTrace;

  /// Metadata attached to this exception for debugging.
  final ExceptionMetadata metadata;

  /// Returns a copy of this exception with the given metadata attached.
  SmartException withMetadata(ExceptionMetadata metadata);

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
    super.metadata = const ExceptionMetadata(),
  ]);

  @override
  ConnectionException withMetadata(ExceptionMetadata metadata) {
    return ConnectionException(message, cause, stackTrace, metadata);
  }

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
    super.metadata = const ExceptionMetadata(),
  ]);

  @override
  ConnectionTimeoutException withMetadata(ExceptionMetadata metadata) {
    return ConnectionTimeoutException(message, cause, stackTrace, metadata);
  }

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
    super.metadata = const ExceptionMetadata(),
  ]);

  @override
  SendTimeoutException withMetadata(ExceptionMetadata metadata) {
    return SendTimeoutException(message, cause, stackTrace, metadata);
  }

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
    super.metadata = const ExceptionMetadata(),
  ]);

  @override
  ReceiveTimeoutException withMetadata(ExceptionMetadata metadata) {
    return ReceiveTimeoutException(message, cause, stackTrace, metadata);
  }

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
    super.metadata = const ExceptionMetadata(),
  ]);

  @override
  CancelledException withMetadata(ExceptionMetadata metadata) {
    return CancelledException(message, cause, stackTrace, metadata);
  }

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
    ExceptionMetadata metadata = const ExceptionMetadata(),
  }) : super(message, cause, stackTrace, metadata);

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
  ResponseException withMetadata(ExceptionMetadata metadata) {
    return ResponseException(
      message: message,
      statusCode: statusCode,
      responseData: responseData,
      cause: cause,
      stackTrace: stackTrace,
      metadata: metadata,
    );
  }

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
    super.metadata = const ExceptionMetadata(),
  ]);

  @override
  SessionExpiredException withMetadata(ExceptionMetadata metadata) {
    return SessionExpiredException(message, cause, stackTrace, metadata);
  }

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
    super.metadata = const ExceptionMetadata(),
  ]);

  @override
  UnknownException withMetadata(ExceptionMetadata metadata) {
    return UnknownException(message, cause, stackTrace, metadata);
  }

  @override
  String toString() => 'UnknownException: $message';
}

/// Utility class for converting exceptions.
abstract final class ExceptionMapper {
  /// Converts a [DioException] to the appropriate [SmartException].
  ///
  /// Optionally attach [metadata] to the resulting exception.
  static SmartException fromDioException(
    DioException e, [
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
  ///
  /// Optionally attach [metadata] to the resulting exception.
  static SmartException fromException(
    Object e, [
    StackTrace? stackTrace,
    ExceptionMetadata metadata = const ExceptionMetadata(),
  ]) {
    if (e is SmartException) {
      // If already a SmartException, attach metadata if provided
      if (metadata.hasData) {
        return e.withMetadata(metadata);
      }
      return e;
    }
    if (e is DioException) return fromDioException(e, metadata);

    final enrichedMetadata = metadata.copyWith(
      timestamp: metadata.timestamp ?? DateTime.now(),
    );
    return UnknownException(e.toString(), e, stackTrace, enrichedMetadata);
  }
}
