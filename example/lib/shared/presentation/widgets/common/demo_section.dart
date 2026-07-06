import 'package:flutter/material.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/common/code_preview.dart';

class DemoSection extends StatelessWidget {
  final String title;
  final String? description;
  final Widget child;
  final String? code;

  const DemoSection({
    super.key,
    required this.title,
    this.description,
    required this.child,
    this.code,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 6),
            Text(description!, style: AppTextStyles.bodyMedium),
          ],
          const SizedBox(height: 16),
          child,
          if (code != null) ...[
            const SizedBox(height: 16),
            CodePreview(code: code!, language: 'dart'),
          ],
        ],
      ),
    );
  }
}

/// Premium Gradient header for pages with glassmorphism
