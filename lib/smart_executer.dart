/// Smart Executer - A powerful Flutter package for executing async operations.
///
/// This package provides a simple yet powerful way to execute async operations
/// with built-in error handling, loading dialogs, retry logic, and more.
///
/// ## Getting Started
///
/// Initialize the package in your app's main function:
///
/// ```dart
/// void main() {
///   SmartExecuterConfig.initialize(
///     enableLogging: true,
///     defaultErrorMessage: (_) => 'Something went wrong',
///   );
///   runApp(MyApp());
/// }
/// ```
///
/// ## Basic Usage
///
/// Execute an async operation with a loading dialog:
///
/// ```dart
/// final user = await SmartExecuter.run(
///   () => apiService.getUser(id),
///   context: context,
/// );
/// ```
///
/// Execute in background without UI:
///
/// ```dart
/// final result = await SmartExecuter.execute(
///   () => apiService.fetchData(),
/// );
///
/// switch (result) {
///   case Success(:final data):
///     handleData(data);
///   case Failure(:final exception):
///     handleError(exception);
/// }
/// ```
///
/// ## Features
///
/// - **Loading Dialogs**: Customizable loading dialogs during operations
/// - **Error Handling**: Comprehensive error handling with specific callbacks
/// - **Error Builders**: Per-exception-type SnackBar and Dialog builders
/// - **Result Pattern**: Type-safe success/failure handling
/// - **Connection Checking**: Optional network connectivity checks
/// - **Session Management**: Built-in session expiration handling
/// - **Stream Support**: First-class support for stream-based operations
/// - **Customizable UI**: Fully customizable dialogs and snack bars
///
/// See the [README](https://pub.dev/packages/smart_executer) for more details.
library;

// Core exports
export 'src/core/executer.dart' show SmartExecuter;
export 'src/core/exceptions.dart';
export 'src/core/result.dart';

// Configuration exports
export 'src/config/smart_executer_config.dart';
export 'src/config/error_builders.dart';

// Widget exports
export 'src/presentation/widgets/loading_dialog.dart';
export 'src/presentation/widgets/error_snack_bar.dart';
export 'src/presentation/widgets/error_dialog.dart';
export 'src/presentation/widgets/status_cards.dart';

// Utility exports
export 'src/utils/connectivity_checker.dart';
