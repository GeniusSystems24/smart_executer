/// Base presentation component for Smart Executer status cards.
library;

import 'package:flutter/material.dart';

/// Base class for status cards with common styling.
abstract class SmartStatusCard extends StatelessWidget {
  const SmartStatusCard({
    super.key,
    this.title,
    this.titleWidget,
    this.message,
    this.bodyWidget,
    this.icon,
    this.iconWidget,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.action,
    this.onActionPressed,
    this.secondaryAction,
    this.onSecondaryActionPressed,
    this.actionsWidget,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.showIcon = true,
    this.showCloseButton = false,
    this.onClose,
    this.closeButtonColor,
  }) : assert(
          title != null || titleWidget != null,
          'Either title or titleWidget must be provided',
        );

  /// Card title text.
  final String? title;

  /// Custom title widget (overrides [title]).
  final Widget? titleWidget;

  /// Message/description text.
  final String? message;

  /// Custom body widget (overrides [message]).
  final Widget? bodyWidget;

  /// Custom icon (uses default if not provided).
  final IconData? icon;

  /// Custom icon widget (overrides [icon]).
  final Widget? iconWidget;

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

  /// Custom actions widget (overrides [action] and [secondaryAction]).
  final Widget? actionsWidget;

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

  /// Whether to show a close button.
  final bool showCloseButton;

  /// Callback when close button is pressed.
  final VoidCallback? onClose;

  /// Close button color.
  final Color? closeButtonColor;

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
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12.0);

    return Container(
      margin: margin ?? const EdgeInsets.all(16.0),
      child: Material(
        elevation: elevation ?? 0,
        borderRadius: effectiveBorderRadius,
        color: backgroundColor ?? defaultBackgroundColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: borderColor ?? defaultBorderColor,
              width: 1.0,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: padding ?? const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showCloseButton) const SizedBox(height: 24.0),
                    if (showIcon) ...[
                      _buildIcon(theme),
                      const SizedBox(height: 16.0),
                    ],
                    _buildTitle(theme),
                    if (message != null || bodyWidget != null) ...[
                      const SizedBox(height: 8.0),
                      _buildBody(theme),
                    ],
                    if (_hasActions) ...[
                      const SizedBox(height: 24.0),
                      _buildActions(context),
                    ],
                  ],
                ),
              ),
              if (showCloseButton)
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: _buildCloseButton(theme),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    if (iconWidget != null) return iconWidget!;

    return Icon(
      icon ?? defaultIcon,
      size: 48.0,
      color: iconColor ?? defaultIconColor,
    );
  }

  Widget _buildTitle(ThemeData theme) {
    if (titleWidget != null) return titleWidget!;

    return Text(
      title!,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (bodyWidget != null) return bodyWidget!;

    return Text(
      message!,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withAlpha(179),
      ),
      textAlign: TextAlign.center,
    );
  }

  bool get _hasActions =>
      actionsWidget != null ||
      action != null ||
      secondaryAction != null;

  Widget _buildActions(BuildContext context) {
    if (actionsWidget != null) return actionsWidget!;

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

  Widget _buildCloseButton(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClose,
        borderRadius: BorderRadius.circular(20.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            Icons.close_rounded,
            size: 20.0,
            color: closeButtonColor ??
                theme.colorScheme.onSurface.withAlpha(150),
          ),
        ),
      ),
    );
  }
}
