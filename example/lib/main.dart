import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

import 'core/app_router.dart';
import 'core/app_theme.dart';

void main() {
  // Initialize SmartExecuter configuration
  SmartExecuterConfig.initialize(
    enableLogging: kDebugMode,
    defaultErrorMessage: (_) => 'Something went wrong. Please try again.',
    noConnectionMessage: (_) => 'No internet connection. Please check your network.',
    sessionExpiredMessage: (_) => 'Your session has expired. Please sign in again.',
    sessionExpiredTitle: (_) => 'Session Expired',
    checkConnectionByDefault: false,
    globalErrorHandler: (exception) async {
      debugPrint(
          'Global error [${exception.exceptionType.name}]: ${exception.message}');
      if (exception.metadata.hasData) {
        debugPrint('Metadata: ${exception.metadata.toMap()}');
      }
    },
  );

  runApp(const SmartExecuterDemo());
}

class SmartExecuterDemo extends StatelessWidget {
  const SmartExecuterDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Smart Executer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
