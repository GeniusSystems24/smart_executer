import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_executer/src/application/contracts/connectivity_service.dart';
import 'package:smart_executer/src/application/contracts/execution_logger.dart';
import 'package:smart_executer/src/application/models/execution_callbacks.dart';
import 'package:smart_executer/src/application/services/operation_executor.dart';
import 'package:smart_executer/src/config/smart_executer_config.dart';
import 'package:smart_executer/src/domain/models/smart_exception.dart';
import 'package:smart_executer/src/infrastructure/errors/default_exception_factory.dart';
import 'package:smart_executer/src/presentation/controllers/smart_executer_controller.dart';
import 'package:smart_executer/src/presentation/views/execution_view.dart';

void main() {
  late _FakeConnectivity connectivity;
  late SmartExecuterController controller;
  late _FakeView view;

  setUp(() {
    SmartExecuterConfig.reset();
    connectivity = _FakeConnectivity();
    view = _FakeView();
    controller = SmartExecuterController(
      operationExecutor: DefaultOperationExecutor(
        connectivityService: connectivity,
        exceptionFactory: const DefaultExceptionFactory(),
        logger: _RecordingLogger(),
      ),
      configProvider: () => SmartExecuterConfig.instance,
    );
  });

  test('coordinates loading, success callback, and result', () async {
    var callbackValue = 0;

    final value = await controller.run<int>(
      request: () async => 9,
      view: view,
      options: ExecuterOptions.withDialog,
      callbacks: ExecutionCallbacks<int>(
        onSuccess: (result) async {
          callbackValue = result;
        },
      ),
    );

    expect(value, 9);
    expect(callbackValue, 9);
    expect(view.loadingShown, isTrue);
    expect(view.loadingHidden, isTrue);
    expect(view.errors, isEmpty);
  });

  test('uses the preflight callback without invoking generic error handler',
      () async {
    connectivity.connected = false;
    var connectionCallbacks = 0;
    var genericCallbacks = 0;

    await controller.run<int>(
      request: () async => 9,
      view: view,
      options: const ExecuterOptions(checkConnection: true),
      callbacks: ExecutionCallbacks<int>(
        onConnectionError: () async {
          connectionCallbacks++;
        },
        onError: (_) async {
          genericCallbacks++;
        },
      ),
    );

    expect(connectionCallbacks, 1);
    expect(genericCallbacks, 0);
    expect(view.errors.single, isA<ConnectionException>());
    expect(view.loadingShown, isFalse);
  });

  test('routes session expiration to its dedicated view', () async {
    var callbacks = 0;

    await controller.run<int>(
      request: () async => throw const SessionExpiredException(),
      view: view,
      options: ExecuterOptions.background,
      callbacks: ExecutionCallbacks<int>(
        onSessionExpired: () async {
          callbacks++;
        },
      ),
    );

    expect(callbacks, 1);
    expect(view.sessionExpiredShown, isTrue);
    expect(view.errors, isEmpty);
  });
}

final class _FakeView implements ExecutionView {
  bool loadingShown = false;
  bool loadingHidden = false;
  bool sessionExpiredShown = false;
  final List<SmartException> errors = <SmartException>[];

  @override
  bool get mounted => true;

  @override
  void hideLoading([Object? result]) => loadingHidden = true;

  @override
  void showError(SmartException exception) => errors.add(exception);

  @override
  void showLoading(ExecuterOptions options) => loadingShown = true;

  @override
  Future<void> showSessionExpired() async {
    sessionExpiredShown = true;
  }

  @override
  void showStreamLoading<T>({
    required ExecuterOptions options,
    required ValueListenable<T?> valueListenable,
    Widget Function(BuildContext context, T value)? waitingBuilder,
  }) {
    loadingShown = true;
  }
}

final class _FakeConnectivity implements ConnectivityService {
  bool connected = true;

  @override
  Future<bool> hasConnection() async => connected;
}

final class _RecordingLogger implements ExecutionLogger {
  @override
  void logError(
    String category,
    Object error,
    StackTrace stackTrace,
    ExceptionMetadata metadata,
  ) {}
}
