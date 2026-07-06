enum ExecutionStepStatus { pending, done, error }

final class ExecutionStep {
  const ExecutionStep({
    required this.title,
    required this.description,
    this.status = ExecutionStepStatus.pending,
    this.result,
    this.elapsedMilliseconds,
  });

  final String title;
  final String description;
  final ExecutionStepStatus status;
  final String? result;
  final int? elapsedMilliseconds;

  ExecutionStep copyWith({
    ExecutionStepStatus? status,
    String? result,
    int? elapsedMilliseconds,
  }) {
    return ExecutionStep(
      title: title,
      description: description,
      status: status ?? this.status,
      result: result ?? this.result,
      elapsedMilliseconds: elapsedMilliseconds ?? this.elapsedMilliseconds,
    );
  }
}
