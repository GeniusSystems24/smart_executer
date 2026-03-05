import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'core/app_router.dart';
import 'core/app_theme.dart';

/// Completely redesigned Home Page with premium examples showcase
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _heroController;
  late Animation<double> _heroAnimation;
  int _selectedCategoryIndex = 0;

  final List<_ExampleCategory> _categories = [
    _ExampleCategory(
      name: 'All',
      icon: Icons.apps_rounded,
      color: AppColors.primary,
    ),
    _ExampleCategory(
      name: 'Core',
      icon: Icons.flash_on_rounded,
      color: AppColors.primary,
    ),
    _ExampleCategory(
      name: 'Execution',
      icon: Icons.bolt_rounded,
      color: const Color(0xFF6366F1),
    ),
    _ExampleCategory(
      name: 'UI Patterns',
      icon: Icons.widgets_rounded,
      color: AppColors.accent,
    ),
    _ExampleCategory(
      name: 'Data',
      icon: Icons.storage_rounded,
      color: AppColors.secondary,
    ),
    _ExampleCategory(
      name: 'Scenarios',
      icon: Icons.dashboard_rounded,
      color: AppColors.warning,
    ),
  ];

  List<_ExampleItem> get _allExamples => [
        // Core Features
        _ExampleItem(
          title: 'Basic Usage',
          description:
              'Execute operations with loading dialogs and result handling',
          icon: Icons.play_circle_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
          category: 'Core',
          onTap: () => context.goToBasicUsage(),
        ),
        _ExampleItem(
          title: 'Status Cards',
          description: 'Ready-to-use cards for different UI states',
          icon: Icons.credit_card_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
          category: 'Core',
          onTap: () => context.goToStatusCards(),
        ),
        _ExampleItem(
          title: 'Loading Dialogs',
          description: 'Customizable loading indicators and progress dialogs',
          icon: Icons.hourglass_empty_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFFF093FB), Color(0xFFF5576C)]),
          category: 'Core',
          onTap: () => context.goToLoadingDialogs(),
        ),
        _ExampleItem(
          title: 'Exception Handling',
          description: 'Comprehensive exception handling with metadata',
          icon: Icons.bug_report_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)]),
          category: 'Core',
          onTap: () => context.goToExceptionHandling(),
        ),
        // Execution Patterns
        _ExampleItem(
          title: 'Sequential Execution',
          description: 'Run operations one after another in order',
          icon: Icons.format_list_numbered_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFF4776E6), Color(0xFF8E54E9)]),
          category: 'Execution',
          isNew: true,
          onTap: () => context.goToSequentialExecution(),
        ),
        _ExampleItem(
          title: 'Parallel Execution',
          description: 'Run multiple operations simultaneously',
          icon: Icons.call_split_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFF00B4DB), Color(0xFF0083B0)]),
          category: 'Execution',
          isNew: true,
          onTap: () => context.goToParallelExecution(),
        ),
        _ExampleItem(
          title: 'Debounce & Throttle',
          description: 'Control execution frequency of operations',
          icon: Icons.speed_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFFE65C00), Color(0xFFF9D423)]),
          category: 'Execution',
          isNew: true,
          onTap: () => context.goToDebounceThrottle(),
        ),
        _ExampleItem(
          title: 'Auto Retry',
          description: 'Automatically retry failed requests',
          icon: Icons.replay_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFFFC466B), Color(0xFF3F5EFB)]),
          category: 'Execution',
          isNew: true,
          onTap: () => context.goToAutoRetry(),
        ),
        // UI Patterns
        _ExampleItem(
          title: 'Pull to Refresh',
          description: 'Drag down to refresh content',
          icon: Icons.arrow_downward_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)]),
          category: 'UI Patterns',
          isNew: true,
          onTap: () => context.goToPullToRefresh(),
        ),
        _ExampleItem(
          title: 'Optimistic Updates',
          description: 'Update UI before server confirms',
          icon: Icons.flash_on_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFFFDC830), Color(0xFFF37335)]),
          category: 'UI Patterns',
          isNew: true,
          onTap: () => context.goToOptimisticUpdate(),
        ),
        _ExampleItem(
          title: 'Skeleton Loading',
          description: 'Show placeholders while loading data',
          icon: Icons.view_stream_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFF834D9B), Color(0xFFD04ED6)]),
          category: 'UI Patterns',
          isNew: true,
          onTap: () => context.goToSkeletonLoading(),
        ),
        // Error Builders
        _ExampleItem(
          title: 'SnackBar Builder',
          description: 'Custom per-type SnackBar error builders',
          icon: Icons.notifications_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)]),
          category: 'UI Patterns',
          isNew: true,
          onTap: () => context.goToSnackBarErrorBuilder(),
        ),
        _ExampleItem(
          title: 'Dialog Builder',
          description: 'Custom per-type Dialog error builders',
          icon: Icons.picture_in_picture_alt_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFFE91E63), Color(0xFF9C27B0)]),
          category: 'UI Patterns',
          isNew: true,
          onTap: () => context.goToDialogErrorBuilder(),
        ),
        // Data Management
        _ExampleItem(
          title: 'CRUD Operations',
          description: 'Create, Read, Update, Delete patterns',
          icon: Icons.edit_note_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFF1D976C), Color(0xFF93F9B9)]),
          category: 'Data',
          isNew: true,
          onTap: () => context.goToCrudOperations(),
        ),
        _ExampleItem(
          title: 'Offline Mode',
          description: 'Work without internet connection',
          icon: Icons.wifi_off_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFF536976), Color(0xFF292E49)]),
          category: 'Data',
          isNew: true,
          onTap: () => context.goToOfflineMode(),
        ),
        // Real-World Scenarios
        _ExampleItem(
          title: 'User List',
          description: 'SmartPagination + SmartExecuter for paginated lists',
          icon: Icons.people_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
          category: 'Scenarios',
          onTap: () => context.goToUserList(),
        ),
        _ExampleItem(
          title: 'Form Submit',
          description: 'SuperDialog + SmartExecuter for form workflows',
          icon: Icons.edit_document,
          gradient: const LinearGradient(
              colors: [Color(0xFFEC4899), Color(0xFFF43F5E)]),
          category: 'Scenarios',
          onTap: () => context.goToFormSubmit(),
        ),
        _ExampleItem(
          title: 'Product Cards',
          description: 'TooltipCard + SmartExecuter for interactive cards',
          icon: Icons.shopping_bag_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFF14B8A6), Color(0xFF06B6D4)]),
          category: 'Scenarios',
          onTap: () => context.goToProductCards(),
        ),
        _ExampleItem(
          title: 'Full Integration',
          description: 'Complete dashboard with all packages combined',
          icon: Icons.dashboard_rounded,
          gradient: const LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFEF4444)]),
          category: 'Scenarios',
          onTap: () => context.goToFullIntegration(),
        ),
      ];

  List<_ExampleItem> get _filteredExamples {
    if (_selectedCategoryIndex == 0) return _allExamples;
    final category = _categories[_selectedCategoryIndex].name;
    return _allExamples.where((e) => e.category == category).toList();
  }

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _heroAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _heroController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Animated Hero Header
          SliverToBoxAdapter(child: _buildAnimatedHero()),

          // Stats Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: _buildStatsRow(),
            ),
          ),

          // Category Chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: _buildCategoryChips(),
            ),
          ),

          // Examples Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _ExampleCard(example: _filteredExamples[index]),
                childCount: _filteredExamples.length,
              ),
            ),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildAnimatedHero() {
    return AnimatedBuilder(
      animation: _heroAnimation,
      builder: (context, child) {
        return Container(
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(const Color(0xFF667EEA), const Color(0xFF764BA2),
                    _heroAnimation.value)!,
                Color.lerp(const Color(0xFF764BA2), const Color(0xFF667EEA),
                    _heroAnimation.value)!,
              ],
            ),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withValues(alpha: 0.4),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Floating particles
              ...List.generate(8, (i) => _buildFloatingParticle(i)),
              // Content
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildGlassIcon(Icons.bolt_rounded),
                          const Spacer(),
                          _buildVersionBadge(),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, Color(0xFFE0E7FF)],
                        ).createShader(bounds),
                        child: const Text(
                          'Smart Executer',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Execute async operations with built-in error handling, loading states, and retry mechanisms',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = math.Random(index);
    final size = 6.0 + random.nextDouble() * 12;
    final left = random.nextDouble() * 300;
    final top = 50 + random.nextDouble() * 150;

    return AnimatedBuilder(
      animation: _heroAnimation,
      builder: (context, child) {
        return Positioned(
          left:
              left + math.sin(_heroAnimation.value * math.pi * 2 + index) * 20,
          top: top + math.cos(_heroAnimation.value * math.pi * 2 + index) * 15,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.1 + random.nextDouble() * 0.15),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassIcon(IconData icon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
      ),
    );
  }

  Widget _buildVersionBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: AppColors.success.withValues(alpha: 0.5),
                    blurRadius: 6)
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Text('v1.3.0',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final newCount = _allExamples.where((e) => e.isNew).length;
    return Row(
      children: [
        Expanded(
            child: _StatCard(
          icon: Icons.code_rounded,
          value: '${_allExamples.length}',
          label: 'Examples',
          color: AppColors.primary,
        )),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(
          icon: Icons.star_rounded,
          value: '$newCount',
          label: 'New',
          color: AppColors.warning,
        )),
        const SizedBox(width: 12),
        Expanded(
            child: _StatCard(
          icon: Icons.category_rounded,
          value: '${_categories.length - 1}',
          label: 'Categories',
          color: AppColors.accent,
        )),
      ],
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategoryIndex == index;
          return Padding(
            padding:
                EdgeInsets.only(right: index < _categories.length - 1 ? 10 : 0),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategoryIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(colors: [
                          category.color,
                          category.color.withValues(alpha: 0.8)
                        ])
                      : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppColors.border.withValues(alpha: 0.5),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: category.color.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      category.icon,
                      size: 18,
                      color:
                          isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// Data Models
// ============================================================================

class _ExampleCategory {
  final String name;
  final IconData icon;
  final Color color;
  const _ExampleCategory(
      {required this.name, required this.icon, required this.color});
}

class _ExampleItem {
  final String title;
  final String description;
  final IconData icon;
  final LinearGradient gradient;
  final String category;
  final bool isNew;
  final VoidCallback? onTap;

  const _ExampleItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.category,
    this.isNew = false,
    this.onTap,
  });
}

// ============================================================================
// Widgets
// ============================================================================

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatefulWidget {
  final _ExampleItem example;
  const _ExampleCard({required this.example});

  @override
  State<_ExampleCard> createState() => _ExampleCardState();
}

class _ExampleCardState extends State<_ExampleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.example.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.03 : 1.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered
                  ? widget.example.gradient.colors.first.withValues(alpha: 0.5)
                  : AppColors.border.withValues(alpha: 0.5),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? widget.example.gradient.colors.first
                        .withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _isHovered ? 25 : 15,
                offset: Offset(0, _isHovered ? 12 : 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background gradient circle
              Positioned(
                right: -30,
                top: -30,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isHovered ? 0.2 : 0.1,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.example.gradient.colors.first,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Icon with gradient
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: widget.example.gradient,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: widget.example.gradient.colors.first
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.example.icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const Spacer(),
                        if (widget.example.isNew)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.example.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        widget.example.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Explore',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: widget.example.gradient.colors.first,
                          ),
                        ),
                        const SizedBox(width: 4),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.translationValues(
                              _isHovered ? 4 : 0, 0, 0),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: widget.example.gradient.colors.first,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
