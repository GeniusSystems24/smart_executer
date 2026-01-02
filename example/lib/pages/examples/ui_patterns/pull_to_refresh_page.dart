import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import '../../../core/app_theme.dart';
import '../../../core/premium_widgets.dart';

class PullToRefreshPage extends StatefulWidget {
  const PullToRefreshPage({super.key});
  @override
  State<PullToRefreshPage> createState() => _PullToRefreshPageState();
}

class _PullToRefreshPageState extends State<PullToRefreshPage> {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;
  String? _error;
  DateTime? _lastRefresh;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await SmartExecuter.execute<Response>(
      () => _dio.get('/posts?_limit=15'),
    );

    result.fold(
      onSuccess: (data) {
        _posts = List<Map<String, dynamic>>.from(data.data);
        _lastRefresh = DateTime.now();
      },
      onFailure: (e) => _error = e.message,
    );

    setState(() => _isLoading = false);
  }

  Future<void> _onRefresh() async {
    await _loadData();
    if (mounted) {
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
  final Map<String, dynamic> post;
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
                Text(post['title'] ?? '',
                    style: AppTextStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text(post['body'] ?? '',
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
