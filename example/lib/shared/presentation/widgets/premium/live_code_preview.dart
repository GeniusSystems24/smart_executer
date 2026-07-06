import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';

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
