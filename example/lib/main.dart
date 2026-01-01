import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

import 'core/app_theme.dart';
import 'core/widgets.dart';
import 'pages/basic_usage_page.dart';
import 'pages/exception_handling_page.dart';
import 'pages/loading_dialogs_page.dart';
import 'pages/status_cards_page.dart';
// Real-world scenarios with Genius Systems packages
import 'scenarios/user_list_scenario.dart';
import 'scenarios/form_submit_scenario.dart';
import 'scenarios/product_cards_scenario.dart';
import 'scenarios/full_integration_scenario.dart';

void main() {
  // Initialize SmartExecuter configuration
  SmartExecuterConfig.initialize(
    enableLogging: kDebugMode,
    defaultErrorMessage: 'Something went wrong. Please try again.',
    noConnectionMessage: 'No internet connection. Please check your network.',
    sessionExpiredMessage: 'Your session has expired. Please sign in again.',
    sessionExpiredTitle: 'Session Expired',
    maxRetries: 2,
    retryDelay: const Duration(seconds: 1),
    checkConnectionByDefault: false,
    globalErrorHandler: (exception) async {
      debugPrint('Global error: ${exception.message}');
      if (exception.metadata.hasData) {
        debugPrint('Metadata: ${exception.metadata.toMap()}');
      }
    },
  );

  runApp(const SmartExecuterDemo());
}

class SmartExecuterDemo extends StatelessWidget {
  const SmartExecuterDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Executer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomePage(),
    );
  }
}

/// Home page with feature showcase
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Section
          SliverToBoxAdapter(
            child: _buildHeroSection(context),
          ),

          // Features Section
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Features',
                    subtitle: 'Explore what Smart Executer can do',
                  ),
                  _buildFeaturesList(context),
                ],
              ),
            ),
          ),

          // Real-World Scenarios Section
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionHeader(
                    title: 'Real-World Scenarios',
                    subtitle: 'Integration with Genius Systems packages',
                  ),
                  _buildScenariosList(context),
                ],
              ),
            ),
          ),

          // Quick Start Section
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverToBoxAdapter(
              child: _buildQuickStartSection(),
            ),
          ),

          // Package Info
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
            sliver: SliverToBoxAdapter(
              child: _buildPackageInfo(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo & Version
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.bolt,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'v1.3.0',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Smart Executer',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                'A powerful Flutter package for executing async operations with built-in error handling, loading states, and retry mechanisms.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),

              // Chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChip(Icons.security, 'Type-Safe'),
                  _buildChip(Icons.refresh, 'Auto Retry'),
                  _buildChip(Icons.error_outline, 'Error Handling'),
                  _buildChip(Icons.wifi_off, 'Connectivity'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    return Column(
      children: [
        FeatureCard(
          icon: Icons.play_circle_outline,
          iconColor: AppColors.primary,
          title: 'Basic Usage',
          description: 'Execute operations with loading dialogs and result handling',
          onTap: () => _navigateTo(context, const BasicUsagePage()),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          icon: Icons.credit_card,
          iconColor: AppColors.success,
          title: 'Status Cards',
          description: 'Ready-to-use cards for different UI states',
          onTap: () => _navigateTo(context, const StatusCardsPage()),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          icon: Icons.hourglass_empty,
          iconColor: AppColors.warning,
          title: 'Loading Dialogs',
          description: 'Customizable loading indicators and progress dialogs',
          onTap: () => _navigateTo(context, const LoadingDialogsPage()),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          icon: Icons.bug_report_outlined,
          iconColor: AppColors.error,
          title: 'Exception Handling',
          description: 'Comprehensive exception handling with metadata',
          onTap: () => _navigateTo(context, const ExceptionHandlingPage()),
        ),
      ],
    );
  }

  Widget _buildScenariosList(BuildContext context) {
    return Column(
      children: [
        FeatureCard(
          icon: Icons.people,
          iconColor: const Color(0xFF6366F1),
          title: 'User List',
          description: 'SmartPagination + SmartExecuter for paginated lists',
          onTap: () => _navigateTo(context, const UserListScenario()),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          icon: Icons.edit_document,
          iconColor: const Color(0xFFEC4899),
          title: 'Form Submit',
          description: 'SuperDialog + SmartExecuter for form workflows',
          onTap: () => _navigateTo(context, const FormSubmitScenario()),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          icon: Icons.shopping_bag,
          iconColor: const Color(0xFF14B8A6),
          title: 'Product Cards',
          description: 'TooltipCard + SmartExecuter for interactive cards',
          onTap: () => _navigateTo(context, const ProductCardsScenario()),
        ),
        const SizedBox(height: 12),
        FeatureCard(
          icon: Icons.dashboard,
          iconColor: const Color(0xFFF59E0B),
          title: 'Full Integration',
          description: 'Complete dashboard with all packages combined',
          onTap: () => _navigateTo(context, const FullIntegrationScenario()),
        ),
      ],
    );
  }

  Widget _buildQuickStartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Quick Start',
          subtitle: 'Get started in seconds',
        ),
        const CodePreview(
          language: 'dart',
          code: '''// Execute with loading dialog
final response = await SmartExecuter.run(
  request: () => dio.get('/api/data'),
  context: context,
);

// Execute with Result pattern
final result = await SmartExecuter.execute<Response>(
  () => dio.get('/api/data'),
);

result.fold(
  onSuccess: (data) => print('Got: \$data'),
  onFailure: (e) => print('Error: \${e.message}'),
);''',
        ),
      ],
    );
  }

  Widget _buildPackageInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: AppColors.info,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Package Info',
                  style: AppTextStyles.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Package', 'smart_executer'),
            _buildInfoRow('Version', '1.3.0'),
            _buildInfoRow('License', 'MIT'),
            _buildInfoRow('Platform', 'Android, iOS, Web, Desktop'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.labelLarge,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
