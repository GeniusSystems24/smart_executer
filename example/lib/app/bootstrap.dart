import 'package:flutter/foundation.dart';
import 'package:smart_executer/smart_executer.dart';

/// Configures package-wide behavior used by every example screen.
void configureSmartExecuter({ExceptionBuilder? exceptionBuilder}) {
  SmartExecuterConfig.initialize(
    enableLogging: kDebugMode,
    defaultErrorMessage: (_) => 'Something went wrong. Please try again.',
    noConnectionMessage: (_) =>
        'No internet connection. Please check your network.',
    sessionExpiredMessage: (_) =>
        'Your session has expired. Please sign in again.',
    sessionExpiredTitle: (_) => 'Session Expired',
    defaultViewType: ErrorViewType.snackBar,
    checkConnectionByDefault: false,
    exceptionBuilder: exceptionBuilder,
    globalErrorHandler: (exception) async {
      debugPrint(
        'Global error [${exception.exceptionType.name}]: '
        '${exception.message}',
      );
      if (exception.metadata.hasData) {
        debugPrint('Metadata: ${exception.metadata.toMap()}');
      }
    },
  );
}
