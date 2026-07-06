import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/src/config/error_builders.dart';
import 'package:smart_executer/src/config/smart_executer_config.dart';
import 'package:smart_executer/src/domain/models/smart_exception.dart';
import 'package:smart_executer/src/presentation/views/execution_view.dart';
import 'package:smart_executer/src/presentation/widgets/error_dialog.dart';
import 'package:smart_executer/src/presentation/widgets/error_snack_bar.dart';
import 'package:smart_executer/src/presentation/widgets/loading_dialog.dart';

/// Flutter implementation of the MVC view boundary.
final class FlutterExecutionView implements ExecutionView, BuildContextProvider {
  FlutterExecutionView({
    required this.context,
    required this.viewType,
    required this.config,
    this.snackBarErrorBuilder,
    this.dialogErrorBuilder,
    this.scaffoldKey,
  });

  @override
  final BuildContext context;
  final ErrorViewType viewType;
  final SmartExecuterConfig config;
  final SnackBarErrorBuilder? snackBarErrorBuilder;
  final DialogErrorBuilder? dialogErrorBuilder;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  bool _loadingVisible = false;

  @override
  bool get mounted => context.mounted;

  @override
  void showLoading(ExecuterOptions options) {
    if (!mounted || _loadingVisible) return;
    _loadingVisible = true;

    final dialog = showDialog<void>(
      context: context,
      barrierDismissible: options.barrierDismissible,
      barrierColor: options.barrierColor,
      builder: (dialogContext) {
        return options.loadingWidget ??
            config.loadingDialogBuilder?.call(dialogContext) ??
            const SmartLoadingDialog();
      },
    );
    unawaited(dialog.whenComplete(() => _loadingVisible = false));
  }

  @override
  void showStreamLoading<T>({
    required ExecuterOptions options,
    required ValueListenable<T?> valueListenable,
    Widget Function(BuildContext context, T value)? waitingBuilder,
  }) {
    if (!mounted || _loadingVisible) return;
    _loadingVisible = true;

    final dialog = showDialog<T>(
      context: context,
      barrierDismissible: options.barrierDismissible,
      barrierColor: options.barrierColor,
      builder: (dialogContext) => ValueListenableBuilder<T?>(
        valueListenable: valueListenable,
        builder: (builderContext, value, child) {
          if (waitingBuilder != null && value != null) {
            return waitingBuilder(builderContext, value);
          }
          return options.loadingWidget ??
              config.loadingDialogBuilder?.call(builderContext) ??
              const SmartLoadingDialog();
        },
      ),
    );
    unawaited(dialog.whenComplete(() => _loadingVisible = false));
  }

  @override
  void hideLoading([Object? result]) {
    if (!mounted || !_loadingVisible) return;
    _loadingVisible = false;
    Navigator.of(context).pop(result);
  }

  @override
  void showError(SmartException exception) {
    if (!mounted) return;

    switch (viewType) {
      case ErrorViewType.snackBar:
        final builder = snackBarErrorBuilder ?? config.snackBarErrorBuilder;
        final snackBar = builder?.build(context, exception) ??
            SmartErrorSnackBar(exception: exception);
        final keyContext = scaffoldKey?.currentContext;
        final messenger = keyContext != null
            ? ScaffoldMessenger.of(keyContext)
            : ScaffoldMessenger.of(context);
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

      case ErrorViewType.dialog:
        final builder = dialogErrorBuilder ?? config.dialogErrorBuilder;
        final content = builder?.build(context, exception) ??
            SmartErrorDialog(exception: exception);
        unawaited(
          showDialog<void>(
            context: context,
            builder: (_) => content,
          ),
        );
    }
  }

  @override
  Future<void> showSessionExpired() async {
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final customBuilder = config.sessionExpiredDialogBuilder;
        if (customBuilder != null) {
          return customBuilder(
            dialogContext,
            () => Navigator.of(dialogContext).pop(),
          );
        }

        return AlertDialog(
          title: Text(config.sessionExpiredTitle(dialogContext)),
          content: Text(config.sessionExpiredMessage(dialogContext)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
