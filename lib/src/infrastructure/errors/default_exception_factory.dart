import 'dart:async';

import 'package:dio/dio.dart';
import 'package:smart_executer/src/application/contracts/exception_factory.dart';
import 'package:smart_executer/src/domain/models/smart_exception.dart';
import 'package:smart_executer/src/infrastructure/errors/dio_exception_mapper.dart';

/// Signature used for optional application-specific exception mapping.
typedef CustomExceptionBuilder = SmartException? Function(
  Object error,
  StackTrace? stackTrace,
  ExceptionMetadata metadata,
);

/// Default exception factory used by the package composition root.
final class DefaultExceptionFactory implements ExceptionFactory {
  const DefaultExceptionFactory({this.customBuilderProvider});

  /// Provides the latest configured builder on every invocation so resetting
  /// global configuration does not leave stale dependencies behind.
  final CustomExceptionBuilder? Function()? customBuilderProvider;

  @override
  SmartException create(
    Object error,
    StackTrace? stackTrace,
    ExceptionMetadata metadata,
  ) {
    final custom = customBuilderProvider?.call()?.call(
          error,
          stackTrace,
          metadata,
        );
    if (custom != null) return custom;

    if (error is SmartException) {
      return metadata.hasData ? error.withMetadata(metadata) : error;
    }
    if (error is TimeoutException) {
      return ConnectionTimeoutException(
        error.message ?? 'Operation timed out',
        error,
        stackTrace,
        metadata,
      );
    }
    if (error is DioException) {
      return DioExceptionMapper.map(error, metadata);
    }

    final enrichedMetadata = metadata.copyWith(
      timestamp: metadata.timestamp ?? DateTime.now(),
    );
    return UnknownException(
      error.toString(),
      error,
      stackTrace,
      enrichedMetadata,
    );
  }
}
