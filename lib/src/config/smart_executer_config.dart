/// Configuration for SmartExecuter.
///
/// This library provides global configuration options for customizing
/// the behavior of SmartExecuter operations.
library;

import 'package:flutter/material.dart';
import 'package:smart_executer/src/core/exceptions.dart';

/// Callback type for handling errors.
typedef ErrorCallback = Future<void> Function(SmartException exception);

/// Callback type for handling session expiration.
typedef SessionExpiredCallback = Future<void> Function();

/// Builder type for creating loading dialogs.
typedef LoadingDialogBuilder = Widget Function(BuildContext context);

/// Builder type for creating error snack bars.
typedef ErrorSnackBarBuilder = SnackBar Function(
  BuildContext context,
  SmartException exception,
);

/// Builder type for creating session expired dialogs.
typedef SessionExpiredDialogBuilder = Widget Function(
  BuildContext context,
  VoidCallback onConfirm,
);

/// Global configuration for SmartExecuter.
///
/// Configure SmartExecuter once at app startup:
/// ```dart
/// void main() {
///   SmartExecuterConfig.initialize(
///     loadingDialogBuilder: (context) => MyCustomLoadingDialog(),
///     defaultErrorMessage: 'Something went wrong',
///     enableLogging: true,
///   );
///   runApp(MyApp());
/// }
/// ```
final class SmartExecuterConfig {
  SmartExecuterConfig._();

  static SmartExecuterConfig? _instance;

  /// Gets the singleton instance of [SmartExecuterConfig].
  static SmartExecuterConfig get instance {
    _instance ??= SmartExecuterConfig._();
    return _instance!;
  }

  /// Initializes the global configuration.
  ///
  /// Call this method once at app startup to configure SmartExecuter.
  static void initialize({
    LoadingDialogBuilder? loadingDialogBuilder,
    ErrorSnackBarBuilder? errorSnackBarBuilder,
    SessionExpiredDialogBuilder? sessionExpiredDialogBuilder,
    ErrorCallback? globalErrorHandler,
    SessionExpiredCallback? onSessionExpired,
    String? defaultErrorMessage,
    String? noConnectionMessage,
    String? sessionExpiredMessage,
    String? sessionExpiredTitle,
    bool enableLogging = false,
    Duration? defaultTimeout,
    int? maxRetries,
    Duration? retryDelay,
    bool checkConnectionByDefault = false,
  }) {
    final config = instance;
    config._loadingDialogBuilder = loadingDialogBuilder;
    config._errorSnackBarBuilder = errorSnackBarBuilder;
    config._sessionExpiredDialogBuilder = sessionExpiredDialogBuilder;
    config._globalErrorHandler = globalErrorHandler;
    config._onSessionExpired = onSessionExpired;
    config._defaultErrorMessage = defaultErrorMessage;
    config._noConnectionMessage = noConnectionMessage;
    config._sessionExpiredMessage = sessionExpiredMessage;
    config._sessionExpiredTitle = sessionExpiredTitle;
    config._enableLogging = enableLogging;
    config._defaultTimeout = defaultTimeout;
    config._maxRetries = maxRetries;
    config._retryDelay = retryDelay;
    config._checkConnectionByDefault = checkConnectionByDefault;
  }

  /// Resets the configuration to defaults.
  static void reset() {
    _instance = SmartExecuterConfig._();
  }

  // Private configuration fields
  LoadingDialogBuilder? _loadingDialogBuilder;
  ErrorSnackBarBuilder? _errorSnackBarBuilder;
  SessionExpiredDialogBuilder? _sessionExpiredDialogBuilder;
  ErrorCallback? _globalErrorHandler;
  SessionExpiredCallback? _onSessionExpired;
  String? _defaultErrorMessage;
  String? _noConnectionMessage;
  String? _sessionExpiredMessage;
  String? _sessionExpiredTitle;
  bool _enableLogging = false;
  Duration? _defaultTimeout;
  int? _maxRetries;
  Duration? _retryDelay;
  bool _checkConnectionByDefault = false;

  /// Builder for creating loading dialogs.
  LoadingDialogBuilder? get loadingDialogBuilder => _loadingDialogBuilder;

  /// Builder for creating error snack bars.
  ErrorSnackBarBuilder? get errorSnackBarBuilder => _errorSnackBarBuilder;

  /// Builder for creating session expired dialogs.
  SessionExpiredDialogBuilder? get sessionExpiredDialogBuilder =>
      _sessionExpiredDialogBuilder;

  /// Global error handler called for all errors.
  ErrorCallback? get globalErrorHandler => _globalErrorHandler;

  /// Callback when session expires (401 response).
  SessionExpiredCallback? get onSessionExpired => _onSessionExpired;

  /// Default error message when no specific message is available.
  String get defaultErrorMessage =>
      _defaultErrorMessage ?? 'An error occurred. Please try again.';

  /// Message shown when there is no internet connection.
  String get noConnectionMessage =>
      _noConnectionMessage ?? 'No internet connection';

  /// Message shown when the session has expired.
  String get sessionExpiredMessage =>
      _sessionExpiredMessage ?? 'Your session has expired. Please sign in again.';

  /// Title for the session expired dialog.
  String get sessionExpiredTitle =>
      _sessionExpiredTitle ?? 'Session Expired';

  /// Whether to enable logging for debugging.
  bool get enableLogging => _enableLogging;

  /// Default timeout for operations.
  Duration get defaultTimeout => _defaultTimeout ?? const Duration(seconds: 30);

  /// Maximum number of retry attempts.
  int get maxRetries => _maxRetries ?? 0;

  /// Delay between retry attempts.
  Duration get retryDelay => _retryDelay ?? const Duration(seconds: 1);

  /// Whether to check connection before requests by default.
  bool get checkConnectionByDefault => _checkConnectionByDefault;
}

/// Options for individual SmartExecuter operations.
///
/// Use this to override global configuration for specific operations:
/// ```dart
/// await SmartExecuter.run(
///   () => fetchData(),
///   context: context,
///   options: ExecuterOptions(
///     showLoadingDialog: true,
///     checkConnection: true,
///     maxRetries: 3,
///   ),
/// );
/// ```
final class ExecuterOptions {
  /// Creates new [ExecuterOptions].
  const ExecuterOptions({
    this.showLoadingDialog = true,
    this.checkConnection,
    this.maxRetries,
    this.retryDelay,
    this.timeout,
    this.loadingWidget,
    this.barrierDismissible = false,
    this.barrierColor,
  });

  /// Default options with loading dialog shown.
  static const withDialog = ExecuterOptions(showLoadingDialog: true);

  /// Default options without loading dialog (background operation).
  static const background = ExecuterOptions(showLoadingDialog: false);

  /// Whether to show a loading dialog during the operation.
  final bool showLoadingDialog;

  /// Whether to check internet connection before the operation.
  /// If null, uses the global configuration.
  final bool? checkConnection;

  /// Maximum number of retry attempts. If null, uses global configuration.
  final int? maxRetries;

  /// Delay between retry attempts. If null, uses global configuration.
  final Duration? retryDelay;

  /// Timeout for the operation. If null, uses global configuration.
  final Duration? timeout;

  /// Custom loading widget to display.
  final Widget? loadingWidget;

  /// Whether the loading dialog can be dismissed by tapping outside.
  final bool barrierDismissible;

  /// Color of the barrier behind the loading dialog.
  final Color? barrierColor;

  /// Creates a copy of this options with some fields replaced.
  ExecuterOptions copyWith({
    bool? showLoadingDialog,
    bool? checkConnection,
    int? maxRetries,
    Duration? retryDelay,
    Duration? timeout,
    Widget? loadingWidget,
    bool? barrierDismissible,
    Color? barrierColor,
  }) {
    return ExecuterOptions(
      showLoadingDialog: showLoadingDialog ?? this.showLoadingDialog,
      checkConnection: checkConnection ?? this.checkConnection,
      maxRetries: maxRetries ?? this.maxRetries,
      retryDelay: retryDelay ?? this.retryDelay,
      timeout: timeout ?? this.timeout,
      loadingWidget: loadingWidget ?? this.loadingWidget,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      barrierColor: barrierColor ?? this.barrierColor,
    );
  }
}
