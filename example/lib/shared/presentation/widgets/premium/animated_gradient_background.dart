import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;
  final List<Color>? colors;
  final bool showParticles;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.showParticles = true,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                math.cos(_controller.value * 2 * math.pi),
                math.sin(_controller.value * 2 * math.pi),
              ),
              end: Alignment(
                math.cos(_controller.value * 2 * math.pi + math.pi),
                math.sin(_controller.value * 2 * math.pi + math.pi),
              ),
              colors: widget.colors ??
                  [
                    AppColors.primary,
                    AppColors.primaryDark,
                    AppColors.secondary,
                  ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

// ============================================================================
// GLASSMORPHISM CARD
// ============================================================================

/// Premium glassmorphism card with blur effect
