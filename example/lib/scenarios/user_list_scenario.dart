import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_pagination/pagination.dart';

import '../core/app_theme.dart';
import '../core/widgets.dart';

/// User model for the list
class User {
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String company;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.company,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: 'https://i.pravatar.cc/150?img=${json['id'] ?? 1}',
      company: json['company']?['name'] ?? 'Unknown',
    );
  }
}

/// Scenario: Paginated User List with SmartExecuter error handling
///
/// This demonstrates:
/// - SmartPagination for infinite scrolling
/// - SmartExecuter for individual user actions (delete, update)
/// - SmartStatusCards for error states
/// - Integration between pagination and executer
class UserListScenario extends StatefulWidget {
  const UserListScenario({super.key});

  @override
  State<UserListScenario> createState() => _UserListScenarioState();
}

class _UserListScenarioState extends State<UserListScenario> {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
  ));

  late SmartPaginationCubit<User> _paginationCubit;

  @override
  void initState() {
    super.initState();
    _paginationCubit = SmartPaginationCubit<User>(
      request: PaginationRequest(page: 1, pageSize: 10),
      provider: PaginationProvider.future(_fetchUsers),
      dataAge: const Duration(minutes: 5),
    );
  }

  @override
  void dispose() {
    _paginationCubit.close();
    super.dispose();
  }

  /// Fetch users using SmartExecuter for consistent error handling
  Future<PaginationResponse<User>> _fetchUsers(PaginationRequest request) async {
    final result = await SmartExecuter.execute<Response>(
      () => _dio.get('/users', queryParameters: {
        '_page': request.page,
        '_limit': request.pageSize,
      }),
    );

    return result.fold(
      onSuccess: (response) {
        final users = (response.data as List)
            .map((json) => User.fromJson(json))
            .toList();

        return PaginationResponse<User>(
          items: users,
          hasMore: users.length >= request.pageSize,
          page: request.page,
        );
      },
      onFailure: (exception) {
        throw exception;
      },
    );
  }

  /// Delete user with confirmation and loading
  Future<void> _deleteUser(User user) async {
    await SmartExecuter.run(
      request: () => _dio.delete('/users/${user.id}'),
      context: context,
      options: ExecuterOptions(
        operationName: 'deleteUser',
        metadata: {'userId': user.id, 'userName': user.name},
      ),
      onSuccess: (response) async {
        // Remove from list
        _paginationCubit.removeWhere((u) => u.id == user.id);

        if (mounted) {
          SmartSnackBars.showSuccess(
            context,
            '${user.name} deleted successfully',
          );
        }
      },
      onError: (exception) async {
        if (mounted) {
          SmartSnackBars.showError(context, exception);
        }
      },
    );
  }

  /// Refresh user data
  Future<void> _refreshUser(User user) async {
    final result = await SmartExecuter.run(
      request: () => _dio.get('/users/${user.id}'),
      context: context,
      options: ExecuterOptions(
        operationName: 'refreshUser',
        metadata: {'userId': user.id},
      ),
    );

    if (result != null && mounted) {
      final updatedUser = User.fromJson(result.data);
      _paginationCubit.updateWhere(
        (u) => u.id == user.id,
        (u) => updatedUser,
      );
      SmartSnackBars.showSuccess(context, 'User data refreshed');
    }
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
                    onPressed: () => _paginationCubit.refresh(),
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                  ),
                ],
              ),
            ),
          ),

          // Paginated list
          SliverFillRemaining(
            child: SmartPaginationListView<User>.withCubit(
              cubit: _paginationCubit,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, items, index) {
                final user = items[index];
                return _UserCard(
                  user: user,
                  onDelete: () => _showDeleteConfirmation(user),
                  onRefresh: () => _refreshUser(user),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),

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
              loadMoreBuilder: (context) => const Padding(
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
              emptyBuilder: (context) => const SmartEmptyCard(
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

  void _showDeleteConfirmation(User user) {
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
  final User user;
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
