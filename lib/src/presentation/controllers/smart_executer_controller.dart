import 'package:flutter/widgets.dart';
import 'package:smart_executer/src/application/models/execution_callbacks.dart';
import 'package:smart_executer/src/application/models/execution_outcome.dart';
import 'package:smart_executer/src/application/services/operation_executor.dart';
import 'package:smart_executer/src/config/smart_executer_config.dart';
import 'package:smart_executer/src/domain/models/result.dart';
import 'package:smart_executer/src/domain/models/smart_exception.dart';
import 'package:smart_executer/src/presentation/views/execution_view.dart';

/// MVC controller coordinating application use cases and Flutter views.
final class SmartExecuterController {
  const SmartExecuterController({
    required OperationExecutor operationExecutor,
    required SmartExecuterConfig Function() configProvider,
  })  : _operationExecutor = operationExecutor,
        _configProvider = configProvider;

  final OperationExecutor _operationExecutor;
  final SmartExecuterConfig Function() _configProvider;

  Future<Result<T>> execute<T>({
    required Future<T> Function() request,
    required bool checkConnection,
    String? operationName,
    Map<String, dynamic>? metadata,
    ExecutionView? view,
  }) async {
    final config = _configProvider();
    final outcome = await _operationExecutor.execute<T>(
      operation: request,
      metadata: _metadata(operationName, metadata),
      checkConnection: checkConnection || config.checkConnectionByDefault,
      connectionErrorMessage: 'No internet connection',
    );

    final result = outcome.result;
    if (result is Failure<T>) {
      await config.globalErrorHandler?.call(result.exception);
      view?.showError(result.exception);
    }
    return result;
  }

  Future<T?> run<T extends Object>({
    required Future<T?> Function() request,
    required ExecutionView view,
    required ExecuterOptions options,
    required ExecutionCallbacks<T> callbacks,
  }) async {
    final config = _configProvider();
    final outcome = await _operationExecutor.execute<T?>(
      operation: request,
      metadata: _metadata(options.operationName, options.metadata),
      checkConnection:
          options.checkConnection ?? config.checkConnectionByDefault,
      connectionErrorMessage: _connectionMessage(view, config),
      timeout: config.resolveTimeout(options.timeout),
      onReady: options.showLoadingDialog
          ? () => view.showLoading(options)
          : null,
    );

    final result = outcome.result;
    if (result is Success<T?>) {
      final response = result.data;
      if (options.showLoadingDialog) {
        view.hideLoading(response);
      }
      if (response != null) {
        await callbacks.onSuccess?.call(response);
      }
      return response;
    }

    if (options.showLoadingDialog) {
      view.hideLoading();
    }
    final exception = (result as Failure<T?>).exception;
    await _handleFailure(
      exception: exception,
      failureStage: outcome.failureStage!,
      callbacks: callbacks,
      view: view,
      config: config,
    );
    return null;
  }

  Future<T?> runStream<T extends Object>({
    required Stream<T?> Function() requestStream,
    required ExecutionView view,
    required ExecuterOptions options,
    required ExecutionCallbacks<T> callbacks,
    Widget Function(BuildContext context, T value)? waitingBuilder,
    void Function(T? value)? listener,
  }) async {
    final config = _configProvider();
    final streamValue = ValueNotifier<T?>(null);

    try {
      final outcome = await _operationExecutor.executeStream<T>(
        streamFactory: requestStream,
        metadata: _metadata(options.operationName, options.metadata),
        checkConnection:
            options.checkConnection ?? config.checkConnectionByDefault,
        connectionErrorMessage: _connectionMessage(view, config),
        timeout: config.resolveTimeout(options.timeout),
        onReady: options.showLoadingDialog
            ? () => view.showStreamLoading<T>(
                  options: options,
                  valueListenable: streamValue,
                  waitingBuilder: waitingBuilder,
                )
            : null,
        onData: (value) {
          listener?.call(value);
          streamValue.value = value;
        },
      );

      final result = outcome.result;
      if (result is Success<T?>) {
        final response = result.data;
        if (options.showLoadingDialog) {
          view.hideLoading(response);
        }
        if (response != null) {
          await callbacks.onSuccess?.call(response);
        }
        return response;
      }

      if (options.showLoadingDialog) {
        view.hideLoading();
      }
      final exception = (result as Failure<T?>).exception;
      await _handleFailure(
        exception: exception,
        failureStage: outcome.failureStage!,
        callbacks: callbacks,
        view: view,
        config: config,
      );
      return null;
    } finally {
      streamValue.dispose();
    }
  }

  Future<void> _handleFailure<T>({
    required SmartException exception,
    required ExecutionFailureStage failureStage,
    required ExecutionCallbacks<T> callbacks,
    required ExecutionView view,
    required SmartExecuterConfig config,
  }) async {
    if (failureStage == ExecutionFailureStage.preflight) {
      await callbacks.onConnectionError?.call();
      view.showError(exception);
      return;
    }

    if (exception.kind == SmartFailureKind.sessionExpired) {
      await callbacks.onSessionExpired?.call();
      await config.onSessionExpired?.call();
      await view.showSessionExpired();
      return;
    }

    switch (exception.kind) {
      case SmartFailureKind.cancelled:
        await callbacks.onCancel?.call();
      case SmartFailureKind.connectionTimeout:
        await callbacks.onConnectionTimeout?.call();
      case SmartFailureKind.receiveTimeout:
        await callbacks.onReceiveTimeout?.call();
      case SmartFailureKind.sendTimeout:
        await callbacks.onSendTimeout?.call();
      case SmartFailureKind.response:
        await callbacks.onResponseError?.call();
      case SmartFailureKind.connection:
      case SmartFailureKind.sessionExpired:
      case SmartFailureKind.unknown:
        break;
    }

    await callbacks.onError?.call(exception);
    await config.globalErrorHandler?.call(exception);
    view.showError(exception);
  }

  ExceptionMetadata _metadata(
    String? operationName,
    Map<String, dynamic>? metadata,
  ) {
    return ExceptionMetadata(
      operationName: operationName,
      timestamp: DateTime.now(),
      extra: metadata,
    );
  }

  String _connectionMessage(
    ExecutionView view,
    SmartExecuterConfig config,
  ) {
    if (!view.mounted) {
      return 'No internet connection';
    }

    final Object contextCandidate = view;
    if (contextCandidate is! BuildContextProvider) {
      return 'No internet connection';
    }

    return config.noConnectionMessage(contextCandidate.context);
  }
}

