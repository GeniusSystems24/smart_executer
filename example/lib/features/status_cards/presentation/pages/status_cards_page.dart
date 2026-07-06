import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/common_widgets.dart';

/// Status cards showcase page.
class StatusCardsPage extends StatelessWidget {
  const StatusCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: GradientHeader(
              title: 'Status Cards',
              subtitle: 'Ready-to-use cards for different UI states',
              icon: Icons.credit_card,
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Basic Status Cards
                const SectionHeader(
                  title: 'Basic Status Cards',
                  subtitle: 'Common states for your UI',
                ),

                SmartErrorCard(
                  title: 'Something went wrong',
                  message: 'Please try again later',
                  action: 'Retry',
                  onActionPressed: () => _showSnackBar(context, 'Retry pressed'),
                ),

                SmartSuccessCard(
                  title: 'Success!',
                  message: 'Your order has been placed successfully',
                  action: 'Continue',
                  onActionPressed: () => _showSnackBar(context, 'Continue pressed'),
                ),

                SmartWarningCard(
                  title: 'Warning',
                  message: 'Your session will expire in 5 minutes',
                  action: 'Extend Session',
                  onActionPressed: () => _showSnackBar(context, 'Extend pressed'),
                ),

                SmartInfoCard(
                  title: 'Did you know?',
                  message: 'You can swipe to dismiss notifications',
                  action: 'Got it',
                  onActionPressed: () => _showSnackBar(context, 'Got it pressed'),
                ),

                SmartEmptyCard(
                  title: 'No items yet',
                  message: 'Add your first item to get started',
                  action: 'Add Item',
                  onActionPressed: () => _showSnackBar(context, 'Add pressed'),
                ),

                const SmartLoadingCard(
                  title: 'Loading...',
                  message: 'Please wait while we fetch your data',
                ),

                const SizedBox(height: 24),

                // With Close Button
                const SectionHeader(
                  title: 'With Close Button',
                  subtitle: 'Dismissible cards with close action',
                ),

                SmartInfoCard(
                  title: 'Dismissible Card',
                  message: 'This card has a close button',
                  showCloseButton: true,
                  onClose: () => _showSnackBar(context, 'Close pressed'),
                  action: 'OK',
                  onActionPressed: () => _showSnackBar(context, 'OK pressed'),
                ),

                SmartWarningCard(
                  title: 'Session Notice',
                  message: 'Your session will expire soon',
                  showCloseButton: true,
                  onClose: () => _showSnackBar(context, 'Dismissed'),
                ),

                const SizedBox(height: 24),

                // Custom Widgets
                const SectionHeader(
                  title: 'Custom Widgets',
                  subtitle: 'Full customization with custom widgets',
                ),

                // Custom title widget
                SmartSuccessCard(
                  titleWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified, color: Color(0xFF28A745)),
                      const SizedBox(width: 8),
                      Text(
                        'Verified!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF28A745),
                            ),
                      ),
                    ],
                  ),
                  message: 'Your account has been verified',
                ),

                // Custom body widget
                SmartInfoCard(
                  title: 'Update Available',
                  bodyWidget: Column(
                    children: [
                      const Text('Version 2.0.0 is now available'),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '• New features\n• Bug fixes\n• Performance improvements',
                          style: TextStyle(fontSize: 13, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                  action: 'Update Now',
                  onActionPressed: () => _showSnackBar(context, 'Updating...'),
                ),

                // Custom actions widget
                SmartErrorCard(
                  title: 'Connection Failed',
                  message: 'Unable to connect to server',
                  showCloseButton: true,
                  onClose: () => _showSnackBar(context, 'Dismissed'),
                  actionsWidget: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _showSnackBar(context, 'Retrying...'),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry Connection'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showSnackBar(context, 'Offline mode'),
                          icon: const Icon(Icons.offline_bolt),
                          label: const Text('Work Offline'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _showSnackBar(context, 'Help'),
                        child: const Text('Need help?'),
                      ),
                    ],
                  ),
                ),

                // Custom icon widget
                SmartInfoCard(
                  title: 'Premium Feature',
                  message: 'Upgrade to unlock this feature',
                  iconWidget: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.star, color: Colors.white, size: 32),
                  ),
                  action: 'Upgrade',
                  onActionPressed: () => _showSnackBar(context, 'Upgrade'),
                ),

                const SizedBox(height: 24),

                // Pre-configured Cards
                const SectionHeader(
                  title: 'Pre-configured Cards',
                  subtitle: 'Common error states ready to use',
                ),

                SmartOfflineCard(
                  onActionPressed: () => _showSnackBar(context, 'Retrying...'),
                ),

                SmartSessionExpiredCard(
                  onActionPressed: () => _showSnackBar(context, 'Navigate to login'),
                ),

                SmartTimeoutCard(
                  onActionPressed: () => _showSnackBar(context, 'Retrying...'),
                ),

                SmartServerErrorCard(
                  onActionPressed: () => _showSnackBar(context, 'Retrying...'),
                  onSecondaryActionPressed: () =>
                      _showSnackBar(context, 'Contact support'),
                ),

                const SmartMaintenanceCard(),

                SmartPermissionDeniedCard(
                  permission: 'Camera',
                  onActionPressed: () => _showSnackBar(context, 'Requesting...'),
                  onSecondaryActionPressed: () =>
                      _showSnackBar(context, 'Open settings'),
                ),

                SmartNotFoundCard(
                  itemName: 'Product',
                  onActionPressed: () => _showSnackBar(context, 'Go back'),
                ),

                const SizedBox(height: 24),

                // From Exception
                const SectionHeader(
                  title: 'From Exception',
                  subtitle: 'Create cards from SmartException',
                ),

                SmartErrorCard.fromException(
                  const ConnectionException('Unable to connect to server'),
                  action: 'Retry',
                  onActionPressed: () => _showSnackBar(context, 'Retrying...'),
                  showCloseButton: true,
                  onClose: () => _showSnackBar(context, 'Dismissed'),
                ),

                const SizedBox(height: 8),

                const CodePreview(
                  language: 'dart',
                  code: '''SmartErrorCard.fromException(
  const ConnectionException('Unable to connect'),
  action: 'Retry',
  onActionPressed: () => retry(),
  showCloseButton: true,
);''',
                ),

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
