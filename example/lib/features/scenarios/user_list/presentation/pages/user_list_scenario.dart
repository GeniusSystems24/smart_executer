import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/app/app_dependencies.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/features/scenarios/user_list/domain/entities/demo_user.dart';
import 'package:smart_executer_example/features/scenarios/user_list/presentation/controllers/user_list_controller.dart';
import 'package:smart_executer_example/shared/presentation/widgets/common_widgets.dart';
import 'package:smart_pagination/pagination.dart';

/// Paginated user list demonstrating SmartPagination with SmartExecuter.
class UserListScenario extends StatefulWidget {
  const UserListScenario({super.key});

  @override
  State<UserListScenario> createState() => _UserListScenarioState();
}

class _UserListScenarioState extends State<UserListScenario> {
  late final UserListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = UserListController(
      client: AppDependencies.createHttpClient(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _deleteUser(DemoUser user) async {
    final succeeded = await _controller.deleteUser(context, user);
    if (!mounted || !succeeded) return;
    SmartSnackBars.showSuccess(
      context,
      '${user.name} deleted successfully',
    );
  }

  Future<void> _refreshUser(DemoUser user) async {
    final succeeded = await _controller.refreshUser(context, user);
    if (!mounted || !succeeded) return;
    SmartSnackBars.showSuccess(context, 'User data refreshed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: GradientHeader(
              title: 'User List',
              subtitle: 'SmartPagination + SmartExecuter integration',
              icon: Icons.people,
            ),
          ),

          // Actions bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pull to refresh or scroll for more',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _controller.paginationCubit.refreshPaginatedList(),
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                  ),
                ],
              ),
            ),
          ),

          // Paginated list
          SliverFillRemaining(
            child: SmartPaginationListView<DemoUser>.withCubit(
              cubit: _controller.paginationCubit,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, items, index) {
                final user = items[index];
                return _UserCard(
                  user: user,
                  onDelete: () => _showDeleteConfirmation(user),
                  onRefresh: () => _refreshUser(user),
                );
              },

              separator: const SizedBox(height: 12),

              // First page loading
              firstPageLoadingBuilder: (context) => const Center(
                child: SmartLoadingCard(
                  title: 'Loading Users',
                  message: 'Fetching user data from server...',
                ),
              ),

              // First page error with SmartStatusCard
              firstPageErrorBuilder: (context, error, retry) {
                if (error is SmartException) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: SmartErrorCard.fromException(
                      error,
                      action: 'Retry',
                      onActionPressed: retry,
                    ),
                  );
                }
                return SmartErrorCard(
                  title: 'Failed to load users',
                  message: error.toString(),
                  action: 'Try Again',
                  onActionPressed: retry,
                );
              },

              // Load more indicator
              loadMoreLoadingBuilder: (context) => const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),

              // Load more error
              loadMoreErrorBuilder: (context, error, retry) => Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error),
                    const SizedBox(width: 8),
                    const Text('Failed to load more'),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: retry,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),

              // Empty state
              emptyWidget: const SmartEmptyCard(
                title: 'No Users Found',
                message: 'There are no users to display',
                icon: Icons.person_off,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(DemoUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(user);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// User card widget
class _UserCard extends StatelessWidget {
  final DemoUser user;
  final VoidCallback onDelete;
  final VoidCallback onRefresh;

  const _UserCard({
    required this.user,
    required this.onDelete,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(user.avatar),
              onBackgroundImageError: (_, __) {},
              child: const Icon(Icons.person),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.business,
                        size: 14,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        user.company,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'refresh':
                    onRefresh();
                    break;
                  case 'delete':
                    onDelete();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'refresh',
                  child: Row(
                    children: [
                      Icon(Icons.refresh),
                      SizedBox(width: 8),
                      Text('Refresh'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: AppColors.error),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: AppColors.error)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
