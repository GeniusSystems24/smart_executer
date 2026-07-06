import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/src/config/smart_executer_config.dart';
import 'package:smart_executer/src/domain/models/smart_exception.dart';

/// View contract used by the execution controller.
///
/// The controller depends on this abstraction rather than Flutter dialog and
/// snackbar functions directly, which keeps orchestration testable.
abstract interface class ExecutionView {
  bool get mounted;

  void showLoading(ExecuterOptions options);

  void showStreamLoading<T>({
    required ExecuterOptions options,
    required ValueListenable<T?> valueListenable,
    Widget Function(BuildContext context, T value)? waitingBuilder,
  });

  void hideLoading([Object? result]);

  void showError(SmartException exception);

  Future<void> showSessionExpired();
}

/// Optional capability for views that expose a Flutter build context.
abstract interface class BuildContextProvider {
  BuildContext get context;
}
