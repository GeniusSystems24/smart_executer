/// Error snack bar widget for SmartExecuter.
///
/// This library provides customizable error snack bars for displaying errors
/// with per-exception-type styling, icons, and colors.
library;

import 'package:flutter/material.dart';
import 'package:smart_executer/src/core/exceptions.dart';

/// A modern, professional error snack bar with per-exception-type styling.
///
/// Features:
/// - Distinct icon per error type
/// - Color-coded backgrounds
/// - Rounded corners with floating behavior
/// - Clean typography
///
/// Usage:
/// ```dart
/// ScaffoldMessenger.of(context).showSnackBar(
///   SmartErrorSnackBar(exception: exception),
/// );
/// ```
class SmartErrorSnackBar extends SnackBar {
  /// Creates a [SmartErrorSnackBar].
  SmartErrorSnackBar({
    super.key,
    required SmartException exception,
    String? customMessage,
    Widget? leading,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    Color? textColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    ShapeBorder? shape,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    DismissDirection dismissDirection = DismissDirection.down,
    double? elevation,
    double? width,
    bool showCloseIcon = false,
    Color? closeIconColor,
  }) : super(
          content: _SmartErrorContent(
            message: customMessage ?? exception.message,
            icon: leading == null ? _getIcon(exception) : null,
            leading: leading,
            textColor: textColor,
          ),
          action: action,
          duration: duration,
          backgroundColor: backgroundColor ?? _getBackgroundColor(exception),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          margin: margin ?? const EdgeInsets.all(8.0),
          shape: shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          behavior: behavior,
          dismissDirection: dismissDirection,
          elevation: elevation ?? 6.0,
          width: width,
          showCloseIcon: showCloseIcon,
          closeIconColor: closeIconColor,
        );

  static Color _getBackgroundColor(SmartException exception) {
    return switch (exception) {
      ConnectionException() => const Color(0xFFFF9800),
      ConnectionTimeoutException() => const Color(0xFFFF5722),
      SendTimeoutException() => const Color(0xFFFF5722),
      ReceiveTimeoutException() => const Color(0xFFFF5722),
      CancelledException() => const Color(0xFF78909C),
      ResponseException() => const Color(0xFFF44336),
      SessionExpiredException() => const Color(0xFF1976D2),
      UnknownException() => const Color(0xFFF44336),
    };
  }

  static IconData _getIcon(SmartException exception) {
    return switch (exception) {
      ConnectionException() => Icons.wifi_off_rounded,
      ConnectionTimeoutException() => Icons.timer_off_rounded,
      SendTimeoutException() => Icons.upload_rounded,
      ReceiveTimeoutException() => Icons.download_rounded,
      CancelledException() => Icons.cancel_rounded,
      ResponseException() => Icons.cloud_off_rounded,
      SessionExpiredException() => Icons.lock_outline_rounded,
      UnknownException() => Icons.error_outline_rounded,
    };
  }
}

class _SmartErrorContent extends StatelessWidget {
  const _SmartErrorContent({
    required this.message,
    this.icon,
    this.leading,
    this.textColor,
  });

  final String message;
  final IconData? icon;
  final Widget? leading;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: 12.0),
        ] else if (icon != null) ...[
          Icon(icon, color: textColor ?? Colors.white, size: 24.0),
          const SizedBox(width: 12.0),
        ],
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: textColor ?? Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// A success snack bar for displaying success messages.
///
/// Usage:
/// ```dart
/// ScaffoldMessenger.of(context).showSnackBar(
///   SmartSuccessSnackBar(message: 'Operation completed successfully!'),
/// );
/// ```
class SmartSuccessSnackBar extends SnackBar {
  /// Creates a [SmartSuccessSnackBar].
  SmartSuccessSnackBar({
    super.key,
    required String message,
    Widget? leading,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    ShapeBorder? shape,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    DismissDirection dismissDirection = DismissDirection.down,
    double? elevation,
    double? width,
    bool showCloseIcon = false,
    Color? closeIconColor,
  }) : super(
          content: Row(
            children: [
              leading ??
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: textColor ?? Colors.white,
                    size: 24.0,
                  ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          action: action,
          duration: duration,
          backgroundColor: backgroundColor ?? const Color(0xFF4CAF50),
          padding: padding ??
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          margin: margin ?? const EdgeInsets.all(8.0),
          shape: shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          behavior: behavior,
          dismissDirection: dismissDirection,
          elevation: elevation ?? 6.0,
          width: width,
          showCloseIcon: showCloseIcon,
          closeIconColor: closeIconColor,
        );
}

/// Helper class for showing snack bars.
abstract final class SmartSnackBars {
  /// Shows an error snack bar.
  static void showError(
    BuildContext context,
    SmartException exception, {
    String? customMessage,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SmartErrorSnackBar(
          exception: exception,
          customMessage: customMessage,
          action: action,
          duration: duration,
        ),
      );
  }

  /// Shows a success snack bar.
  static void showSuccess(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SmartSuccessSnackBar(
          message: message,
          action: action,
          duration: duration,
        ),
      );
  }

  /// Shows a custom snack bar with a message.
  static void show(
    BuildContext context,
    String message, {
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: textColor ?? Colors.white),
                const SizedBox(width: 12.0),
              ],
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: textColor ?? Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          action: action,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.all(8.0),
        ),
      );
  }
}
