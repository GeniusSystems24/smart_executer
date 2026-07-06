/// Basic error, success, warning, information, and empty cards.
library;

import 'package:flutter/material.dart';
import 'package:smart_executer/src/core/exceptions.dart';
import 'package:smart_executer/src/presentation/widgets/status/smart_status_card.dart';

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
///
/// // With custom widgets
/// SmartErrorCard(
///   titleWidget: Text('Custom Title', style: myStyle),
///   bodyWidget: Column(children: [...]),
///   actionsWidget: Row(children: [...]),
///   showCloseButton: true,
///   onClose: () => dismiss(),
/// )
/// ```
class SmartErrorCard extends SmartStatusCard {
  const SmartErrorCard({
    super.key,
    super.title,
    super.titleWidget,
    super.message,
    super.bodyWidget,
    super.icon,
    super.iconWidget,
    super.iconColor,
    super.backgroundColor,
    super.borderColor,
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
    super.closeButtonColor,
  });

  /// Creates an error card from a [SmartException].
  factory SmartErrorCard.fromException(
    SmartException exception, {
    Key? key,
    String? action,
    VoidCallback? onActionPressed,
    String? secondaryAction,
    VoidCallback? onSecondaryActionPressed,
    Widget? actionsWidget,
    bool showCloseButton = false,
    VoidCallback? onClose,
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
      actionsWidget: actionsWidget,
      showCloseButton: showCloseButton,
      onClose: onClose,
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
    super.title,
    super.titleWidget,
    super.message,
    super.bodyWidget,
    super.icon,
    super.iconWidget,
    super.iconColor,
    super.backgroundColor,
    super.borderColor,
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
    super.closeButtonColor,
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
    super.title,
    super.titleWidget,
    super.message,
    super.bodyWidget,
    super.icon,
    super.iconWidget,
    super.iconColor,
    super.backgroundColor,
    super.borderColor,
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
    super.closeButtonColor,
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
    super.title,
    super.titleWidget,
    super.message,
    super.bodyWidget,
    super.icon,
    super.iconWidget,
    super.iconColor,
    super.backgroundColor,
    super.borderColor,
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
    super.closeButtonColor,
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
    super.title,
    super.titleWidget,
    super.message,
    super.bodyWidget,
    super.icon,
    super.iconWidget,
    super.iconColor,
    super.backgroundColor,
    super.borderColor,
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
    super.closeButtonColor,
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
