import 'dart:async';

import 'package:smart_executer/src/application/contracts/connectivity_service.dart';
import 'package:smart_executer/src/application/contracts/exception_factory.dart';
import 'package:smart_executer/src/application/contracts/execution_logger.dart';
import 'package:smart_executer/src/application/models/execution_outcome.dart';
import 'package:smart_executer/src/domain/models/result.dart';
import 'package:smart_executer/src/domain/models/smart_exception.dart';

/// Application use case for executing asynchronous work.
abstract interface class OperationExecutor {
  Future<ExecutionOutcome<T>> execute<T>({
    required Future<T> Function() operation,
    required ExceptionMetadata metadata,
    required bool checkConnection,
    required String connectionErrorMessage,
    Duration? timeout,
    void Function()? onReady,
  });

  Future<ExecutionOutcome<T?>> executeStream<T>({
    required Stream<T?> Function() streamFactory,
    required ExceptionMetadata metadata,
    required bool checkConnection,
    required String connectionErrorMessage,
    Duration? timeout,
    void Function()? onReady,
    void Function(T? value)? onData,
  });
}

/// Default implementation of [OperationExecutor].
///
/// It owns operation mechanics only: connectivity, timeout, error conversion,
/// logging, and stream lifecycle. UI and callbacks are controller concerns.
final class DefaultOperationExecutor implements OperationExecutor {
  const DefaultOperationExecutor({
    required ConnectivityService connectivityService,
    required ExceptionFactory exceptionFactory,
    required ExecutionLogger logger,
  })  : _connectivityService = connectivityService,
        _exceptionFactory = exceptionFactory,
        _logger = logger;

  final ConnectivityService _connectivityService;
  final ExceptionFactory _exceptionFactory;
  final ExecutionLogger _logger;

  @override
  Future<ExecutionOutcome<T>> execute<T>({
    required Future<T> Function() operation,
    required ExceptionMetadata metadata,
    required bool checkConnection,
    required String connectionErrorMessage,
    Duration? timeout,
    void Function()? onReady,
  }) async {
    final connectionFailure = await _connectionFailure(
      shouldCheck: checkConnection,
      message: connectionErrorMessage,
      metadata: metadata,
    );
    if (connectionFailure != null) {
      return ExecutionOutcome<T>.failure(
        Failure<T>(connectionFailure),
        failureStage: ExecutionFailureStage.preflight,
      );
    }

    try {
      onReady?.call();
      final future = operation();
      final value = timeout == null ? await future : await future.timeout(timeout);
      return ExecutionOutcome<T>.success(value);
    } catch (error, stackTrace) {
      return ExecutionOutcome<T>.failure(
        Failure<T>(_mapAndLog(error, stackTrace, metadata)),
        failureStage: ExecutionFailureStage.operation,
      );
    }
  }

  @override
  Future<ExecutionOutcome<T?>> executeStream<T>({
    required Stream<T?> Function() streamFactory,
    required ExceptionMetadata metadata,
    required bool checkConnection,
    required String connectionErrorMessage,
    Duration? timeout,
    void Function()? onReady,
    void Function(T? value)? onData,
  }) async {
    final connectionFailure = await _connectionFailure(
      shouldCheck: checkConnection,
      message: connectionErrorMessage,
      metadata: metadata,
    );
    if (connectionFailure != null) {
      return ExecutionOutcome<T?>.failure(
        Failure<T?>(connectionFailure),
        failureStage: ExecutionFailureStage.preflight,
      );
    }

    final completer = Completer<T?>();
    StreamSubscription<T?>? subscription;
    T? latestValue;

    try {
      onReady?.call();
      subscription = streamFactory().listen(
        (value) {
          latestValue = value;
          onData?.call(value);
          if (value != null && !completer.isCompleted) {
            completer.complete(value);
          }
        },
        onError: (Object error, StackTrace stackTrace) {
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.complete(latestValue);
          }
        },
      );

      final future = completer.future;
      final value = timeout == null ? await future : await future.timeout(timeout);
      return ExecutionOutcome<T?>.success(value);
    } catch (error, stackTrace) {
      return ExecutionOutcome<T?>.failure(
        Failure<T?>(_mapAndLog(error, stackTrace, metadata)),
        failureStage: ExecutionFailureStage.operation,
      );
    } finally {
      await subscription?.cancel();
    }
  }

  Future<SmartException?> _connectionFailure({
    required bool shouldCheck,
    required String message,
    required ExceptionMetadata metadata,
  }) async {
    if (!shouldCheck) return null;

    try {
      final connected = await _connectivityService.hasConnection();
      if (connected) return null;
      return ConnectionException(message, null, null, metadata);
    } catch (error, stackTrace) {
      return _mapAndLog(error, stackTrace, metadata);
    }
  }

  SmartException _mapAndLog(
    Object error,
    StackTrace stackTrace,
    ExceptionMetadata metadata,
  ) {
    _logger.logError('Operation error', error, stackTrace, metadata);
    return _exceptionFactory.create(error, stackTrace, metadata);
  }
}
