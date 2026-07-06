import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/premium/glass_card.dart';

class PremiumPageHeader extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient? gradient;
  final List<Widget>? actions;
  final Widget? trailing;

  const PremiumPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.gradient,
    this.actions,
    this.trailing,
  });

  @override
  State<PremiumPageHeader> createState() => _PremiumPageHeaderState();
}

class _PremiumPageHeaderState extends State<PremiumPageHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: widget.gradient ?? AppColors.primaryGradient,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Animated particles
          ...List.generate(5, (index) {
            return AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                final offset = (_particleController.value + index * 0.2) % 1.0;
                return Positioned(
                  right: 20 + (index * 30.0),
                  top: 40 + math.sin(offset * 2 * math.pi) * 20,
                  child: Opacity(
                    opacity: 0.1 + (index * 0.05),
                    child: Container(
                      width: 8 + (index * 4.0),
                      height: 8 + (index * 4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
          // Content
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row with back button and trailing widget
                  Row(
                    children: [
                      GlassCard(
                        padding: EdgeInsets.zero,
                        borderRadius: 14,
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                      ),
                      const Spacer(),
                      if (widget.trailing != null) widget.trailing!,
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Icon
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 18,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Title
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFFE0E7FF)],
                    ).createShader(bounds),
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.5,
                    ),
                  ),
                  // Actions
                  if (widget.actions != null && widget.actions!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.actions!,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// LIVE CODE PREVIEW
// ============================================================================

/// Interactive code preview with copy functionality and syntax highlighting appearance
