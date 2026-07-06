import 'package:flutter/material.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';

class GradientButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final LinearGradient? gradient;
  final bool isLoading;
  final bool isSmall;

  const GradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.gradient,
    this.isLoading = false,
    this.isSmall = false,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: Matrix4.diagonal3Values(
          _isPressed ? 0.97 : 1.0,
          _isPressed ? 0.97 : 1.0,
          1.0,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isSmall ? 16 : 24,
          vertical: widget.isSmall ? 12 : 16,
        ),
        decoration: BoxDecoration(
          gradient: widget.onPressed != null
              ? (widget.gradient ?? AppColors.primaryGradient)
              : LinearGradient(
                  colors: [Colors.grey.shade400, Colors.grey.shade500],
                ),
          borderRadius: BorderRadius.circular(widget.isSmall ? 12 : 16),
          boxShadow: widget.onPressed != null && !_isPressed
              ? [
                  BoxShadow(
                    color: (widget.gradient?.colors.first ?? AppColors.primary)
                        .withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.isLoading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else if (widget.icon != null)
              Icon(
                widget.icon,
                color: Colors.white,
                size: widget.isSmall ? 18 : 20,
              ),
            if (widget.icon != null || widget.isLoading)
              SizedBox(width: widget.isSmall ? 8 : 10),
            Text(
              widget.label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: widget.isSmall ? 14 : 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
