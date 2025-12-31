import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

/// Status cards showcase page.
class StatusCardsPage extends StatelessWidget {
  const StatusCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Cards'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          _buildSectionTitle(context, 'Basic Status Cards'),

          // Error Card
          SmartErrorCard(
            title: 'Something went wrong',
            message: 'Please try again later',
            action: 'Retry',
            onActionPressed: () => _showSnackBar(context, 'Retry pressed'),
          ),

          // Success Card
          SmartSuccessCard(
            title: 'Success!',
            message: 'Your order has been placed successfully',
            action: 'Continue',
            onActionPressed: () => _showSnackBar(context, 'Continue pressed'),
          ),

          // Warning Card
          SmartWarningCard(
            title: 'Warning',
            message: 'Your session will expire in 5 minutes',
            action: 'Extend Session',
            onActionPressed: () => _showSnackBar(context, 'Extend pressed'),
          ),

          // Info Card
          SmartInfoCard(
            title: 'Did you know?',
            message: 'You can swipe to dismiss notifications',
            action: 'Got it',
            onActionPressed: () => _showSnackBar(context, 'Got it pressed'),
          ),

          // Empty Card
          SmartEmptyCard(
            title: 'No items yet',
            message: 'Add your first item to get started',
            action: 'Add Item',
            onActionPressed: () => _showSnackBar(context, 'Add pressed'),
          ),

          // Loading Card
          const SmartLoadingCard(
            title: 'Loading...',
            message: 'Please wait while we fetch your data',
          ),

          _buildSectionTitle(context, 'With Close Button'),

          // Card with close button
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

          _buildSectionTitle(context, 'Custom Widgets'),

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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '• New features\n• Bug fixes\n• Performance improvements',
                    style: TextStyle(fontSize: 12),
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
                gradient: const LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 32),
            ),
            action: 'Upgrade',
            onActionPressed: () => _showSnackBar(context, 'Upgrade'),
          ),

          _buildSectionTitle(context, 'Pre-configured Cards'),

          // Offline Card
          SmartOfflineCard(
            onActionPressed: () => _showSnackBar(context, 'Retrying...'),
          ),

          // Session Expired Card
          SmartSessionExpiredCard(
            onActionPressed: () => _showSnackBar(context, 'Navigate to login'),
          ),

          // Timeout Card
          SmartTimeoutCard(
            onActionPressed: () => _showSnackBar(context, 'Retrying...'),
          ),

          // Server Error Card
          SmartServerErrorCard(
            onActionPressed: () => _showSnackBar(context, 'Retrying...'),
            onSecondaryActionPressed: () =>
                _showSnackBar(context, 'Contact support'),
          ),

          // Maintenance Card
          const SmartMaintenanceCard(),

          // Permission Denied Card
          SmartPermissionDeniedCard(
            permission: 'Camera',
            onActionPressed: () => _showSnackBar(context, 'Requesting...'),
            onSecondaryActionPressed: () =>
                _showSnackBar(context, 'Open settings'),
          ),

          // Not Found Card
          SmartNotFoundCard(
            itemName: 'Product',
            onActionPressed: () => _showSnackBar(context, 'Go back'),
          ),

          _buildSectionTitle(context, 'From Exception'),

          // Card from exception
          SmartErrorCard.fromException(
            const ConnectionException('Unable to connect to server'),
            action: 'Retry',
            onActionPressed: () => _showSnackBar(context, 'Retrying...'),
            showCloseButton: true,
            onClose: () => _showSnackBar(context, 'Dismissed'),
          ),

          SmartErrorCard.fromException(
            const SessionExpiredException(),
            action: 'Sign In',
            onActionPressed: () => _showSnackBar(context, 'Sign in'),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}
