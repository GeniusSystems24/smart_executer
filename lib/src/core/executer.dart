/// Core execution logic for SmartExecuter.
///
/// This library provides the main [SmartExecuter] class for executing
/// async operations with error handling, loading dialogs, and more.
library;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:smart_executer/src/config/smart_executer_config.dart';
import 'package:smart_executer/src/core/exceptions.dart';
import 'package:smart_executer/src/core/result.dart';
import 'package:smart_executer/src/utils/connectivity_checker.dart';
import 'package:smart_executer/src/widgets/error_snack_bar.dart';
import 'package:smart_executer/src/widgets/loading_dialog.dart';

/// Callback types for SmartExecuter.
typedef VoidAsyncCallback = Future<void> Function();
typedef SuccessCallback<T> = Future<void> Function(T result);
typedef ErrorCallback = Future<void> Function(SmartException exception);

/// A powerful utility class for executing async operations with built-in
/// error handling, loading dialogs, retry logic, and more.
///
/// ## Basic Usage
///
/// ```dart
/// // Execute with loading dialog
/// final user = await SmartExecuter.run(
///   () => apiService.getUser(id),
///   context: context,
/// );
///
/// // Execute in background (no dialog)
/// final data = await SmartExecuter.inBackground(
///   () => apiService.fetchData(),
///   context: context,
/// );
/// ```
///
/// ## With Result Pattern
///
/// ```dart
/// final result = await SmartExecuter.execute(
///   () => apiService.getUser(id),
/// );
///
/// switch (result) {
///   case Success(:final data):
///     print('User: ${data.name}');
///   case Failure(:final exception):
///     print('Error: ${exception.message}');
/// }
/// ```
///
/// ## With Metadata for Debugging
///
/// ```dart
/// await SmartExecuter.run(
///   () => apiService.createOrder(data),
///   context: context,
///   options: ExecuterOptions(
///     operationName: 'createOrder',
///     metadata: {
///       'userId': currentUser.id,
///       'orderId': order.id,
///     },
///   ),
///   onError: (exception) async {
///     // exception.metadata contains operationName, userId, orderId
///     logger.error('Failed ${exception.metadata.operationName}',
///       extra: exception.metadata.toMap());
///   },
/// );
/// ```
abstract final class SmartExecuter {
  static final Logger _logger = Logger();

  /// Creates [ExceptionMetadata] from [ExecuterOptions].
  static ExceptionMetadata _createMetadata(ExecuterOptions options) {
    return ExceptionMetadata(
      operationName: options.operationName,
      timestamp: DateTime.now(),
      extra: options.metadata,
    );
  }

  /// Executes an async operation and returns a [Result].
  ///
  /// This method provides a clean way to handle success and failure cases
  /// without using callbacks. It does not show any UI elements.
  ///
  /// The [operationName] and [metadata] parameters are attached to any
  /// exceptions that occur, making debugging easier.
  ///
  /// Example:
  /// ```dart
  /// final result = await SmartExecuter.execute(
  ///   () => fetchUser(id),
  ///   operationName: 'fetchUser',
  ///   metadata: {'userId': id},
  /// );
  ///
  /// result.onFailure((e) {
  ///   print('Operation: ${e.metadata.operationName}');
  ///   print('Details: ${e.metadata.extra}');
  /// });
  /// ```
  static Future<Result<T>> execute<T>(
    Future<T> Function() request, {
    bool checkConnection = false,
    int? maxRetries,
    Duration? retryDelay,
    CancelToken? cancelToken,
    String? operationName,
    Map<String, dynamic>? metadata,
  }) async {
    final config = SmartExecuterConfig.instance;
    final retries = maxRetries ?? config.maxRetries;
    final delay = retryDelay ?? config.retryDelay;

    // Create metadata for exceptions
    final exceptionMetadata = ExceptionMetadata(
      operationName: operationName,
      timestamp: DateTime.now(),
      extra: metadata,
    );

    // Check connection if required
    if (checkConnection || config.checkConnectionByDefault) {
      final hasConnection = await ConnectivityChecker.hasConnection();
      if (!hasConnection) {
        return Failure(ConnectionException(
          'No internet connection',
          null,
          null,
          exceptionMetadata,
        ));
      }
    }

    int attempts = 0;
    SmartException? lastException;

    while (attempts <= retries) {
      try {
        final result = await request();
        return Success(result);
      } on DioException catch (e, stackTrace) {
        lastException = ExceptionMapper.fromDioException(e, exceptionMetadata);
        _logError('DioException', e, stackTrace, exceptionMetadata);

        // Don't retry on these errors
        if (e.type == DioExceptionType.cancel ||
            e.type == DioExceptionType.badResponse) {
          break;
        }

        attempts++;
        if (attempts <= retries) {
          await Future.delayed(delay * attempts);
        }
      } catch (e, stackTrace) {
        lastException = ExceptionMapper.fromException(e, stackTrace, exceptionMetadata);
        _logError('Exception', e, stackTrace, exceptionMetadata);
        break; // Don't retry on unknown errors
      }
    }

    // Call global error handler if configured
    await config.globalErrorHandler?.call(lastException!);

    return Failure(lastException!);
  }

  /// Executes an async operation with a loading dialog.
  ///
  /// Shows a loading dialog while the operation is in progress and handles
  /// errors with snack bars. Supports callbacks for various scenarios.
  ///
  /// Use [options.operationName] and [options.metadata] to attach debugging
  /// information to any exceptions that occur.
  ///
  /// Example:
  /// ```dart
  /// final user = await SmartExecuter.run(
  ///   () => apiService.getUser(id),
  ///   context: context,
  ///   options: ExecuterOptions(
  ///     operationName: 'getUser',
  ///     metadata: {'userId': id},
  ///   ),
  ///   onError: (exception) async {
  ///     analytics.logError(
  ///       exception.metadata.operationName ?? 'unknown',
  ///       exception.metadata.toMap(),
  ///     );
  ///   },
  /// );
  /// ```
  static Future<T?> run<T extends Object>({
    required Future<T?> Function() request,
    required BuildContext context,
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
  }) async {
    return _executeWithUI<T>(
      request: request,
      context: context,
      onCancel: onCancel,
      onConnectionError: onConnectionError,
      onConnectTimeout: onConnectTimeout,
      onReceiveTimeout: onReceiveTimeout,
      onSendTimeout: onSendTimeout,
      onResponseError: onResponseError,
      onError: onError,
      onSuccess: onSuccess,
      onSessionExpired: onSessionExpired,
      options: options,
      cancelToken: cancelToken,
    );
  }

  /// Executes an async operation in the background without UI.
  ///
  /// Similar to [run] but doesn't show a loading dialog. Errors are still
  /// displayed via snack bars unless suppressed.
  ///
  /// Example:
  /// ```dart
  /// // Silently refresh data
  /// final data = await SmartExecuter.inBackground(
  ///   () => apiService.refreshCache(),
  ///   context: context,
  ///   options: ExecuterOptions(
  ///     operationName: 'refreshCache',
  ///   ),
  /// );
  /// ```
  static Future<T?> inBackground<T extends Object>({
    required Future<T?> Function() request,
    required BuildContext context,
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
  }) async {
    return _executeWithUI<T>(
      request: request,
      context: context,
      onCancel: onCancel,
      onConnectionError: onConnectionError,
      onConnectTimeout: onConnectTimeout,
      onReceiveTimeout: onReceiveTimeout,
      onSendTimeout: onSendTimeout,
      onResponseError: onResponseError,
      onError: onError,
      onSuccess: onSuccess,
      onSessionExpired: onSessionExpired,
      options: options.copyWith(showLoadingDialog: false),
      cancelToken: cancelToken,
    );
  }

  /// Executes a stream-based operation with a loading dialog.
  ///
  /// Shows a loading dialog that can display real-time progress from the
  /// stream using the [waitingBuilder] parameter.
  ///
  /// Example:
  /// ```dart
  /// await SmartExecuter.runStream(
  ///   () => uploadService.uploadWithProgress(file),
  ///   context: context,
  ///   options: ExecuterOptions(
  ///     operationName: 'uploadFile',
  ///     metadata: {'fileName': file.name},
  ///   ),
  ///   listener: (progress) {
  ///     print('Progress: ${progress.percentage}%');
  ///   },
  ///   waitingBuilder: (context, progress) {
  ///     return SmartProgressDialog(
  ///       progress: progress.percentage / 100,
  ///       message: 'Uploading...',
  ///     );
  ///   },
  /// );
  /// ```
  static Future<T?> runStream<T extends Object>({
    required Stream<T?> Function() requestStream,
    required BuildContext context,
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
  }) async {
    return _executeStreamWithUI<T>(
      requestStream: requestStream,
      context: context,
      onCancel: onCancel,
      onConnectionError: onConnectionError,
      onConnectTimeout: onConnectTimeout,
      onReceiveTimeout: onReceiveTimeout,
      onSendTimeout: onSendTimeout,
      onResponseError: onResponseError,
      onError: onError,
      onSuccess: onSuccess,
      onSessionExpired: onSessionExpired,
      options: options,
      waitingBuilder: waitingBuilder,
      listener: listener,
    );
  }

  /// Executes a stream-based operation in the background.
  ///
  /// Similar to [runStream] but without a loading dialog.
  static Future<T?> inBackgroundStream<T extends Object>({
    required Stream<T?> Function() requestStream,
    required BuildContext context,
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
  }) async {
    return _executeStreamWithUI<T>(
      requestStream: requestStream,
      context: context,
      onCancel: onCancel,
      onConnectionError: onConnectionError,
      onConnectTimeout: onConnectTimeout,
      onReceiveTimeout: onReceiveTimeout,
      onSendTimeout: onSendTimeout,
      onResponseError: onResponseError,
      onError: onError,
      onSuccess: onSuccess,
      onSessionExpired: onSessionExpired,
      options: options.copyWith(showLoadingDialog: false),
      listener: listener,
    );
  }

  // Private implementation methods

  static Future<T?> _executeWithUI<T>({
    required Future<T?> Function() request,
    required BuildContext context,
    VoidAsyncCallback? onCancel,
    VoidAsyncCallback? onConnectionError,
    VoidAsyncCallback? onConnectTimeout,
    VoidAsyncCallback? onReceiveTimeout,
    VoidAsyncCallback? onSendTimeout,
    VoidAsyncCallback? onResponseError,
    ErrorCallback? onError,
    SuccessCallback<T>? onSuccess,
    VoidAsyncCallback? onSessionExpired,
    required ExecuterOptions options,
    CancelToken? cancelToken,
  }) async {
    final config = SmartExecuterConfig.instance;
    final metadata = _createMetadata(options);

    // Check connection if required
    final checkConnection = options.checkConnection ?? config.checkConnectionByDefault;
    if (checkConnection) {
      final hasConnection = await ConnectivityChecker.hasConnection();
      if (!hasConnection) {
        final exception = ConnectionException(
          config.noConnectionMessage,
          null,
          null,
          metadata,
        );
        await onConnectionError?.call();
        if (context.mounted) {
          _showError(context, exception);
        }
        return null;
      }
    }

    // Show loading dialog
    if (options.showLoadingDialog && context.mounted) {
      _showLoadingDialog(context, options);
    }

    T? response;

    try {
      response = await request();

      // Hide loading dialog
      if (options.showLoadingDialog && context.mounted) {
        Navigator.of(context).pop(response);
      }

      // Call success callback
      if (onSuccess != null && response != null) {
        await onSuccess(response);
      }

      return response;
    } on DioException catch (e, stackTrace) {
      _logError('DioException', e, stackTrace, metadata);

      // Hide loading dialog
      if (options.showLoadingDialog && context.mounted) {
        Navigator.of(context).pop();
      }

      final exception = ExceptionMapper.fromDioException(e, metadata);
      await _handleDioError(
        context: context,
        exception: exception,
        dioException: e,
        onCancel: onCancel,
        onConnectTimeout: onConnectTimeout,
        onReceiveTimeout: onReceiveTimeout,
        onSendTimeout: onSendTimeout,
        onResponseError: onResponseError,
        onError: onError,
        onSessionExpired: onSessionExpired,
      );
    } catch (e, stackTrace) {
      _logError('Exception', e, stackTrace, metadata);

      // Hide loading dialog
      if (options.showLoadingDialog && context.mounted) {
        Navigator.of(context).pop();
      }

      final exception = ExceptionMapper.fromException(e, stackTrace, metadata);
      await onError?.call(exception);
      await config.globalErrorHandler?.call(exception);

      if (context.mounted) {
        _showError(context, exception);
      }
    }

    return response;
  }

  static Future<T?> _executeStreamWithUI<T>({
    required Stream<T?> Function() requestStream,
    required BuildContext context,
    VoidAsyncCallback? onCancel,
    VoidAsyncCallback? onConnectionError,
    VoidAsyncCallback? onConnectTimeout,
    VoidAsyncCallback? onReceiveTimeout,
    VoidAsyncCallback? onSendTimeout,
    VoidAsyncCallback? onResponseError,
    ErrorCallback? onError,
    SuccessCallback<T>? onSuccess,
    VoidAsyncCallback? onSessionExpired,
    required ExecuterOptions options,
    Widget Function(BuildContext context, T value)? waitingBuilder,
    void Function(T? value)? listener,
  }) async {
    final config = SmartExecuterConfig.instance;
    final metadata = _createMetadata(options);

    // Check connection if required
    final checkConnection = options.checkConnection ?? config.checkConnectionByDefault;
    if (checkConnection) {
      final hasConnection = await ConnectivityChecker.hasConnection();
      if (!hasConnection) {
        final exception = ConnectionException(
          config.noConnectionMessage,
          null,
          null,
          metadata,
        );
        await onConnectionError?.call();
        if (context.mounted) {
          _showError(context, exception);
        }
        return null;
      }
    }

    final streamValue = ValueNotifier<T?>(null);
    final completer = Completer<T?>();
    StreamSubscription<T?>? subscription;

    // Show loading dialog
    if (options.showLoadingDialog && context.mounted) {
      unawaited(
        showDialog<T>(
          context: context,
          barrierDismissible: options.barrierDismissible,
          barrierColor: options.barrierColor,
          builder: (dialogContext) => ValueListenableBuilder<T?>(
            valueListenable: streamValue,
            builder: (context, value, child) {
              if (waitingBuilder != null && value != null) {
                return waitingBuilder(context, value);
              }
              return options.loadingWidget ??
                  config.loadingDialogBuilder?.call(context) ??
                  const SmartLoadingDialog();
            },
          ),
        ),
      );
    }

    try {
      subscription = requestStream().listen(
        (event) {
          listener?.call(event);
          streamValue.value = event;
          if (event != null && !completer.isCompleted) {
            completer.complete(event);
          }
        },
        onError: (error, stackTrace) {
          _logError('Stream error', error, stackTrace, metadata);
          if (!completer.isCompleted) {
            completer.completeError(error, stackTrace);
          }
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.complete(streamValue.value);
          }
        },
      );

      final response = await completer.future;

      // Hide loading dialog
      if (options.showLoadingDialog && context.mounted) {
        Navigator.of(context).pop(response);
      }

      // Call success callback
      if (onSuccess != null && response != null) {
        await onSuccess(response);
      }

      return response;
    } on DioException catch (e, stackTrace) {
      _logError('DioException', e, stackTrace, metadata);

      // Hide loading dialog
      if (options.showLoadingDialog && context.mounted) {
        Navigator.of(context).pop();
      }

      final exception = ExceptionMapper.fromDioException(e, metadata);
      await _handleDioError(
        context: context,
        exception: exception,
        dioException: e,
        onCancel: onCancel,
        onConnectTimeout: onConnectTimeout,
        onReceiveTimeout: onReceiveTimeout,
        onSendTimeout: onSendTimeout,
        onResponseError: onResponseError,
        onError: onError,
        onSessionExpired: onSessionExpired,
      );
    } catch (e, stackTrace) {
      _logError('Exception', e, stackTrace, metadata);

      // Hide loading dialog
      if (options.showLoadingDialog && context.mounted) {
        Navigator.of(context).pop();
      }

      final exception = ExceptionMapper.fromException(e, stackTrace, metadata);
      await onError?.call(exception);
      await config.globalErrorHandler?.call(exception);

      if (context.mounted) {
        _showError(context, exception);
      }
    } finally {
      await subscription?.cancel();
      streamValue.dispose();
    }

    return null;
  }

  static Future<void> _handleDioError({
    required BuildContext context,
    required SmartException exception,
    required DioException dioException,
    VoidAsyncCallback? onCancel,
    VoidAsyncCallback? onConnectTimeout,
    VoidAsyncCallback? onReceiveTimeout,
    VoidAsyncCallback? onSendTimeout,
    VoidAsyncCallback? onResponseError,
    ErrorCallback? onError,
    VoidAsyncCallback? onSessionExpired,
  }) async {
    final config = SmartExecuterConfig.instance;

    // Call specific callback based on error type
    switch (dioException.type) {
      case DioExceptionType.cancel:
        await onCancel?.call();
      case DioExceptionType.connectionTimeout:
        await onConnectTimeout?.call();
      case DioExceptionType.receiveTimeout:
        await onReceiveTimeout?.call();
      case DioExceptionType.sendTimeout:
        await onSendTimeout?.call();
      case DioExceptionType.badResponse:
        if (dioException.response?.statusCode == 401) {
          await _handleSessionExpired(context, onSessionExpired);
          return; // Don't show error snackbar for session expired
        }
        await onResponseError?.call();
      default:
        break;
    }

    // Call generic error callback
    await onError?.call(exception);
    await config.globalErrorHandler?.call(exception);

    // Show error
    if (context.mounted) {
      _showError(context, exception);
    }
  }

  static Future<void> _handleSessionExpired(
    BuildContext context,
    VoidAsyncCallback? onSessionExpired,
  ) async {
    final config = SmartExecuterConfig.instance;

    // Call the callback first
    await onSessionExpired?.call();
    await config.onSessionExpired?.call();

    // Show session expired dialog
    if (context.mounted) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          if (config.sessionExpiredDialogBuilder != null) {
            return config.sessionExpiredDialogBuilder!(
              dialogContext,
              () => Navigator.of(dialogContext).pop(),
            );
          }
          return AlertDialog(
            title: Text(config.sessionExpiredTitle),
            content: Text(config.sessionExpiredMessage),
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

  static void _showLoadingDialog(BuildContext context, ExecuterOptions options) {
    final config = SmartExecuterConfig.instance;

    showDialog<void>(
      context: context,
      barrierDismissible: options.barrierDismissible,
      barrierColor: options.barrierColor,
      builder: (dialogContext) {
        return options.loadingWidget ??
            config.loadingDialogBuilder?.call(dialogContext) ??
            const SmartLoadingDialog();
      },
    );
  }

  static void _showError(BuildContext context, SmartException exception) {
    final config = SmartExecuterConfig.instance;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        config.errorSnackBarBuilder?.call(context, exception) ??
            SmartErrorSnackBar(exception: exception),
      );
  }

  static void _logError(
    String type,
    Object error,
    StackTrace stackTrace,
    ExceptionMetadata metadata,
  ) {
    if (SmartExecuterConfig.instance.enableLogging) {
      final metadataStr = metadata.hasData ? ' | Metadata: $metadata' : '';
      _logger.e('$type: $error$metadataStr', stackTrace: stackTrace);
    }
  }
}
