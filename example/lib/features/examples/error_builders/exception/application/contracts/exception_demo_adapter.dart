import 'package:smart_executer_example/features/examples/error_builders/exception/domain/models/exception_demo_case.dart';

/// Boundary between the exception-builder example and transport-specific errors.
abstract interface class ExceptionDemoAdapter {
  /// Enables or disables the example's custom exception mapping.
  void configure({required bool useCustomBuilder});

  /// Creates the technical error used by the selected demonstration case.
  Object createError(ExceptionDemoCase demoCase);
}
