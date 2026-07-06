import 'package:flutter/material.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';

class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final bool isPressed;
  final VoidCallback? onTap;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 20,
    this.backgroundColor,
    this.isPressed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.background;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: isPressed
                ? [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.5)
                          : Colors.grey.withValues(alpha: 0.3),
                      blurRadius: 5,
                      offset: const Offset(2, 2),
                    ),
                    BoxShadow(
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.white.withValues(alpha: 0.8),
                      blurRadius: 5,
                      offset: const Offset(-2, -2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.5)
                          : Colors.grey.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(5, 5),
                    ),
                    BoxShadow(
                      color: isDark
                          ? Colors.grey.shade800
                          : Colors.white.withValues(alpha: 0.9),
                      blurRadius: 15,
                      offset: const Offset(-5, -5),
                    ),
                  ],
          ),
          child: child,
        ),
      ),
    );
  }
}

// ============================================================================
// ANIMATED EXAMPLE CARD
// ============================================================================

/// Premium animated example card with hover effects and category badge
