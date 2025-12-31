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
