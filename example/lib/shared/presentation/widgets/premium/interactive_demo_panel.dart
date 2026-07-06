import 'package:flutter/material.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/premium/live_code_preview.dart';

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
