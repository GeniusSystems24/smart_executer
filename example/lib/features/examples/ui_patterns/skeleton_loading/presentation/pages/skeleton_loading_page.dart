import 'package:flutter/material.dart';
import 'package:smart_executer_example/features/examples/ui_patterns/skeleton_loading/domain/entities/skeleton_item.dart';
import 'package:smart_executer_example/features/examples/ui_patterns/skeleton_loading/presentation/controllers/skeleton_loading_controller.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/premium_widgets.dart';

class SkeletonLoadingPage extends StatefulWidget {
  const SkeletonLoadingPage({super.key});
  @override
  State<SkeletonLoadingPage> createState() => _SkeletonLoadingPageState();
}

class _SkeletonLoadingPageState extends State<SkeletonLoadingPage> {
  late final SkeletonLoadingController _controller;

  bool get _isLoading => _controller.isLoading;
  List<SkeletonItem> get _items => _controller.items;

  @override
  void initState() {
    super.initState();
    _controller = SkeletonLoadingController()..addListener(_refreshView);
    _controller.load();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_refreshView)
      ..dispose();
    super.dispose();
  }

  void _refreshView() {
    if (mounted) setState(() {});
  }

  Future<void> _loadData() => _controller.load();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PremiumPageHeader(
              title: 'Skeleton Loading',
              subtitle: 'Show placeholder content while loading',
              icon: Icons.view_stream_rounded,
              gradient: AppColors.coolGradient,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(children: [
                  Text(
                    _isLoading ? 'Loading...' : '${_items.length} items loaded',
                    style: AppTextStyles.titleMedium,
                  ),
                  const Spacer(),
                  IconButton(
                      icon: const Icon(Icons.refresh), onPressed: _loadData),
                ]),
                const SizedBox(height: 20),
                // Cards skeleton
                if (_isLoading) ...[
                  _buildSkeletonStats(),
                  const SizedBox(height: 20),
                  ...List.generate(5, (_) => _buildSkeletonCard()),
                ] else ...[
                  _buildRealStats(),
                  const SizedBox(height: 20),
                  ..._items.map((item) => _buildRealCard(item)),
                ],
                const SizedBox(height: 24),
                LiveCodePreview(
                  title: 'Skeleton Widget',
                  language: 'dart',
                  code: '''// Shimmer loading effect
class ShimmerLoading extends StatefulWidget {
  final double width, height;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(_animation.value - 1, 0),
            end: Alignment(_animation.value + 1, 0),
            colors: [grey, grey.lighter, grey],
          ),
        ),
      ),
    );
  }
}''',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonStats() {
    return Row(
      children: List.generate(
          3,
          (index) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: index < 2 ? 12 : 0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(children: [
                    ShimmerLoading(width: 40, height: 40, borderRadius: 10),
                    const SizedBox(height: 12),
                    ShimmerLoading(width: 60, height: 20, borderRadius: 6),
                    const SizedBox(height: 6),
                    ShimmerLoading(width: 40, height: 14, borderRadius: 4),
                  ]),
                ),
              )),
    );
  }

  Widget _buildRealStats() {
    return Row(
      children: [
        _StatCard('Total', '${_items.length}', Icons.list, AppColors.primary),
        const SizedBox(width: 12),
        _StatCard('Sum', '${_items.fold<int>(0, (sum, i) => sum + i.value)}',
            Icons.calculate, AppColors.accent),
        const SizedBox(width: 12),
        _StatCard(
            'Avg',
            '${(_items.fold<int>(0, (sum, i) => sum + i.value) / _items.length).round()}',
            Icons.analytics,
            AppColors.secondary),
      ].map((w) => Expanded(child: w)).toList(),
    );
  }

  Widget _buildSkeletonCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: [
        ShimmerLoading(width: 50, height: 50, borderRadius: 25),
        const SizedBox(width: 14),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ShimmerLoading(width: double.infinity, height: 16, borderRadius: 4),
            const SizedBox(height: 8),
            ShimmerLoading(width: 150, height: 12, borderRadius: 4),
          ]),
        ),
        const SizedBox(width: 10),
        ShimmerLoading(width: 50, height: 24, borderRadius: 12),
      ]),
    );
  }

  Widget _buildRealCard(SkeletonItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(children: [
        CircleAvatar(radius: 25, backgroundImage: NetworkImage(item.avatar)),
        const SizedBox(width: 14),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.title, style: AppTextStyles.titleMedium),
            const SizedBox(height: 4),
            Text(item.subtitle,
                style: AppTextStyles.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('\$${item.value}',
              style: TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.w600)),
        ),
      ]),
    );
  }
}


class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  const _StatCard(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 10),
        Text(value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ]),
    );
  }
}
