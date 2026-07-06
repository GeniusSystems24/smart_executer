import 'package:flutter/material.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';

class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Color? color;
  final bool enabled;

  const PulseAnimation({
    super.key,
    required this.child,
    this.color,
    this.enabled = true,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(PulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.enabled && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (widget.color ?? AppColors.primary).withValues(
                      alpha: 0.3 * (1 - (_animation.value - 1) / 0.5)),
                ),
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

// ============================================================================
// SHIMMER LOADING
// ============================================================================

/// Premium shimmer loading effect
