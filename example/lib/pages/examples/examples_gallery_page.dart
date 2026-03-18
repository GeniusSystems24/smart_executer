import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/app_theme.dart';
import '../../core/premium_widgets.dart';

/// Data model for example categories
class ExampleCategory {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<ExampleItem> examples;

  const ExampleCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.examples,
  });
}

class ExampleItem {
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final bool isNew;

  const ExampleItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    this.isNew = false,
  });
}

/// All example categories
final List<ExampleCategory> exampleCategories = [
  ExampleCategory(
    title: 'Execution Patterns',
    subtitle: 'Different ways to execute async operations',
    icon: Icons.bolt_rounded,
    color: AppColors.primary,
    examples: [
      ExampleItem(
          title: 'Sequential Execution',
          description: 'Run operations one after another',
          icon: Icons.format_list_numbered_rounded,
          route: '/examples/sequential'),
      ExampleItem(
          title: 'Parallel Execution',
          description: 'Run multiple operations simultaneously',
          icon: Icons.call_split_rounded,
          route: '/examples/parallel'),
      ExampleItem(
          title: 'Debounce & Throttle',
          description: 'Control execution frequency',
          icon: Icons.speed_rounded,
          route: '/examples/debounce-throttle'),
      ExampleItem(
          title: 'Batch Operations',
          description: 'Process items in batches',
          icon: Icons.layers_rounded,
          route: '/examples/batch',
          isNew: true),
      ExampleItem(
          title: 'Cached Results',
          description: 'Cache and reuse results',
          icon: Icons.cached_rounded,
          route: '/examples/cached',
          isNew: true),
    ],
  ),
  ExampleCategory(
    title: 'Retry & Recovery',
    subtitle: 'Handle failures gracefully',
    icon: Icons.refresh_rounded,
    color: AppColors.warning,
    examples: [
      ExampleItem(
          title: 'Auto Retry',
          description: 'Automatically retry failed requests',
          icon: Icons.replay_rounded,
          route: '/examples/auto-retry'),
      ExampleItem(
          title: 'Exponential Backoff',
          description: 'Increasing delay between retries',
          icon: Icons.trending_up_rounded,
          route: '/examples/backoff',
          isNew: true),
      ExampleItem(
          title: 'Fallback Strategies',
          description: 'Use alternative sources on failure',
          icon: Icons.alt_route_rounded,
          route: '/examples/fallback',
          isNew: true),
      ExampleItem(
          title: 'Circuit Breaker',
          description: 'Prevent cascade failures',
          icon: Icons.power_off_rounded,
          route: '/examples/circuit-breaker',
          isNew: true),
    ],
  ),
  ExampleCategory(
    title: 'UI Patterns',
    subtitle: 'Common UI loading patterns',
    icon: Icons.widgets_rounded,
    color: AppColors.accent,
    examples: [
      ExampleItem(
          title: 'Pull to Refresh',
          description: 'Drag down to refresh content',
          icon: Icons.arrow_downward_rounded,
          route: '/examples/pull-refresh'),
      ExampleItem(
          title: 'Optimistic Updates',
          description: 'Update UI before server confirms',
          icon: Icons.flash_on_rounded,
          route: '/examples/optimistic'),
      ExampleItem(
          title: 'Skeleton Loading',
          description: 'Show placeholders while loading',
          icon: Icons.view_stream_rounded,
          route: '/examples/skeleton'),
      ExampleItem(
          title: 'Infinite Scroll',
          description: 'Load more as user scrolls',
          icon: Icons.all_inclusive_rounded,
          route: '/examples/infinite',
          isNew: true),
      ExampleItem(
          title: 'Progress Tracking',
          description: 'Track upload/download progress',
          icon: Icons.hourglass_bottom_rounded,
          route: '/examples/progress',
          isNew: true),
    ],
  ),
  ExampleCategory(
    title: 'Data Management',
    subtitle: 'Handle data operations',
    icon: Icons.storage_rounded,
    color: AppColors.secondary,
    examples: [
      ExampleItem(
          title: 'CRUD Operations',
          description: 'Create, Read, Update, Delete',
          icon: Icons.edit_note_rounded,
          route: '/examples/crud'),
      ExampleItem(
          title: 'Form Validation',
          description: 'Validate and submit forms',
          icon: Icons.fact_check_rounded,
          route: '/examples/form-validation',
          isNew: true),
      ExampleItem(
          title: 'File Upload',
          description: 'Upload files with progress',
          icon: Icons.cloud_upload_rounded,
          route: '/examples/file-upload',
          isNew: true),
      ExampleItem(
          title: 'Data Sync',
          description: 'Sync local and remote data',
          icon: Icons.sync_rounded,
          route: '/examples/data-sync',
          isNew: true),
    ],
  ),
  ExampleCategory(
    title: 'Connectivity',
    subtitle: 'Handle network states',
    icon: Icons.wifi_rounded,
    color: AppColors.info,
    examples: [
      ExampleItem(
          title: 'Offline Mode',
          description: 'Work without internet',
          icon: Icons.wifi_off_rounded,
          route: '/examples/offline'),
      ExampleItem(
          title: 'Network Monitor',
          description: 'Monitor connection changes',
          icon: Icons.network_check_rounded,
          route: '/examples/network-monitor',
          isNew: true),
      ExampleItem(
          title: 'Request Queueing',
          description: 'Queue requests when offline',
          icon: Icons.queue_rounded,
          route: '/examples/queue',
          isNew: true),
    ],
  ),
  ExampleCategory(
    title: 'Error Builders',
    subtitle: 'Customize error display and mapping',
    icon: Icons.build_rounded,
    color: const Color(0xFFE91E63),
    examples: [
      ExampleItem(
          title: 'SnackBar Builder',
          description: 'Per-type SnackBar error builders',
          icon: Icons.notifications_rounded,
          route: '/examples/snackbar-builder'),
      ExampleItem(
          title: 'Dialog Builder',
          description: 'Per-type Dialog error builders',
          icon: Icons.chat_bubble_rounded,
          route: '/examples/dialog-builder'),
      ExampleItem(
          title: 'Scaffold Key',
          description: 'Control SnackBar display target',
          icon: Icons.vpn_key_rounded,
          route: '/examples/scaffold-key',
          isNew: true),
      ExampleItem(
          title: 'Exception Builder',
          description: 'Custom error-to-exception mapping',
          icon: Icons.build_circle_rounded,
          route: '/examples/exception-builder',
          isNew: true),
    ],
  ),
  ExampleCategory(
    title: 'Advanced Patterns',
    subtitle: 'Complex execution patterns',
    icon: Icons.architecture_rounded,
    color: const Color(0xFF8B5CF6),
    examples: [
      ExampleItem(
          title: 'Command Pattern',
          description: 'Encapsulate operations as objects',
          icon: Icons.terminal_rounded,
          route: '/examples/command',
          isNew: true),
      ExampleItem(
          title: 'Undo/Redo',
          description: 'Undo and redo operations',
          icon: Icons.undo_rounded,
          route: '/examples/undo-redo',
          isNew: true),
      ExampleItem(
          title: 'Event Sourcing',
          description: 'Store events instead of state',
          icon: Icons.history_rounded,
          route: '/examples/events',
          isNew: true),
      ExampleItem(
          title: 'Saga Pattern',
          description: 'Manage complex transactions',
          icon: Icons.account_tree_rounded,
          route: '/examples/saga',
          isNew: true),
    ],
  ),
];

/// Examples Gallery Page with modern design
class ExamplesGalleryPage extends StatefulWidget {
  const ExamplesGalleryPage({super.key});

  @override
  State<ExamplesGalleryPage> createState() => _ExamplesGalleryPageState();
}

class _ExamplesGalleryPageState extends State<ExamplesGalleryPage> {
  String _searchQuery = '';
  int? _selectedCategoryIndex;

  List<ExampleCategory> get _filteredCategories {
    if (_searchQuery.isEmpty && _selectedCategoryIndex == null) {
      return exampleCategories;
    }

    return exampleCategories.where((category) {
      if (_selectedCategoryIndex != null) {
        return exampleCategories.indexOf(category) == _selectedCategoryIndex;
      }
      return category.examples.any((e) =>
          e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.description.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();
  }

  int get _totalExamples =>
      exampleCategories.fold(0, (sum, c) => sum + c.examples.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero Header
          SliverToBoxAdapter(child: _buildHeroHeader()),

          // Search & Filter
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: _buildSearchAndFilter(),
            ),
          ),

          // Category Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: _buildCategoryChips(),
            ),
          ),

          // Examples Grid
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = _filteredCategories[index];
                  return _buildCategorySection(category);
                },
                childCount: _filteredCategories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 30,
              offset: const Offset(0, 15))
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                GlassCard(
                  padding: EdgeInsets.zero,
                  borderRadius: 14,
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white),
                      onPressed: () => Navigator.of(context).maybePop()),
                ),
                const Spacer(),
                GlassCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Text('$_totalExamples Examples',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13)),
                ),
              ]),
              const SizedBox(height: 24),
              GlassCard(
                  padding: const EdgeInsets.all(14),
                  borderRadius: 18,
                  child: const Icon(Icons.code_rounded,
                      color: Colors.white, size: 28)),
              const SizedBox(height: 20),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.white, Color(0xFFE0E7FF)])
                    .createShader(bounds),
                child: const Text('Examples Gallery',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -1)),
              ),
              const SizedBox(height: 10),
              Text(
                  'Explore ${exampleCategories.length} categories of smart execution patterns',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.9))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return TextField(
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: 'Search examples...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => setState(() => _searchQuery = ''))
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide:
                BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        _buildChip('All', null),
        ...exampleCategories
            .asMap()
            .entries
            .map((e) => _buildChip(e.value.title, e.key)),
      ]),
    );
  }

  Widget _buildChip(String label, int? index) {
    final isSelected = _selectedCategoryIndex == index;
    final color =
        index != null ? exampleCategories[index].color : AppColors.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) =>
            setState(() => _selectedCategoryIndex = isSelected ? null : index),
        selectedColor: color.withValues(alpha: 0.2),
        checkmarkColor: color,
        labelStyle: TextStyle(
            color: isSelected ? color : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
      ),
    );
  }

  Widget _buildCategorySection(ExampleCategory category) {
    final filteredExamples = _searchQuery.isEmpty
        ? category.examples
        : category.examples
            .where((e) =>
                e.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                e.description
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()))
            .toList();

    if (filteredExamples.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryHeader(
            title: category.title,
            subtitle: category.subtitle,
            icon: category.icon,
            color: category.color,
            count: filteredExamples.length),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85),
          itemCount: filteredExamples.length,
          itemBuilder: (_, i) {
            final example = filteredExamples[i];
            return AnimatedExampleCard(
              title: example.title,
              description: example.description,
              icon: example.icon,
              color: category.color,
              category: category.title,
              isNew: example.isNew,
              onTap: () => _navigateToExample(example.route),
            );
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  void _navigateToExample(String route) {
    // Navigate using go_router
    context.go(route);
  }
}
