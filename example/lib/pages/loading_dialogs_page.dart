import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

/// Loading dialogs showcase page.
class LoadingDialogsPage extends StatelessWidget {
  const LoadingDialogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Dialogs'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(
            context,
            title: 'Standard Loading Dialog',
            description: 'Shows a circular progress indicator with message',
            child: ElevatedButton.icon(
              onPressed: () => _showLoadingDialog(context),
              icon: const Icon(Icons.hourglass_empty),
              label: const Text('Show Loading Dialog'),
            ),
          ),

          _buildSection(
            context,
            title: 'Progress Dialog',
            description: 'Shows linear progress with percentage',
            child: ElevatedButton.icon(
              onPressed: () => _showProgressDialog(context),
              icon: const Icon(Icons.trending_up),
              label: const Text('Show Progress Dialog'),
            ),
          ),

          _buildSection(
            context,
            title: 'Loading Overlay',
            description: 'Minimal fullscreen overlay',
            child: ElevatedButton.icon(
              onPressed: () => _showLoadingOverlay(context),
              icon: const Icon(Icons.layers),
              label: const Text('Show Loading Overlay'),
            ),
          ),

          _buildSection(
            context,
            title: 'Custom Loading',
            description: 'Loading dialog with custom widget',
            child: ElevatedButton.icon(
              onPressed: () => _showCustomLoading(context),
              icon: const Icon(Icons.brush),
              label: const Text('Show Custom Loading'),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Preview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Inline preview
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: SmartLoadingDialog(message: 'Loading preview...'),
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: SmartProgressDialog(
                progress: 0.65,
                message: 'Uploading file...',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: child),
        ],
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
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.rocket_launch, size: 48, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              const Text(
                'Launching...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
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
