import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';

// ============================================================================
// ANIMATED GRADIENT BACKGROUND
// ============================================================================

/// Premium animated gradient background with floating particles
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
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final double blur;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 24,
    this.blur = 10,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                padding: padding ?? const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: Border.all(
                    color: borderColor ?? Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// NEUMORPHIC CARD
// ============================================================================

/// Premium neumorphic card with soft shadows
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
class AnimatedExampleCard extends StatefulWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String category;
  final VoidCallback? onTap;
  final bool isNew;

  const AnimatedExampleCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
    this.onTap,
    this.isNew = false,
  });

  @override
  State<AnimatedExampleCard> createState() => _AnimatedExampleCardState();
}

class _AnimatedExampleCardState extends State<AnimatedExampleCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _borderAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _isHovered
                        ? widget.color.withValues(alpha: 0.5)
                        : AppColors.border.withValues(alpha: 0.5),
                    width: _borderAnimation.value,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? widget.color.withValues(alpha: 0.2)
                          : Colors.black.withValues(alpha: 0.05),
                      blurRadius: _isHovered ? 25 : 15,
                      offset: Offset(0, _isHovered ? 10 : 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background gradient
                    Positioned(
                      right: -20,
                      top: -20,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _isHovered ? 0.15 : 0.05,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [widget.color, Colors.transparent],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Icon
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                width: 52,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      widget.color.withValues(alpha: 0.15),
                                      widget.color.withValues(alpha: 0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: widget.color.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Icon(
                                  widget.icon,
                                  color: widget.color,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Category badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.category,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: widget.color,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              if (widget.isNew)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.warmGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    'NEW',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.title,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.description,
                            style: AppTextStyles.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                'Explore',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: widget.color,
                                ),
                              ),
                              const SizedBox(width: 4),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                transform: Matrix4.translationValues(
                                  _isHovered ? 4 : 0,
                                  0,
                                  0,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                  color: widget.color,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// CATEGORY SECTION HEADER
// ============================================================================

/// Premium section header with animated line
class CategoryHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final int count;

  const CategoryHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, top: 10),
      child: Row(
        children: [
          // Icon with gradient background
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, color.withValues(alpha: 0.7)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$count examples',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PREMIUM PAGE HEADER
// ============================================================================

/// Premium page header with animated gradient and particles
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
class LiveCodePreview extends StatefulWidget {
  final String code;
  final String? language;
  final String? title;
  final bool expandable;
  final VoidCallback? onRun;

  const LiveCodePreview({
    super.key,
    required this.code,
    this.language,
    this.title,
    this.expandable = false,
    this.onRun,
  });

  @override
  State<LiveCodePreview> createState() => _LiveCodePreviewState();
}

class _LiveCodePreviewState extends State<LiveCodePreview> {
  bool _isExpanded = false;
  bool _isCopied = false;

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _isCopied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isCopied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.darkGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                // Window dots
                Row(
                  children: [
                    _buildDot(const Color(0xFFFF5F57)),
                    const SizedBox(width: 8),
                    _buildDot(const Color(0xFFFFBD2E)),
                    const SizedBox(width: 8),
                    _buildDot(const Color(0xFF27CA40)),
                  ],
                ),
                const SizedBox(width: 16),
                // Title
                if (widget.title != null)
                  Text(
                    widget.title!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const Spacer(),
                // Language badge
                if (widget.language != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.language!,
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
                // Run button
                if (widget.onRun != null)
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: widget.onRun,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradient,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Run',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                // Copy button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _copyCode,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          _isCopied ? Icons.check_rounded : Icons.copy_rounded,
                          key: ValueKey(_isCopied),
                          size: 16,
                          color: _isCopied
                              ? AppColors.success
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Code content
          AnimatedCrossFade(
            firstChild: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Text(
                  widget.code,
                  style: const TextStyle(
                    fontFamily: 'JetBrains Mono, Fira Code, monospace',
                    fontSize: 13,
                    color: Color(0xFFE2E8F0),
                    height: 1.7,
                  ),
                ),
              ),
            ),
            secondChild: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                widget.code,
                style: const TextStyle(
                  fontFamily: 'JetBrains Mono, Fira Code, monospace',
                  fontSize: 13,
                  color: Color(0xFFE2E8F0),
                  height: 1.7,
                ),
              ),
            ),
            crossFadeState: widget.expandable && !_isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),
          // Expand button
          if (widget.expandable)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: Colors.white54,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isExpanded ? 'Show less' : 'Show more',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// INTERACTIVE DEMO PANEL
// ============================================================================

/// Panel for interactive demo with live preview
class InteractiveDemoPanel extends StatelessWidget {
  final String title;
  final String? description;
  final Widget demo;
  final String? code;
  final List<Widget>? controls;

  const InteractiveDemoPanel({
    super.key,
    required this.title,
    this.description,
    required this.demo,
    this.code,
    this.controls,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    description!,
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          // Demo area
          Container(
            padding: const EdgeInsets.all(24),
            color: AppColors.surfaceVariant.withValues(alpha: 0.3),
            child: demo,
          ),
          // Controls
          if (controls != null && controls!.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                children: controls!,
              ),
            ),
          ],
          // Code
          if (code != null) ...[
            const Divider(height: 1),
            LiveCodePreview(
              code: code!,
              language: 'dart',
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================================================
// STATS CARD
// ============================================================================

/// Premium stats card with animation
class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? change;
  final bool isPositive;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.change,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Spacer(),
              if (change != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (isPositive ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPositive
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: isPositive ? AppColors.success : AppColors.error,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        change!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                              isPositive ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// PULSE ANIMATION
// ============================================================================

/// Widget with pulse animation for drawing attention
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
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                AppColors.surfaceVariant,
                AppColors.surfaceVariant.withValues(alpha: 0.5),
                AppColors.surfaceVariant,
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// GRADIENT BUTTON
// ============================================================================

/// Premium gradient button with animation
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
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
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
