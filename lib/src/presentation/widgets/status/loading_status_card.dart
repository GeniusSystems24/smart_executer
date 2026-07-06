/// Loading status card presentation.
library;

import 'package:flutter/material.dart';

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
    this.titleWidget,
    this.message,
    this.bodyWidget,
    this.indicatorWidget,
    this.indicatorColor,
    this.backgroundColor,
    this.borderColor,
    this.padding,
    this.margin,
    this.borderRadius,
    this.elevation,
    this.indicatorSize = 48.0,
    this.showCloseButton = false,
    this.onClose,
    this.closeButtonColor,
  });

  /// Card title text.
  final String title;

  /// Custom title widget (overrides [title]).
  final Widget? titleWidget;

  /// Message text.
  final String? message;

  /// Custom body widget (overrides [message]).
  final Widget? bodyWidget;

  /// Custom indicator widget.
  final Widget? indicatorWidget;

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

  /// Whether to show a close button.
  final bool showCloseButton;

  /// Callback when close button is pressed.
  final VoidCallback? onClose;

  /// Close button color.
  final Color? closeButtonColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(12.0);

    return Container(
      margin: margin ?? const EdgeInsets.all(16.0),
      child: Material(
        elevation: elevation ?? 0,
        borderRadius: effectiveBorderRadius,
        color: backgroundColor ?? const Color(0xFFF3F4F6),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: effectiveBorderRadius,
            border: Border.all(
              color: borderColor ?? const Color(0xFFD1D5DB),
              width: 1.0,
            ),
          ),
          child: Stack(
            children: [
              Padding(
                padding: padding ?? const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showCloseButton) const SizedBox(height: 16.0),
                    _buildIndicator(theme),
                    const SizedBox(height: 16.0),
                    _buildTitle(theme),
                    if (message != null || bodyWidget != null) ...[
                      const SizedBox(height: 8.0),
                      _buildBody(theme),
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

  Widget _buildIndicator(ThemeData theme) {
    if (indicatorWidget != null) return indicatorWidget!;

    return SizedBox(
      width: indicatorSize,
      height: indicatorSize,
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          indicatorColor ?? theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    if (titleWidget != null) return titleWidget!;

    return Text(
      title,
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
