import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/app/app_dependencies.dart';
import 'package:smart_executer_example/features/examples/ui_patterns/pull_to_refresh/domain/entities/demo_post.dart';
import 'package:smart_executer_example/features/examples/ui_patterns/pull_to_refresh/presentation/controllers/pull_to_refresh_controller.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/premium_widgets.dart';

class PullToRefreshPage extends StatefulWidget {
  const PullToRefreshPage({super.key});
  @override
  State<PullToRefreshPage> createState() => _PullToRefreshPageState();
}

class _PullToRefreshPageState extends State<PullToRefreshPage> {
  late final PullToRefreshController _controller;

  List<DemoPost> get _posts => _controller.posts;
  bool get _isLoading => _controller.isLoading;
  String? get _error => _controller.error;
  DateTime? get _lastRefresh => _controller.lastRefresh;

  @override
  void initState() {
    super.initState();
    _controller = PullToRefreshController(
      client: AppDependencies.createHttpClient(),
    )..addListener(_refreshView);
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

  Future<void> _loadData() async {
    await _controller.load();
  }

  Future<void> _onRefresh() async {
    final succeeded = await _controller.load();
    if (mounted && succeeded) {
      SmartSnackBars.showSuccess(context, 'Data refreshed successfully!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(
            child: PremiumPageHeader(
              title: 'Pull to Refresh',
              subtitle: 'Drag down to refresh content',
              icon: Icons.arrow_downward_rounded,
              gradient: AppColors.accentGradient,
              trailing: _lastRefresh != null
                  ? GlassCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: Text('Last: ${_formatTime(_lastRefresh!)}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                    )
                  : null,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverToBoxAdapter(
              child: _buildInfo(),
            ),
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: SmartErrorCard(
                  title: 'Failed to load',
                  message: _error!,
                  action: 'Retry',
                  onActionPressed: _loadData,
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    if (index == 0) {
                      return RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: const SizedBox(height: 0),
                      );
                    }
                    final post = _posts[index - 1];
                    return _PostCard(post: post, index: index);
                  },
                  childCount: _posts.length + 1,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onRefresh,
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        Icon(Icons.touch_app_rounded, color: AppColors.info),
        const SizedBox(width: 12),
        const Expanded(
          child: Text('Pull down anywhere on the list to refresh the data',
              style: TextStyle(fontSize: 13, color: AppColors.info)),
        ),
      ]),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }
}

class _PostCard extends StatelessWidget {
  final DemoPost post;
  final int index;
  const _PostCard({required this.post, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
                child: Text('$index',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(post.title,
                    style: AppTextStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(post.body,
                    style: AppTextStyles.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
