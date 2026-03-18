/// Configuration for SmartExecuter.
///
/// This library provides global configuration options for customizing
/// the behavior of SmartExecuter operations.
library;

import 'package:flutter/material.dart';
import 'package:smart_executer/src/config/error_builders.dart';
import 'package:smart_executer/src/core/exceptions.dart';

/// Callback type for handling errors.
typedef ErrorCallback = Future<void> Function(SmartException exception);

/// Callback type for handling session expiration.
typedef SessionExpiredCallback = Future<void> Function();

/// Builder type for creating loading dialogs.
typedef LoadingDialogBuilder = Widget Function(BuildContext context);

/// Builder type for creating session expired dialogs.
typedef SessionExpiredDialogBuilder = Widget Function(
  BuildContext context,
  VoidCallback onConfirm,
);

/// A function that returns a [String] given a [BuildContext].
///
/// Used for message fields in [SmartExecuterConfig] so that messages can be
/// resolved dynamically — for example, reading from a localization delegate:
/// ```dart
/// defaultErrorMessage: (context) => AppLocalizations.of(context)!.errorMessage,
/// ```
typedef MessageBuilder = String Function(BuildContext context);

/// Builder type for creating custom [SmartException] instances.
///
/// Receives the original [error], its [stackTrace], and the operation
/// [metadata]. Returns a [SmartException] (or `null` to fall back to the
/// default mapping via [ExceptionMapper]).
///
/// Example:
/// ```dart
/// SmartExecuterConfig.initialize(
///   exceptionBuilder: (error, stackTrace, metadata) {
///     if (error is DioException && error.response?.statusCode == 403) {
///       return ResponseException(
///         message: 'Access denied',
///         statusCode: 403,
///         metadata: metadata,
///       );
///     }
///     return null; // use default mapping
///   },
/// );
/// ```
typedef ExceptionBuilder = SmartException? Function(
  Object error,
  StackTrace? stackTrace,
  ExceptionMetadata metadata,
);

/// Global configuration for SmartExecuter.
///
/// Configure SmartExecuter once at app startup:
/// ```dart
/// void main() {
///   SmartExecuterConfig.initialize(
///     loadingDialogBuilder: (context) => MyCustomLoadingDialog(),
///     snackBarErrorBuilder: SnackBarErrorBuilder(
///       baseBuilder: (context, exception) => SnackBar(
///         content: Text(exception.message),
///       ),
///     ),
///     dialogErrorBuilder: DialogErrorBuilder(
///       baseBuilder: (context, exception) => AlertDialog(
///         title: Text('Error'),
///         content: Text(exception.message),
///       ),
///     ),
///     // Static string
///     defaultErrorMessage: (_) => 'Something went wrong',
///     // Or dynamic / localized string
///     noConnectionMessage: (context) => AppLocalizations.of(context)!.noConnection,
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
    SnackBarErrorBuilder? snackBarErrorBuilder,
    DialogErrorBuilder? dialogErrorBuilder,
    SessionExpiredDialogBuilder? sessionExpiredDialogBuilder,
    ErrorCallback? globalErrorHandler,
    SessionExpiredCallback? onSessionExpired,
    MessageBuilder? defaultErrorMessage,
    MessageBuilder? noConnectionMessage,
    MessageBuilder? sessionExpiredMessage,
    MessageBuilder? sessionExpiredTitle,
    bool enableLogging = false,
    Duration? defaultTimeout,
    bool checkConnectionByDefault = false,
    ErrorViewType defaultViewType = ErrorViewType.snackBar,
    GlobalKey<ScaffoldState>? scaffoldKey,
    ExceptionBuilder? exceptionBuilder,
  }) {
    final config = instance;
    config._loadingDialogBuilder = loadingDialogBuilder;
    config._snackBarErrorBuilder = snackBarErrorBuilder;
    config._dialogErrorBuilder = dialogErrorBuilder;
    config._sessionExpiredDialogBuilder = sessionExpiredDialogBuilder;
    config._globalErrorHandler = globalErrorHandler;
    config._onSessionExpired = onSessionExpired;
    config._defaultErrorMessage = defaultErrorMessage;
    config._noConnectionMessage = noConnectionMessage;
    config._sessionExpiredMessage = sessionExpiredMessage;
    config._sessionExpiredTitle = sessionExpiredTitle;
    config._enableLogging = enableLogging;
    config._defaultTimeout = defaultTimeout;
    config._checkConnectionByDefault = checkConnectionByDefault;
    config._defaultViewType = defaultViewType;
    config._scaffoldKey = scaffoldKey;
    config._exceptionBuilder = exceptionBuilder;
  }

  /// Resets the configuration to defaults.
  static void reset() {
    _instance = SmartExecuterConfig._();
  }

  // Private configuration fields
  LoadingDialogBuilder? _loadingDialogBuilder;
  SnackBarErrorBuilder? _snackBarErrorBuilder;
  DialogErrorBuilder? _dialogErrorBuilder;
  SessionExpiredDialogBuilder? _sessionExpiredDialogBuilder;
  ErrorCallback? _globalErrorHandler;
  SessionExpiredCallback? _onSessionExpired;
  MessageBuilder? _defaultErrorMessage;
  MessageBuilder? _noConnectionMessage;
  MessageBuilder? _sessionExpiredMessage;
  MessageBuilder? _sessionExpiredTitle;
  bool _enableLogging = false;
  Duration? _defaultTimeout;
  bool _checkConnectionByDefault = false;
  ErrorViewType _defaultViewType = ErrorViewType.snackBar;
  GlobalKey<ScaffoldState>? _scaffoldKey;
  ExceptionBuilder? _exceptionBuilder;

  /// Builder for creating loading dialogs.
  LoadingDialogBuilder? get loadingDialogBuilder => _loadingDialogBuilder;

  /// Builder for creating error snack bars.
  ///
  /// If null, the library's default [SmartErrorSnackBar] is used.
  SnackBarErrorBuilder? get snackBarErrorBuilder => _snackBarErrorBuilder;

  /// Builder for creating error dialogs.
  ///
  /// If null, the library's default [SmartErrorDialog] is used.
  DialogErrorBuilder? get dialogErrorBuilder => _dialogErrorBuilder;

  /// Builder for creating session expired dialogs.
  SessionExpiredDialogBuilder? get sessionExpiredDialogBuilder =>
      _sessionExpiredDialogBuilder;

  /// Global error handler called for all errors.
  ErrorCallback? get globalErrorHandler => _globalErrorHandler;

  /// Callback when session expires (401 response).
  SessionExpiredCallback? get onSessionExpired => _onSessionExpired;

  /// Default error message when no specific message is available.
  ///
  /// Calls the [MessageBuilder] with [context] to allow dynamic/localized strings.
  String defaultErrorMessage(BuildContext context) =>
      _defaultErrorMessage?.call(context) ??
      'An error occurred. Please try again.';

  /// Message shown when there is no internet connection.
  ///
  /// Calls the [MessageBuilder] with [context] to allow dynamic/localized strings.
  String noConnectionMessage(BuildContext context) =>
      _noConnectionMessage?.call(context) ?? 'No internet connection';

  /// Message shown when the session has expired.
  ///
  /// Calls the [MessageBuilder] with [context] to allow dynamic/localized strings.
  String sessionExpiredMessage(BuildContext context) =>
      _sessionExpiredMessage?.call(context) ??
      'Your session has expired. Please sign in again.';

  /// Title for the session expired dialog.
  ///
  /// Calls the [MessageBuilder] with [context] to allow dynamic/localized strings.
  String sessionExpiredTitle(BuildContext context) =>
      _sessionExpiredTitle?.call(context) ?? 'Session Expired';

  /// Whether to enable logging for debugging.
  bool get enableLogging => _enableLogging;

  /// Default timeout for operations.
  Duration get defaultTimeout =>
      _defaultTimeout ?? const Duration(seconds: 30);

  /// Whether to check connection before requests by default.
  bool get checkConnectionByDefault => _checkConnectionByDefault;

  /// Default [ErrorViewType] used when no `viewType` is specified per-operation.
  ///
  /// Defaults to [ErrorViewType.snackBar].
  ErrorViewType get defaultViewType => _defaultViewType;

  /// Global [ScaffoldState] key for displaying [SnackBar]s.
  ///
  /// When provided, [ScaffoldMessenger] will use this key's context
  /// instead of the caller's [BuildContext]. This is useful when the
  /// calling widget's context is not under a [ScaffoldMessenger].
  GlobalKey<ScaffoldState>? get scaffoldKey => _scaffoldKey;

  /// Custom builder for creating [SmartException] instances.
  ///
  /// When provided, this builder is called first for every caught error.
  /// If it returns a [SmartException], that instance is used directly.
  /// If it returns `null`, the default [ExceptionMapper] is used instead.
  ExceptionBuilder? get exceptionBuilder => _exceptionBuilder;
}

/// Options for individual SmartExecuter operations.
///
/// Use this to override global configuration for specific operations:
/// ```dart
/// await SmartExecuter.run(
///   request: () => fetchData(),
///   context: context,
///   options: ExecuterOptions(
///     showLoadingDialog: true,
///     checkConnection: true,
///     operationName: 'fetchUserData',
///     metadata: {'userId': '123'},
///   ),
/// );
/// ```
final class ExecuterOptions {
  /// Creates new [ExecuterOptions].
  const ExecuterOptions({
    this.showLoadingDialog = true,
    this.checkConnection,
    this.timeout,
    this.loadingWidget,
    this.barrierDismissible = false,
    this.barrierColor,
    this.operationName,
    this.metadata,
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

  /// Timeout for the operation. If null, uses global configuration.
  final Duration? timeout;

  /// Custom loading widget to display.
  final Widget? loadingWidget;

  /// Whether the loading dialog can be dismissed by tapping outside.
  final bool barrierDismissible;

  /// Color of the barrier behind the loading dialog.
  final Color? barrierColor;

  /// Name of this operation for debugging and logging.
  ///
  /// This will be included in any exceptions thrown during this operation.
  /// Example: 'fetchUser', 'createOrder', 'uploadImage'
  final String? operationName;

  /// Additional metadata to attach to exceptions.
  ///
  /// This data will be included in any exceptions thrown during this operation,
  /// making it easier to debug and log errors.
  ///
  /// Example:
  /// ```dart
  /// metadata: {
  ///   'userId': currentUser.id,
  ///   'orderId': order.id,
  ///   'screen': 'checkout',
  /// }
  /// ```
  final Map<String, dynamic>? metadata;

  /// Creates a copy of this options with some fields replaced.
  ExecuterOptions copyWith({
    bool? showLoadingDialog,
    bool? checkConnection,
    Duration? timeout,
    Widget? loadingWidget,
    bool? barrierDismissible,
    Color? barrierColor,
    String? operationName,
    Map<String, dynamic>? metadata,
  }) {
    return ExecuterOptions(
      showLoadingDialog: showLoadingDialog ?? this.showLoadingDialog,
      checkConnection: checkConnection ?? this.checkConnection,
      timeout: timeout ?? this.timeout,
      loadingWidget: loadingWidget ?? this.loadingWidget,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      barrierColor: barrierColor ?? this.barrierColor,
      operationName: operationName ?? this.operationName,
      metadata: metadata ?? this.metadata,
    );
  }
}
