/// Error dialog widget for SmartExecuter.
///
/// This library provides a modern, professional error dialog for displaying
/// errors with per-exception-type styling.
library;

import 'package:flutter/material.dart';
import 'package:smart_executer/src/core/exceptions.dart';

/// A modern, professional error dialog with per-exception-type styling.
///
/// Features:
/// - Colored circular icon header matching the error type
/// - Distinct icon per error type
/// - Title derived from exception type
/// - Clean Material 3 aesthetic with rounded corners
///
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (_) => SmartErrorDialog(exception: exception),
/// );
/// ```
class SmartErrorDialog extends StatelessWidget {
  /// Creates a [SmartErrorDialog].
  const SmartErrorDialog({
    super.key,
    required this.exception,
    this.customMessage,
    this.customTitle,
    this.onDismiss,
  });

  /// The exception to display.
  final SmartException exception;

  /// Optional custom message to override the exception message.
  final String? customMessage;

  /// Optional custom title to override the default title.
  final String? customTitle;

  /// Optional callback when the dialog is dismissed.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor(exception);
    final icon = _getIcon(exception);
    final title = customTitle ?? _getTitle(exception);
    final message = customMessage ?? exception.message;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon circle
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Message
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // OK Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDismiss?.call();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Color _getColor(SmartException exception) {
    return switch (exception.exceptionType) {
      SmartExceptionType.connection => const Color(0xFFFF9800),
      SmartExceptionType.connectionTimeout => const Color(0xFFFF5722),
      SmartExceptionType.sendTimeout => const Color(0xFFFF5722),
      SmartExceptionType.receiveTimeout => const Color(0xFFFF5722),
      SmartExceptionType.cancelled => const Color(0xFF78909C),
      SmartExceptionType.response => const Color(0xFFF44336),
      SmartExceptionType.sessionExpired => const Color(0xFF1976D2),
      SmartExceptionType.unknown => const Color(0xFFF44336),
    };
  }

  static IconData _getIcon(SmartException exception) {
    return switch (exception.exceptionType) {
      SmartExceptionType.connection => Icons.wifi_off_rounded,
      SmartExceptionType.connectionTimeout => Icons.timer_off_rounded,
      SmartExceptionType.sendTimeout => Icons.upload_rounded,
      SmartExceptionType.receiveTimeout => Icons.download_rounded,
      SmartExceptionType.cancelled => Icons.cancel_rounded,
      SmartExceptionType.response => Icons.cloud_off_rounded,
      SmartExceptionType.sessionExpired => Icons.lock_outline_rounded,
      SmartExceptionType.unknown => Icons.error_outline_rounded,
    };
  }

  static String _getTitle(SmartException exception) {
    return switch (exception.exceptionType) {
      SmartExceptionType.connection => 'Connection Error',
      SmartExceptionType.connectionTimeout => 'Connection Timeout',
      SmartExceptionType.sendTimeout => 'Send Timeout',
      SmartExceptionType.receiveTimeout => 'Receive Timeout',
      SmartExceptionType.cancelled => 'Cancelled',
      SmartExceptionType.response => 'Server Error',
      SmartExceptionType.sessionExpired => 'Session Expired',
      SmartExceptionType.unknown => 'Error',
    };
  }
}
