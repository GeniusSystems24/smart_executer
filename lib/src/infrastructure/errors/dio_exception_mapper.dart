import 'package:dio/dio.dart';
import 'package:smart_executer/src/domain/models/smart_exception.dart';

/// Maps Dio errors into framework-independent Smart Executer exceptions.
abstract final class DioExceptionMapper {
  static SmartException map(
    DioException exception, [
    ExceptionMetadata metadata = const ExceptionMetadata(),
  ]) {
    final enrichedMetadata = metadata.copyWith(
      endpoint: metadata.endpoint ?? exception.requestOptions.path,
      requestMethod: metadata.requestMethod ?? exception.requestOptions.method,
      timestamp: metadata.timestamp ?? DateTime.now(),
    );

    return switch (exception.type) {
      DioExceptionType.connectionTimeout => ConnectionTimeoutException(
          exception.message ?? 'Connection timeout',
          exception,
          exception.stackTrace,
          enrichedMetadata,
        ),
      DioExceptionType.sendTimeout => SendTimeoutException(
          exception.message ?? 'Send timeout',
          exception,
          exception.stackTrace,
          enrichedMetadata,
        ),
      DioExceptionType.receiveTimeout => ReceiveTimeoutException(
          exception.message ?? 'Receive timeout',
          exception,
          exception.stackTrace,
          enrichedMetadata,
        ),
      DioExceptionType.cancel => CancelledException(
          exception.message ?? 'Request cancelled',
          exception,
          exception.stackTrace,
          enrichedMetadata,
        ),
      DioExceptionType.badResponse => _mapResponse(
          exception,
          enrichedMetadata,
        ),
      DioExceptionType.connectionError => ConnectionException(
          exception.message ?? 'Connection error',
          exception,
          exception.stackTrace,
          enrichedMetadata,
        ),
      _ => UnknownException(
          exception.message ?? 'Unknown error',
          exception,
          exception.stackTrace,
          enrichedMetadata,
        ),
    };
  }

  static SmartException _mapResponse(
    DioException exception,
    ExceptionMetadata metadata,
  ) {
    final statusCode = exception.response?.statusCode;
    if (statusCode == 401) {
      return SessionExpiredException(
        'Session expired',
        exception,
        exception.stackTrace,
        metadata,
      );
    }

    return ResponseException(
      message: exception.response?.data?.toString() ??
          exception.message ??
          'Server error',
      statusCode: statusCode,
      responseData: exception.response?.data,
      cause: exception,
      stackTrace: exception.stackTrace,
      metadata: metadata,
    );
  }
}
