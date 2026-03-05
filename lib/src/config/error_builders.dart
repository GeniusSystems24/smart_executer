/// Error builder configuration for SmartExecuter.
///
/// This library provides configurable error builders for displaying errors
/// as either SnackBars or Dialogs, with per-exception-type customization.
library;

import 'package:flutter/material.dart';
import 'package:smart_executer/src/core/exceptions.dart';
import 'package:smart_executer/src/widgets/error_dialog.dart';
import 'package:smart_executer/src/widgets/error_snack_bar.dart';

/// Determines how errors are displayed to the user.
enum ErrorViewType {
  /// Display errors as a SnackBar at the bottom of the screen.
  snackBar,

  /// Display errors as a Dialog in the center of the screen.
  dialog,
}

/// Builder function that creates a [SnackBar] from a [SmartException].
///
/// The [exception] contains full metadata via [SmartException.metadata],
/// including operation name, endpoint, request method, timestamps, and
/// any custom extra data attached during the operation.
typedef ErrorSnackBarBuilderFn = SnackBar Function(
  BuildContext context,
  SmartException exception,
);

/// Builder function that creates a dialog [Widget] from a [SmartException].
///
/// The [exception] contains full metadata via [SmartException.metadata],
/// including operation name, endpoint, request method, timestamps, and
/// any custom extra data attached during the operation.
typedef ErrorDialogBuilderFn = Widget Function(
  BuildContext context,
  SmartException exception,
);

/// Configures how errors are displayed as SnackBars.
///
/// Each [SmartException] subtype can have its own builder. The resolution
/// order is: specific builder → [baseBuilder] → package default.
///
/// All builders receive the full [SmartException] which carries:
/// - [SmartException.message] — the error message
/// - [SmartException.metadata] — full [ExceptionMetadata] with operation
///   name, endpoint, method, user/session IDs, timestamp, extra data
/// - [SmartException.cause] — the original underlying error
/// - Subclass-specific data (e.g. [ResponseException.statusCode])
///
/// Example:
/// ```dart
/// SmartExecuterConfig.initialize(
///   snackBarErrorBuilder: SnackBarErrorBuilder(
///     baseBuilder: (context, exception) => SnackBar(
///       content: Text(exception.message),
///     ),
///     connectionBuilder: (context, exception) => SnackBar(
///       content: Text('No internet: ${exception.metadata.operationName}'),
///       backgroundColor: Colors.orange,
///     ),
///   ),
/// );
/// ```
final class SnackBarErrorBuilder {
  /// Creates a new [SnackBarErrorBuilder].
  const SnackBarErrorBuilder({
    this.baseBuilder,
    this.connectionBuilder,
    this.connectionTimeoutBuilder,
    this.sendTimeoutBuilder,
    this.receiveTimeoutBuilder,
    this.cancelledBuilder,
    this.responseBuilder,
    this.sessionExpiredBuilder,
    this.customBuilder,
  });

  /// Default builder used when no specific builder matches.
  final ErrorSnackBarBuilderFn? baseBuilder;

  /// Builder for [ConnectionException].
  final ErrorSnackBarBuilderFn? connectionBuilder;

  /// Builder for [ConnectionTimeoutException].
  final ErrorSnackBarBuilderFn? connectionTimeoutBuilder;

  /// Builder for [SendTimeoutException].
  final ErrorSnackBarBuilderFn? sendTimeoutBuilder;

  /// Builder for [ReceiveTimeoutException].
  final ErrorSnackBarBuilderFn? receiveTimeoutBuilder;

  /// Builder for [CancelledException].
  final ErrorSnackBarBuilderFn? cancelledBuilder;

  /// Builder for [ResponseException].
  final ErrorSnackBarBuilderFn? responseBuilder;

  /// Builder for [SessionExpiredException].
  final ErrorSnackBarBuilderFn? sessionExpiredBuilder;

  /// Builder for [UnknownException] or any unhandled exception type.
  final ErrorSnackBarBuilderFn? customBuilder;

  /// Resolves the appropriate builder and creates a [SnackBar].
  SnackBar build(BuildContext context, SmartException exception) {
    final specificBuilder = switch (exception.exceptionType) {
      SmartExceptionType.connection => connectionBuilder,
      SmartExceptionType.connectionTimeout => connectionTimeoutBuilder,
      SmartExceptionType.sendTimeout => sendTimeoutBuilder,
      SmartExceptionType.receiveTimeout => receiveTimeoutBuilder,
      SmartExceptionType.cancelled => cancelledBuilder,
      SmartExceptionType.response => responseBuilder,
      SmartExceptionType.sessionExpired => sessionExpiredBuilder,
      SmartExceptionType.unknown => customBuilder,
    };

    final builder = specificBuilder ?? baseBuilder;
    if (builder != null) {
      return builder(context, exception);
    }

    return SmartErrorSnackBar(exception: exception);
  }
}

/// Configures how errors are displayed as Dialogs.
///
/// Each [SmartException] subtype can have its own builder. The resolution
/// order is: specific builder → [baseBuilder] → package default.
///
/// All builders receive the full [SmartException] which carries:
/// - [SmartException.message] — the error message
/// - [SmartException.metadata] — full [ExceptionMetadata] with operation
///   name, endpoint, method, user/session IDs, timestamp, extra data
/// - [SmartException.cause] — the original underlying error
/// - Subclass-specific data (e.g. [ResponseException.statusCode])
///
/// Example:
/// ```dart
/// SmartExecuterConfig.initialize(
///   dialogErrorBuilder: DialogErrorBuilder(
///     baseBuilder: (context, exception) => AlertDialog(
///       title: Text('Error'),
///       content: Text(exception.message),
///     ),
///     responseBuilder: (context, exception) {
///       final resp = exception as ResponseException;
///       return AlertDialog(
///         title: Text('Server Error ${resp.statusCode}'),
///         content: Text(resp.message),
///       );
///     },
///   ),
/// );
/// ```
final class DialogErrorBuilder {
  /// Creates a new [DialogErrorBuilder].
  const DialogErrorBuilder({
    this.baseBuilder,
    this.connectionBuilder,
    this.connectionTimeoutBuilder,
    this.sendTimeoutBuilder,
    this.receiveTimeoutBuilder,
    this.cancelledBuilder,
    this.responseBuilder,
    this.sessionExpiredBuilder,
    this.customBuilder,
  });

  /// Default builder used when no specific builder matches.
  final ErrorDialogBuilderFn? baseBuilder;

  /// Builder for [ConnectionException].
  final ErrorDialogBuilderFn? connectionBuilder;

  /// Builder for [ConnectionTimeoutException].
  final ErrorDialogBuilderFn? connectionTimeoutBuilder;

  /// Builder for [SendTimeoutException].
  final ErrorDialogBuilderFn? sendTimeoutBuilder;

  /// Builder for [ReceiveTimeoutException].
  final ErrorDialogBuilderFn? receiveTimeoutBuilder;

  /// Builder for [CancelledException].
  final ErrorDialogBuilderFn? cancelledBuilder;

  /// Builder for [ResponseException].
  final ErrorDialogBuilderFn? responseBuilder;

  /// Builder for [SessionExpiredException].
  final ErrorDialogBuilderFn? sessionExpiredBuilder;

  /// Builder for [UnknownException] or any unhandled exception type.
  final ErrorDialogBuilderFn? customBuilder;

  /// Resolves the appropriate builder and creates a dialog [Widget].
  Widget build(BuildContext context, SmartException exception) {
    final specificBuilder = switch (exception.exceptionType) {
      SmartExceptionType.connection => connectionBuilder,
      SmartExceptionType.connectionTimeout => connectionTimeoutBuilder,
      SmartExceptionType.sendTimeout => sendTimeoutBuilder,
      SmartExceptionType.receiveTimeout => receiveTimeoutBuilder,
      SmartExceptionType.cancelled => cancelledBuilder,
      SmartExceptionType.response => responseBuilder,
      SmartExceptionType.sessionExpired => sessionExpiredBuilder,
      SmartExceptionType.unknown => customBuilder,
    };

    final builder = specificBuilder ?? baseBuilder;
    if (builder != null) {
      return builder(context, exception);
    }

    return SmartErrorDialog(exception: exception);
  }
}
