import 'package:flutter/material.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';

enum RetryLogType { info, success, warning, error }

final class RetryLog {
  const RetryLog(this.message, this.type, this.timestamp);

  final String message;
  final RetryLogType type;
  final DateTime timestamp;

  Color get color => switch (type) {
        RetryLogType.info => Colors.white70,
        RetryLogType.success => AppColors.success,
        RetryLogType.warning => AppColors.warning,
        RetryLogType.error => AppColors.error,
      };

  IconData get icon => switch (type) {
        RetryLogType.info => Icons.info_outline,
        RetryLogType.success => Icons.check_circle_outline,
        RetryLogType.warning => Icons.warning_amber_rounded,
        RetryLogType.error => Icons.error_outline,
      };
}
