import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_executer/src/application/contracts/connectivity_service.dart';
import 'package:smart_executer/src/application/contracts/execution_logger.dart';
import 'package:smart_executer/src/application/models/execution_outcome.dart';
import 'package:smart_executer/src/application/services/operation_executor.dart';
import 'package:smart_executer/src/domain/models/result.dart';
import 'package:smart_executer/src/domain/models/smart_exception.dart';
import 'package:smart_executer/src/infrastructure/errors/default_exception_factory.dart';

void main() {
  late _FakeConnectivity connectivity;
  late _RecordingLogger logger;
  late DefaultOperationExecutor executor;

  setUp(() {
    connectivity = _FakeConnectivity();
    logger = _RecordingLogger();
    executor = DefaultOperationExecutor(
      connectivityService: connectivity,
      exceptionFactory: const DefaultExceptionFactory(),
      logger: logger,
    );
  });

  test('returns success without touching presentation concerns', () async {
    final outcome = await executor.execute<int>(
      operation: () async => 42,
      metadata: const ExceptionMetadata(operationName: 'answer'),
      checkConnection: false,
      connectionErrorMessage: 'offline',
    );

    expect(outcome.result, const Success<int>(42));
    expect(outcome.failureStage, isNull);
    expect(logger.errors, isEmpty);
  });

  test('reports a connectivity preflight failure', () async {
    connectivity.connected = false;

    final outcome = await executor.execute<int>(
      operation: () async => 42,
      metadata: const ExceptionMetadata(),
      checkConnection: true,
      connectionErrorMessage: 'offline',
    );

    expect(outcome.result, isA<Failure<int>>());
    expect(
      (outcome.result as Failure<int>).exception,
      isA<ConnectionException>(),
    );
    expect(outcome.failureStage, ExecutionFailureStage.preflight);
  });

  test('maps operation timeouts through the exception boundary', () async {
    final outcome = await executor.execute<int>(
      operation: () async {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return 1;
      },
      metadata: const ExceptionMetadata(),
      checkConnection: false,
      connectionErrorMessage: 'offline',
      timeout: const Duration(milliseconds: 1),
    );

    final failure = outcome.result as Failure<int>;
    expect(failure.exception, isA<ConnectionTimeoutException>());
    expect(outcome.failureStage, ExecutionFailureStage.operation);
    expect(logger.errors, hasLength(1));
  });

  test('stream execution returns the first non-null value', () async {
    final values = <int?>[];
    final outcome = await executor.executeStream<int>(
      streamFactory: () => Stream<int?>.fromIterable([null, 3, 4]),
      metadata: const ExceptionMetadata(),
      checkConnection: false,
      connectionErrorMessage: 'offline',
      onData: values.add,
    );

    expect(outcome.result, const Success<int?>(3));
    expect(values.take(2), [null, 3]);
  });
}

final class _FakeConnectivity implements ConnectivityService {
  bool connected = true;

  @override
  Future<bool> hasConnection() async => connected;
}

final class _RecordingLogger implements ExecutionLogger {
  final List<Object> errors = <Object>[];

  @override
  void logError(
    String category,
    Object error,
    StackTrace stackTrace,
    ExceptionMetadata metadata,
  ) {
    errors.add(error);
  }
}
