import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

import '../core/app_theme.dart';
import '../core/widgets.dart';

/// Loading dialogs showcase page.
class LoadingDialogsPage extends StatelessWidget {
  const LoadingDialogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: GradientHeader(
              title: 'Loading Dialogs',
              subtitle: 'Customizable loading indicators and progress dialogs',
              icon: Icons.hourglass_empty,
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Standard Loading Dialog
                DemoSection(
                  title: 'Standard Loading Dialog',
                  description: 'Circular progress indicator with message',
                  child: DemoButton(
                    label: 'Show Loading Dialog',
                    icon: Icons.hourglass_empty,
                    onPressed: () => _showLoadingDialog(context),
                  ),
                  code: '''showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => const SmartLoadingDialog(
    message: 'Please wait...',
  ),
);''',
                ),

                // Progress Dialog
                DemoSection(
                  title: 'Progress Dialog',
                  description: 'Linear progress with percentage indicator',
                  child: DemoButton(
                    label: 'Show Progress Dialog',
                    icon: Icons.trending_up,
                    color: AppColors.success,
                    onPressed: () => _showProgressDialog(context),
                  ),
                  code: '''SmartProgressDialog(
  progress: 0.65,
  message: 'Uploading... 65%',
);''',
                ),

                // Loading Overlay
                DemoSection(
                  title: 'Loading Overlay',
                  description: 'Minimal fullscreen overlay (tap to dismiss)',
                  child: DemoButton(
                    label: 'Show Loading Overlay',
                    icon: Icons.layers,
                    color: AppColors.warning,
                    onPressed: () => _showLoadingOverlay(context),
                  ),
                  code: '''showDialog(
  context: context,
  barrierDismissible: true,
  barrierColor: Colors.black54,
  builder: (_) => const SmartLoadingOverlay(),
);''',
                ),

                // Custom Loading
                DemoSection(
                  title: 'Custom Loading',
                  description: 'Create your own custom loading dialog',
                  child: DemoButton(
                    label: 'Show Custom Loading',
                    icon: Icons.brush,
                    color: AppColors.accent,
                    onPressed: () => _showCustomLoading(context),
                  ),
                ),

                const SizedBox(height: 8),

                // Preview Section
                const SectionHeader(
                  title: 'Preview',
                  subtitle: 'Inline preview of loading components',
                ),

                // Loading Dialog Preview
                _buildPreviewCard(
                  context,
                  'Loading Dialog',
                  const SmartLoadingDialog(message: 'Loading preview...'),
                ),
                const SizedBox(height: 16),

                // Progress Dialog Preview
                _buildPreviewCard(
                  context,
                  'Progress Dialog',
                  const SmartProgressDialog(
                    progress: 0.65,
                    message: 'Uploading file... 65%',
                  ),
                ),

                const SizedBox(height: 24),

                // Custom Loading Card
                const SectionHeader(
                  title: 'Smart Loading Card',
                  subtitle: 'For inline loading states',
                ),

                const SmartLoadingCard(
                  title: 'Loading Data',
                  message: 'Please wait while we fetch your information',
                ),

                const SizedBox(height: 12),

                SmartLoadingCard(
                  titleWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cloud_download, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Syncing...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  message: 'Downloading latest updates',
                  indicatorWidget: SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard(BuildContext context, String title, Widget child) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Center(child: child),
          ],
        ),
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SmartLoadingDialog(message: 'Please wait...'),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  void _showProgressDialog(BuildContext context) {
    double progress = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Simulate progress
            if (progress < 1.0) {
              Future.delayed(const Duration(milliseconds: 100), () {
                if (progress < 1.0) {
                  setDialogState(() => progress += 0.05);
                } else {
                  Navigator.of(dialogContext).pop();
                }
              });
            } else {
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.of(dialogContext).pop();
              });
            }

            return SmartProgressDialog(
              progress: progress,
              message: 'Uploading... ${(progress * 100).toInt()}%',
            );
          },
        );
      },
    );
  }

  void _showLoadingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (_) => const SmartLoadingOverlay(),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  void _showCustomLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.rocket_launch,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Launching...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Preparing your experience',
                style: TextStyle(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  minHeight: 6,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }
}
