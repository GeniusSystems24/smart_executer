/// Default loading dialog widget for SmartExecuter.
///
/// This library provides customizable loading dialogs for async operations.
library;

import 'package:flutter/material.dart';

/// A customizable loading dialog that displays during async operations.
///
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => const SmartLoadingDialog(),
/// );
/// ```
class SmartLoadingDialog extends StatelessWidget {
  /// Creates a [SmartLoadingDialog].
  const SmartLoadingDialog({
    super.key,
    this.message,
    this.indicatorColor,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.padding,
    this.indicatorSize = 40.0,
    this.messageStyle,
  });

  /// Optional message to display below the loading indicator.
  final String? message;

  /// Color of the loading indicator.
  final Color? indicatorColor;

  /// Background color of the dialog.
  final Color? backgroundColor;

  /// Elevation of the dialog.
  final double? elevation;

  /// Shape of the dialog.
  final ShapeBorder? shape;

  /// Padding inside the dialog.
  final EdgeInsetsGeometry? padding;

  /// Size of the loading indicator.
  final double indicatorSize;

  /// Text style for the message.
  final TextStyle? messageStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: backgroundColor ??
            theme.dialogTheme.backgroundColor ??
            theme.colorScheme.surface,
        elevation: elevation ?? 8.0,
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: indicatorSize,
                height: indicatorSize,
                child: CircularProgressIndicator(
                  strokeWidth: 3.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    indicatorColor ?? theme.colorScheme.primary,
                  ),
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: 16.0),
                Text(
                  message!,
                  style: messageStyle ?? theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A loading dialog that can show progress.
///
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => SmartProgressDialog(
///     progress: 0.5,
///     message: 'Uploading...',
///   ),
/// );
/// ```
class SmartProgressDialog extends StatelessWidget {
  /// Creates a [SmartProgressDialog].
  const SmartProgressDialog({
    super.key,
    required this.progress,
    this.message,
    this.showPercentage = true,
    this.progressColor,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.padding,
    this.messageStyle,
    this.percentageStyle,
  });

  /// Current progress value (0.0 to 1.0).
  final double progress;

  /// Optional message to display above the progress bar.
  final String? message;

  /// Whether to show the percentage text.
  final bool showPercentage;

  /// Color of the progress indicator.
  final Color? progressColor;

  /// Background color of the dialog.
  final Color? backgroundColor;

  /// Elevation of the dialog.
  final double? elevation;

  /// Shape of the dialog.
  final ShapeBorder? shape;

  /// Padding inside the dialog.
  final EdgeInsetsGeometry? padding;

  /// Text style for the message.
  final TextStyle? messageStyle;

  /// Text style for the percentage.
  final TextStyle? percentageStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percentage = (progress * 100).toInt();

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: backgroundColor ??
            theme.dialogTheme.backgroundColor ??
            theme.colorScheme.surface,
        elevation: elevation ?? 8.0,
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (message != null) ...[
                Text(
                  message!,
                  style: messageStyle ?? theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16.0),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  minHeight: 8.0,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressColor ?? theme.colorScheme.primary,
                  ),
                  backgroundColor:
                      (progressColor ?? theme.colorScheme.primary).withAlpha(51),
                ),
              ),
              if (showPercentage) ...[
                const SizedBox(height: 8.0),
                Text(
                  '$percentage%',
                  style: percentageStyle ??
                      theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(153),
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A minimal loading overlay that covers the entire screen.
///
/// Usage:
/// ```dart
/// showDialog(
///   context: context,
///   barrierColor: Colors.black54,
///   builder: (context) => const SmartLoadingOverlay(),
/// );
/// ```
class SmartLoadingOverlay extends StatelessWidget {
  /// Creates a [SmartLoadingOverlay].
  const SmartLoadingOverlay({
    super.key,
    this.indicatorColor,
    this.indicatorSize = 48.0,
  });

  /// Color of the loading indicator.
  final Color? indicatorColor;

  /// Size of the loading indicator.
  final double indicatorSize;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Center(
        child: SizedBox(
          width: indicatorSize,
          height: indicatorSize,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              indicatorColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
