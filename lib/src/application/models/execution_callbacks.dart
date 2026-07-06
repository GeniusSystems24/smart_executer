import 'package:smart_executer/src/domain/models/smart_exception.dart';

/// Groups optional callbacks for one execution request.
///
/// Keeping callbacks in a model prevents controller methods from passing a
/// long list of unrelated parameters through every private helper.
final class ExecutionCallbacks<T> {
  const ExecutionCallbacks({
    this.onCancel,
    this.onConnectionError,
    this.onConnectionTimeout,
    this.onReceiveTimeout,
    this.onSendTimeout,
    this.onResponseError,
    this.onError,
    this.onSuccess,
    this.onSessionExpired,
  });

  final Future<void> Function()? onCancel;
  final Future<void> Function()? onConnectionError;
  final Future<void> Function()? onConnectionTimeout;
  final Future<void> Function()? onReceiveTimeout;
  final Future<void> Function()? onSendTimeout;
  final Future<void> Function()? onResponseError;
  final Future<void> Function(SmartException exception)? onError;
  final Future<void> Function(T result)? onSuccess;
  final Future<void> Function()? onSessionExpired;
}
