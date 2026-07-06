import 'package:smart_executer/src/domain/models/smart_exception.dart';

/// Logging boundary used by execution use cases.
abstract interface class ExecutionLogger {
  /// Records an operation error without coupling the application layer to a
  /// concrete logging package.
  void logError(
    String category,
    Object error,
    StackTrace stackTrace,
    ExceptionMetadata metadata,
  );
}
