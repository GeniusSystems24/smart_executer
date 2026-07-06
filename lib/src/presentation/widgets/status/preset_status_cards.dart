/// Preconfigured status cards for common application states.
library;

import 'package:flutter/material.dart';
import 'package:smart_executer/src/presentation/widgets/status/basic_status_cards.dart';

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
    super.titleWidget,
    super.message = 'Please check your network settings and try again',
    super.bodyWidget,
    super.action = 'Retry',
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.actionsWidget,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
    super.showCloseButton,
    super.onClose,
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
    super.titleWidget,
    super.message = 'Your session has expired. Please sign in again to continue.',
    super.bodyWidget,
    super.action = 'Sign In',
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.actionsWidget,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
    super.showCloseButton,
    super.onClose,
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
    super.titleWidget,
    super.message = 'The request took too long. Please try again.',
    super.bodyWidget,
    super.action = 'Try Again',
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.actionsWidget,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
    super.showCloseButton,
    super.onClose,
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
    super.titleWidget,
    super.message = 'Something went wrong on our end. Please try again later.',
    super.bodyWidget,
    super.action = 'Try Again',
    super.onActionPressed,
    super.secondaryAction = 'Contact Support',
    super.onSecondaryActionPressed,
    super.actionsWidget,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
    super.showCloseButton,
    super.onClose,
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
    super.titleWidget,
    super.message = 'We are currently performing scheduled maintenance. Please check back soon.',
    super.bodyWidget,
    super.action,
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.actionsWidget,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
    super.showCloseButton,
    super.onClose,
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
  const SmartPermissionDeniedCard({
    super.key,
    String permission = 'Permission',
    super.titleWidget,
    super.message = 'This feature requires access to continue.',
    super.bodyWidget,
    super.action = 'Grant Access',
    super.onActionPressed,
    super.secondaryAction = 'Open Settings',
    super.onSecondaryActionPressed,
    super.actionsWidget,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
    super.showCloseButton,
    super.onClose,
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
  const SmartNotFoundCard({
    super.key,
    String itemName = 'Item',
    super.titleWidget,
    super.message = 'The item you are looking for does not exist or has been removed.',
    super.bodyWidget,
    super.action = 'Go Back',
    super.onActionPressed,
    super.secondaryAction,
    super.onSecondaryActionPressed,
    super.actionsWidget,
    super.padding,
    super.margin,
    super.borderRadius,
    super.elevation,
    super.showIcon,
    super.showCloseButton,
    super.onClose,
  }) : super(
          title: '$itemName Not Found',
          icon: Icons.search_off_rounded,
        );
}
