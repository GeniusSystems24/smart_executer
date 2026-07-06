/// Public Smart Executer facade.
///
/// The static API is intentionally preserved for backward compatibility. The
/// implementation delegates to an MVC controller assembled through the
/// package composition root.
library;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/src/application/models/execution_callbacks.dart';
import 'package:smart_executer/src/config/error_builders.dart';
import 'package:smart_executer/src/config/smart_executer_config.dart';
import 'package:smart_executer/src/domain/models/result.dart';
import 'package:smart_executer/src/domain/models/smart_exception.dart';
import 'package:smart_executer/src/internal/smart_executer_runtime.dart';
import 'package:smart_executer/src/presentation/views/flutter_execution_view.dart';

/// Callback types for SmartExecuter.
typedef VoidAsyncCallback = Future<void> Function();
typedef SuccessCallback<T> = Future<void> Function(T result);
typedef ErrorCallback = Future<void> Function(SmartException exception);

/// Executes asynchronous operations with optional Flutter presentation.
///
/// This class remains a static facade so existing application code does not
/// need to change. Execution rules live in application services, orchestration
/// lives in the controller, and dialogs/snackbars live in the view layer.
abstract final class SmartExecuter {
  /// Executes an async operation and returns a [Result].
  static Future<Result<T>> execute<T>(
    Future<T> Function() request, {
    bool checkConnection = false,
    CancelToken? cancelToken,
    String? operationName,
    Map<String, dynamic>? metadata,
    BuildContext? context,
    ErrorViewType? viewType,
    SnackBarErrorBuilder? snackBarErrorBuilder,
    DialogErrorBuilder? dialogErrorBuilder,
    GlobalKey<ScaffoldState>? scaffoldKey,
  }) {
    final config = SmartExecuterConfig.instance;
    final view = context == null
        ? null
        : _createView(
            context: context,
            viewType: viewType ?? config.defaultViewType,
            snackBarErrorBuilder: snackBarErrorBuilder,
            dialogErrorBuilder: dialogErrorBuilder,
            scaffoldKey: scaffoldKey,
          );

    return SmartExecuterRuntime.controller.execute<T>(
      request: request,
      checkConnection: checkConnection,
      operationName: operationName,
      metadata: metadata,
      view: view,
    );
  }

  /// Executes an async operation with a loading dialog.
  static Future<T?> run<T extends Object>({
    required Future<T?> Function() request,
    required BuildContext context,
    ErrorViewType? viewType,
    VoidAsyncCallback? onCancel,
    VoidAsyncCallback? onConnectionError,
    VoidAsyncCallback? onConnectTimeout,
    VoidAsyncCallback? onReceiveTimeout,
    VoidAsyncCallback? onSendTimeout,
    VoidAsyncCallback? onResponseError,
    ErrorCallback? onError,
    SuccessCallback<T>? onSuccess,
    VoidAsyncCallback? onSessionExpired,
    ExecuterOptions options = ExecuterOptions.withDialog,
    CancelToken? cancelToken,
    SnackBarErrorBuilder? snackBarErrorBuilder,
    DialogErrorBuilder? dialogErrorBuilder,
    GlobalKey<ScaffoldState>? scaffoldKey,
  }) {
    return SmartExecuterRuntime.controller.run<T>(
      request: request,
      view: _createView(
        context: context,
        viewType: viewType ?? SmartExecuterConfig.instance.defaultViewType,
        snackBarErrorBuilder: snackBarErrorBuilder,
        dialogErrorBuilder: dialogErrorBuilder,
        scaffoldKey: scaffoldKey,
      ),
      options: options,
      callbacks: _callbacks(
        onCancel: onCancel,
        onConnectionError: onConnectionError,
        onConnectTimeout: onConnectTimeout,
        onReceiveTimeout: onReceiveTimeout,
        onSendTimeout: onSendTimeout,
        onResponseError: onResponseError,
        onError: onError,
        onSuccess: onSuccess,
        onSessionExpired: onSessionExpired,
      ),
    );
  }

  /// Executes an async operation without a loading dialog.
  static Future<T?> inBackground<T extends Object>({
    required Future<T?> Function() request,
    required BuildContext context,
    ErrorViewType? viewType,
    VoidAsyncCallback? onCancel,
    VoidAsyncCallback? onConnectionError,
    VoidAsyncCallback? onConnectTimeout,
    VoidAsyncCallback? onReceiveTimeout,
    VoidAsyncCallback? onSendTimeout,
    VoidAsyncCallback? onResponseError,
    ErrorCallback? onError,
    SuccessCallback<T>? onSuccess,
    VoidAsyncCallback? onSessionExpired,
    ExecuterOptions options = ExecuterOptions.background,
    CancelToken? cancelToken,
    SnackBarErrorBuilder? snackBarErrorBuilder,
    DialogErrorBuilder? dialogErrorBuilder,
    GlobalKey<ScaffoldState>? scaffoldKey,
  }) {
    return SmartExecuterRuntime.controller.run<T>(
      request: request,
      view: _createView(
        context: context,
        viewType: viewType ?? SmartExecuterConfig.instance.defaultViewType,
        snackBarErrorBuilder: snackBarErrorBuilder,
        dialogErrorBuilder: dialogErrorBuilder,
        scaffoldKey: scaffoldKey,
      ),
      options: options.copyWith(showLoadingDialog: false),
      callbacks: _callbacks(
        onCancel: onCancel,
        onConnectionError: onConnectionError,
        onConnectTimeout: onConnectTimeout,
        onReceiveTimeout: onReceiveTimeout,
        onSendTimeout: onSendTimeout,
        onResponseError: onResponseError,
        onError: onError,
        onSuccess: onSuccess,
        onSessionExpired: onSessionExpired,
      ),
    );
  }

  /// Executes a stream operation with a loading dialog.
  static Future<T?> runStream<T extends Object>({
    required Stream<T?> Function() requestStream,
    required BuildContext context,
    ErrorViewType? viewType,
    VoidAsyncCallback? onCancel,
    VoidAsyncCallback? onConnectionError,
    VoidAsyncCallback? onConnectTimeout,
    VoidAsyncCallback? onReceiveTimeout,
    VoidAsyncCallback? onSendTimeout,
    VoidAsyncCallback? onResponseError,
    ErrorCallback? onError,
    SuccessCallback<T>? onSuccess,
    VoidAsyncCallback? onSessionExpired,
    ExecuterOptions options = ExecuterOptions.withDialog,
    Widget Function(BuildContext context, T value)? waitingBuilder,
    void Function(T? value)? listener,
    SnackBarErrorBuilder? snackBarErrorBuilder,
    DialogErrorBuilder? dialogErrorBuilder,
    GlobalKey<ScaffoldState>? scaffoldKey,
  }) {
    return SmartExecuterRuntime.controller.runStream<T>(
      requestStream: requestStream,
      view: _createView(
        context: context,
        viewType: viewType ?? SmartExecuterConfig.instance.defaultViewType,
        snackBarErrorBuilder: snackBarErrorBuilder,
        dialogErrorBuilder: dialogErrorBuilder,
        scaffoldKey: scaffoldKey,
      ),
      options: options,
      callbacks: _callbacks(
        onCancel: onCancel,
        onConnectionError: onConnectionError,
        onConnectTimeout: onConnectTimeout,
        onReceiveTimeout: onReceiveTimeout,
        onSendTimeout: onSendTimeout,
        onResponseError: onResponseError,
        onError: onError,
        onSuccess: onSuccess,
        onSessionExpired: onSessionExpired,
      ),
      waitingBuilder: waitingBuilder,
      listener: listener,
    );
  }

  /// Executes a stream operation without a loading dialog.
  static Future<T?> inBackgroundStream<T extends Object>({
    required Stream<T?> Function() requestStream,
    required BuildContext context,
    ErrorViewType? viewType,
    VoidAsyncCallback? onCancel,
    VoidAsyncCallback? onConnectionError,
    VoidAsyncCallback? onConnectTimeout,
    VoidAsyncCallback? onReceiveTimeout,
    VoidAsyncCallback? onSendTimeout,
    VoidAsyncCallback? onResponseError,
    ErrorCallback? onError,
    SuccessCallback<T>? onSuccess,
    VoidAsyncCallback? onSessionExpired,
    ExecuterOptions options = ExecuterOptions.background,
    void Function(T? value)? listener,
    SnackBarErrorBuilder? snackBarErrorBuilder,
    DialogErrorBuilder? dialogErrorBuilder,
    GlobalKey<ScaffoldState>? scaffoldKey,
  }) {
    return SmartExecuterRuntime.controller.runStream<T>(
      requestStream: requestStream,
      view: _createView(
        context: context,
        viewType: viewType ?? SmartExecuterConfig.instance.defaultViewType,
        snackBarErrorBuilder: snackBarErrorBuilder,
        dialogErrorBuilder: dialogErrorBuilder,
        scaffoldKey: scaffoldKey,
      ),
      options: options.copyWith(showLoadingDialog: false),
      callbacks: _callbacks(
        onCancel: onCancel,
        onConnectionError: onConnectionError,
        onConnectTimeout: onConnectTimeout,
        onReceiveTimeout: onReceiveTimeout,
        onSendTimeout: onSendTimeout,
        onResponseError: onResponseError,
        onError: onError,
        onSuccess: onSuccess,
        onSessionExpired: onSessionExpired,
      ),
      listener: listener,
    );
  }

  static FlutterExecutionView _createView({
    required BuildContext context,
    required ErrorViewType viewType,
    SnackBarErrorBuilder? snackBarErrorBuilder,
    DialogErrorBuilder? dialogErrorBuilder,
    GlobalKey<ScaffoldState>? scaffoldKey,
  }) {
    final config = SmartExecuterConfig.instance;
    return FlutterExecutionView(
      context: context,
      viewType: viewType,
      config: config,
      snackBarErrorBuilder: snackBarErrorBuilder,
      dialogErrorBuilder: dialogErrorBuilder,
      scaffoldKey: scaffoldKey ?? config.scaffoldKey,
    );
  }

  static ExecutionCallbacks<T> _callbacks<T>({
    VoidAsyncCallback? onCancel,
    VoidAsyncCallback? onConnectionError,
    VoidAsyncCallback? onConnectTimeout,
    VoidAsyncCallback? onReceiveTimeout,
    VoidAsyncCallback? onSendTimeout,
    VoidAsyncCallback? onResponseError,
    ErrorCallback? onError,
    SuccessCallback<T>? onSuccess,
    VoidAsyncCallback? onSessionExpired,
  }) {
    return ExecutionCallbacks<T>(
      onCancel: onCancel,
      onConnectionError: onConnectionError,
      onConnectionTimeout: onConnectTimeout,
      onReceiveTimeout: onReceiveTimeout,
      onSendTimeout: onSendTimeout,
      onResponseError: onResponseError,
      onError: onError,
      onSuccess: onSuccess,
      onSessionExpired: onSessionExpired,
    );
  }
}
