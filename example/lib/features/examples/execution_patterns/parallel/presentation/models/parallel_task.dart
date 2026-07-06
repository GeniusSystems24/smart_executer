import 'package:flutter/material.dart';

enum ParallelTaskStatus { pending, running, done, error }

final class ParallelTask {
  const ParallelTask({
    required this.name,
    required this.endpoint,
    required this.icon,
    required this.color,
    this.status = ParallelTaskStatus.pending,
    this.result,
    this.elapsedMilliseconds,
  });

  final String name;
  final String endpoint;
  final IconData icon;
  final Color color;
  final ParallelTaskStatus status;
  final String? result;
  final int? elapsedMilliseconds;

  ParallelTask copyWith({
    ParallelTaskStatus? status,
    String? result,
    int? elapsedMilliseconds,
  }) {
    return ParallelTask(
      name: name,
      endpoint: endpoint,
      icon: icon,
      color: color,
      status: status ?? this.status,
      result: result ?? this.result,
      elapsedMilliseconds: elapsedMilliseconds ?? this.elapsedMilliseconds,
    );
  }
}
