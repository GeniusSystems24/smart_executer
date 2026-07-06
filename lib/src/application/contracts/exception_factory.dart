import 'package:smart_executer/src/domain/models/smart_exception.dart';

/// Creates domain exceptions from errors raised by external libraries.
abstract interface class ExceptionFactory {
  /// Maps [error] to a package-level [SmartException].
  SmartException create(
    Object error,
    StackTrace? stackTrace,
    ExceptionMetadata metadata,
  );
}
