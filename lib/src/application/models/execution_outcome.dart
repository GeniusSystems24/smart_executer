import 'package:smart_executer/src/domain/models/result.dart';

/// Identifies where a failed operation stopped.
enum ExecutionFailureStage {
  /// The optional connectivity preflight failed before the operation started.
  preflight,

  /// The operation itself or its stream failed.
  operation,
}

/// Internal application result with failure-stage information.
final class ExecutionOutcome<T> {
  ExecutionOutcome.success(T data)
      : result = Success<T>(data),
        failureStage = null;

  ExecutionOutcome.failure(
    Failure<T> failure, {
    required this.failureStage,
  }) : result = failure;

  final Result<T> result;
  final ExecutionFailureStage? failureStage;
}
