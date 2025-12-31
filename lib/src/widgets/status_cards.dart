/// Status cards for displaying different states in the UI.
///
/// This library provides ready-to-use cards for error, success,
/// warning, info, loading, and empty states.
library;

import 'package:flutter/material.dart';
import 'package:smart_executer/src/core/exceptions.dart';

/// Base class for status cards with common styling.
abstract class SmartStatusCard extends StatelessWidget {
  const SmartStatusCard({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.action,
    this.onActionPressed,
    this.secondaryAction,
    this.onSecondaryActionPressed,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.showIcon = true,
  });

  /// Card title.
  final String title;

  /// Optional message/description.
  final String? message;

  /// Custom icon (uses default if not provided).
  final IconData? icon;

  /// Icon color (uses default based on card type if not provided).
  final Color? iconColor;

  /// Background color (uses default based on card type if not provided).
  final Color? backgroundColor;

  /// Border color (uses default based on card type if not provided).
  final Color? borderColor;

  /// Primary action button text.
  final String? action;

  /// Callback for primary action.
  final VoidCallback? onActionPressed;

  /// Secondary action button text.
  final String? secondaryAction;

  /// Callback for secondary action.
  final VoidCallback? onSecondaryActionPressed;

  /// Padding inside the card.
  final EdgeInsetsGeometry? padding;

  /// Margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Border radius of the card.
  final BorderRadius? borderRadius;

  /// Card elevation.
  final double? elevation;

  /// Whether to show the icon.
  final bool showIcon;

  /// Default icon for this card type.
  IconData get defaultIcon;

  /// Default icon color for this card type.
  Color get defaultIconColor;

  /// Default background color for this card type.
  Color get defaultBackgroundColor;

  /// Default border color for this card type.
  Color get defaultBorderColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin ?? const EdgeInsets.all(16.0),
      child: Material(
        elevation: elevation ?? 0,
        borderRadius: borderRadius ?? BorderRadius.circular(12.0),
        color: backgroundColor ?? defaultBackgroundColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(12.0),
            border: Border.all(
              color: borderColor ?? defaultBorderColor,
              width: 1.0,
            ),
          ),
          padding: padding ?? const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showIcon) ...[
                Icon(
                  icon ?? defaultIcon,
                  size: 48.0,
                  color: iconColor ?? defaultIconColor,
                ),
                const SizedBox(height: 16.0),
              ],
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: 8.0),
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(179),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (action != null || secondaryAction != null) ...[
                const SizedBox(height: 24.0),
                _buildActions(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (secondaryAction != null) ...[
          OutlinedButton(
            onPressed: onSecondaryActionPressed,
            child: Text(secondaryAction!),
          ),
          const SizedBox(width: 12.0),
        ],
        if (action != null)
          FilledButton(
            onPressed: onActionPressed,
            child: Text(action!),
          ),
      ],
    );
  }
}

/// Card for displaying error states.
///
/// Usage:
/// ```dart
/// SmartErrorCard(
///   title: 'Something went wrong',
///   message: 'Please try again later',
///   action: 'Retry',
///   onActionPressed: () => fetchData(),
/// )
/// ```
class SmartErrorCard extends SmartStatusCard {
  const SmartErrorCard({
    super.key,
    required super.title,
    super.message,
    super.icon,
    super.iconColor,
    super.backgroundColor,
    super.borderColor,
    super.action,
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
  });

  /// Creates an error card from a [SmartException].
  factory SmartErrorCard.fromException(
    SmartException exception, {
    Key? key,
    String? action,
    VoidCallback? onActionPressed,
    String? secondaryAction,
    VoidCallback? onSecondaryActionPressed,
  }) {
    return SmartErrorCard(
      key: key,
      title: _getTitleFromException(exception),
      message: exception.message,
      icon: _getIconFromException(exception),
      action: action,
      onActionPressed: onActionPressed,
      secondaryAction: secondaryAction,
      onSecondaryActionPressed: onSecondaryActionPressed,
    );
  }

  static String _getTitleFromException(SmartException exception) {
    return switch (exception) {
      ConnectionException() => 'No Connection',
      ConnectionTimeoutException() => 'Connection Timeout',
      SendTimeoutException() => 'Send Timeout',
      ReceiveTimeoutException() => 'Receive Timeout',
      CancelledException() => 'Cancelled',
      ResponseException() => 'Server Error',
      SessionExpiredException() => 'Session Expired',
      UnknownException() => 'Error',
    };
  }

  static IconData _getIconFromException(SmartException exception) {
    return switch (exception) {
      ConnectionException() => Icons.wifi_off_rounded,
      ConnectionTimeoutException() => Icons.timer_off_rounded,
      SendTimeoutException() => Icons.upload_rounded,
      ReceiveTimeoutException() => Icons.download_rounded,
      CancelledException() => Icons.cancel_rounded,
      ResponseException() => Icons.cloud_off_rounded,
      SessionExpiredException() => Icons.lock_clock_rounded,
      UnknownException() => Icons.error_outline_rounded,
    };
  }

  @override
  IconData get defaultIcon => Icons.error_outline_rounded;

  @override
  Color get defaultIconColor => const Color(0xFFDC3545);

  @override
  Color get defaultBackgroundColor => const Color(0xFFFDF2F2);

  @override
  Color get defaultBorderColor => const Color(0xFFFCA5A5);
}

/// Card for displaying success states.
///
/// Usage:
/// ```dart
/// SmartSuccessCard(
///   title: 'Success!',
///   message: 'Your order has been placed',
///   action: 'Continue',
///   onActionPressed: () => navigateHome(),
/// )
/// ```
class SmartSuccessCard extends SmartStatusCard {
  const SmartSuccessCard({
    super.key,
    required super.title,
    super.message,
    super.icon,
    super.iconColor,
    super.backgroundColor,
    super.borderColor,
    super.action,
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
  });

  @override
  IconData get defaultIcon => Icons.check_circle_outline_rounded;

  @override
  Color get defaultIconColor => const Color(0xFF28A745);

  @override
  Color get defaultBackgroundColor => const Color(0xFFF0FDF4);

  @override
  Color get defaultBorderColor => const Color(0xFF86EFAC);
}

/// Card for displaying warning states.
///
/// Usage:
/// ```dart
/// SmartWarningCard(
///   title: 'Warning',
///   message: 'Your session will expire in 5 minutes',
///   action: 'Extend Session',
///   onActionPressed: () => extendSession(),
/// )
/// ```
class SmartWarningCard extends SmartStatusCard {
  const SmartWarningCard({
    super.key,
    required super.title,
    super.message,
    super.icon,
    super.iconColor,
    super.backgroundColor,
    super.borderColor,
    super.action,
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
  });

  @override
  IconData get defaultIcon => Icons.warning_amber_rounded;

  @override
  Color get defaultIconColor => const Color(0xFFFFC107);

  @override
  Color get defaultBackgroundColor => const Color(0xFFFFFBEB);

  @override
  Color get defaultBorderColor => const Color(0xFFFDE68A);
}

/// Card for displaying info states.
///
/// Usage:
/// ```dart
/// SmartInfoCard(
///   title: 'Did you know?',
///   message: 'You can swipe to dismiss notifications',
///   action: 'Got it',
///   onActionPressed: () => dismiss(),
/// )
/// ```
class SmartInfoCard extends SmartStatusCard {
  const SmartInfoCard({
    super.key,
    required super.title,
    super.message,
    super.icon,
    super.iconColor,
    super.backgroundColor,
    super.borderColor,
    super.action,
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
  });

  @override
  IconData get defaultIcon => Icons.info_outline_rounded;

  @override
  Color get defaultIconColor => const Color(0xFF0D6EFD);

  @override
  Color get defaultBackgroundColor => const Color(0xFFEFF6FF);

  @override
  Color get defaultBorderColor => const Color(0xFF93C5FD);
}

/// Card for displaying empty states.
///
/// Usage:
/// ```dart
/// SmartEmptyCard(
///   title: 'No items yet',
///   message: 'Add your first item to get started',
///   action: 'Add Item',
///   onActionPressed: () => addItem(),
/// )
/// ```
class SmartEmptyCard extends SmartStatusCard {
  const SmartEmptyCard({
    super.key,
    required super.title,
    super.message,
    super.icon,
    super.iconColor,
    super.backgroundColor,
    super.borderColor,
    super.action,
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
  });

  @override
  IconData get defaultIcon => Icons.inbox_outlined;

  @override
  Color get defaultIconColor => const Color(0xFF6B7280);

  @override
  Color get defaultBackgroundColor => const Color(0xFFF9FAFB);

  @override
  Color get defaultBorderColor => const Color(0xFFE5E7EB);
}

/// Card for displaying loading states.
///
/// Usage:
/// ```dart
/// SmartLoadingCard(
///   title: 'Loading...',
///   message: 'Please wait while we fetch your data',
/// )
/// ```
class SmartLoadingCard extends StatelessWidget {
  const SmartLoadingCard({
    super.key,
    this.title = 'Loading...',
    this.message,
    this.indicatorColor,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.indicatorSize = 48.0,
  });

  /// Card title.
  final String title;

  /// Optional message.
  final String? message;

  /// Loading indicator color.
  final Color? indicatorColor;

  /// Background color.
  final Color? backgroundColor;

  /// Border color.
  final Color? borderColor;

  /// Padding inside the card.
  final EdgeInsetsGeometry? padding;

  /// Margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Border radius.
  final BorderRadius? borderRadius;

  /// Card elevation.
  final double? elevation;

  /// Size of the loading indicator.
  final double indicatorSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin ?? const EdgeInsets.all(16.0),
      child: Material(
        elevation: elevation ?? 0,
        borderRadius: borderRadius ?? BorderRadius.circular(12.0),
        color: backgroundColor ?? const Color(0xFFF3F4F6),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(12.0),
            border: Border.all(
              color: borderColor ?? const Color(0xFFD1D5DB),
              width: 1.0,
            ),
          ),
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
              const SizedBox(height: 16.0),
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: 8.0),
                Text(
                  message!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(179),
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

/// Card for displaying offline/no connection state.
///
/// Usage:
/// ```dart
/// SmartOfflineCard(
///   onRetry: () => checkConnection(),
/// )
/// ```
class SmartOfflineCard extends SmartErrorCard {
  const SmartOfflineCard({
    super.key,
    super.title = 'No Internet Connection',
    super.message = 'Please check your network settings and try again',
    super.action = 'Retry',
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
  }) : super(icon: Icons.wifi_off_rounded);
}

/// Card for displaying session expired state.
///
/// Usage:
/// ```dart
/// SmartSessionExpiredCard(
///   onSignIn: () => navigateToLogin(),
/// )
/// ```
class SmartSessionExpiredCard extends SmartWarningCard {
  const SmartSessionExpiredCard({
    super.key,
    super.title = 'Session Expired',
    super.message = 'Your session has expired. Please sign in again to continue.',
    super.action = 'Sign In',
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
  }) : super(icon: Icons.lock_clock_rounded);
}

/// Card for displaying timeout state.
///
/// Usage:
/// ```dart
/// SmartTimeoutCard(
///   onRetry: () => retryRequest(),
/// )
/// ```
class SmartTimeoutCard extends SmartErrorCard {
  const SmartTimeoutCard({
    super.key,
    super.title = 'Request Timeout',
    super.message = 'The request took too long. Please try again.',
    super.action = 'Try Again',
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
  }) : super(icon: Icons.timer_off_rounded);
}

/// Card for displaying server error state.
///
/// Usage:
/// ```dart
/// SmartServerErrorCard(
///   onRetry: () => retryRequest(),
/// )
/// ```
class SmartServerErrorCard extends SmartErrorCard {
  const SmartServerErrorCard({
    super.key,
    super.title = 'Server Error',
    super.message = 'Something went wrong on our end. Please try again later.',
    super.action = 'Try Again',
    super.onActionPressed,
    super.secondaryAction = 'Contact Support',
    super.onSecondaryActionPressed,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
  }) : super(icon: Icons.cloud_off_rounded);
}

/// Card for displaying maintenance state.
///
/// Usage:
/// ```dart
/// SmartMaintenanceCard()
/// ```
class SmartMaintenanceCard extends SmartInfoCard {
  const SmartMaintenanceCard({
    super.key,
    super.title = 'Under Maintenance',
    super.message = 'We are currently performing scheduled maintenance. Please check back soon.',
    super.action,
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
  }) : super(icon: Icons.build_circle_outlined);
}

/// Card for displaying permission denied state.
///
/// Usage:
/// ```dart
/// SmartPermissionDeniedCard(
///   permission: 'Camera',
///   onRequestPermission: () => requestCameraPermission(),
/// )
/// ```
class SmartPermissionDeniedCard extends SmartWarningCard {
  SmartPermissionDeniedCard({
    super.key,
    String permission = 'Permission',
    super.message = 'This feature requires access to continue.',
    super.action = 'Grant Access',
    super.onActionPressed,
    super.secondaryAction = 'Open Settings',
    super.onSecondaryActionPressed,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
  }) : super(
          title: '$permission Required',
          icon: Icons.lock_outline_rounded,
        );
}

/// Card for displaying not found (404) state.
///
/// Usage:
/// ```dart
/// SmartNotFoundCard(
///   itemName: 'Product',
///   onGoBack: () => Navigator.pop(context),
/// )
/// ```
class SmartNotFoundCard extends SmartEmptyCard {
  SmartNotFoundCard({
    super.key,
    String itemName = 'Item',
    super.message = 'The item you are looking for does not exist or has been removed.',
    super.action = 'Go Back',
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
  }) : super(
          title: '$itemName Not Found',
          icon: Icons.search_off_rounded,
        );
}
