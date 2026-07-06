import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/app/app_dependencies.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/features/scenarios/full_integration/domain/entities/demo_task.dart';
import 'package:smart_executer_example/features/scenarios/full_integration/presentation/controllers/full_integration_controller.dart';
import 'package:smart_executer_example/shared/presentation/widgets/common_widgets.dart';
import 'package:smart_pagination/pagination.dart';
import 'package:super_dialog/super_dialog.dart';
import 'package:tooltip_card/tooltip_card.dart';

/// Task-management dashboard combining all companion packages.
class FullIntegrationScenario extends StatefulWidget {
  const FullIntegrationScenario({super.key});

  @override
  State<FullIntegrationScenario> createState() =>
      _FullIntegrationScenarioState();
}

class _FullIntegrationScenarioState extends State<FullIntegrationScenario> {
  late final FullIntegrationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FullIntegrationController(
      client: AppDependencies.createHttpClient(),
    )..addListener(_refreshView);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_refreshView)
      ..disposeController();
    super.dispose();
  }

  void _refreshView() {
    if (mounted) setState(() {});
  }

  Future<void> _toggleTask(DemoTask task) async {
    final succeeded = await _controller.toggleTask(context, task);
    if (!mounted || !succeeded) return;
    _showStatusChangeDialog(task, !task.completed);
  }

  void _showStatusChangeDialog(DemoTask task, bool completed) {
    SuperDialog.showAnimatedDialog<void>(
      context,
      (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: completed
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.warning.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  completed ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 48,
                  color: completed ? AppColors.success : AppColors.warning,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                completed ? 'Task Completed!' : 'Task Reopened',
                style: AppTextStyles.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                task.title,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      animation:
          completed ? DialogAnimation.bounceIn : DialogAnimation.centerScale,
      config: const SuperDialogConfig(
        openDuration: Duration(milliseconds: 400),
      ),
    );

    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted && Navigator.canPop(context)) Navigator.pop(context);
    });
  }

  Future<void> _deleteTask(DemoTask task) async {
    final confirmed = await SuperDialog.showPositionedDialog<bool>(
      context,
      (context) => _DeleteConfirmDialog(
        taskTitle: task.title,
        onConfirm: () => Navigator.pop(context, true),
        onCancel: () => Navigator.pop(context, false),
      ),
      startPosition: DialogPosition.bottomCenter,
      endPosition: DialogPosition.center,
      transitionType: PositionedTransitionType.slideFadeScale,
    );
    if (confirmed != true || !mounted) return;

    final succeeded = await _controller.deleteTask(context, task);
    if (mounted && succeeded) {
      SmartSnackBars.showSuccess(context, 'Task deleted successfully');
    }
  }

  void _showCreateTaskDialog() {
    SuperDialog.showAnimatedDialog<void>(
      context,
      (context) => _CreateTaskDialog(
        onCreate: (title, description) => _createTask(title, description),
      ),
      animation: DialogAnimation.bottomToTop,
      config: const SuperDialogConfig(
        openDuration: Duration(milliseconds: 350),
        openCurve: Curves.easeOutCubic,
      ),
    );
  }

  Future<void> _createTask(String title, String description) async {
    Navigator.pop(context);
    final task = await _controller.createTask(
      context,
      title: title,
      description: description,
    );
    if (!mounted || task == null) return;
    SuperDialog.showAnimatedDialog<void>(
      context,
      (context) => _SuccessDialog(
        message: 'Task created successfully!',
        onDismiss: () => Navigator.pop(context),
      ),
      animation: DialogAnimation.bounceIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
      body: CustomScrollView(
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: GradientHeader(
              title: 'Task Dashboard',
              subtitle: 'Full integration: Pagination + Dialog + Tooltip',
              icon: Icons.dashboard,
            ),
          ),

          // Stats cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      title: 'Completed',
                      count: _controller.completedCount,
                      icon: Icons.check_circle,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      title: 'Pending',
                      count: _controller.pendingCount,
                      icon: Icons.pending_actions,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _controller.filter == 'all',
                    onSelected: () => _controller.setFilter('all'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Completed',
                    selected: _controller.filter == 'completed',
                    onSelected: () => _controller.setFilter('completed'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Pending',
                    selected: _controller.filter == 'pending',
                    onSelected: () => _controller.setFilter('pending'),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _controller.tasksCubit.refreshPaginatedList(),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // Task list
          SliverFillRemaining(
            child: SmartPaginationListView<DemoTask>.withCubit(
              cubit: _controller.tasksCubit,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, items, index) {
                final task = items[index];

                // Apply filter
                if (_controller.filter == 'completed' && !task.completed) {
                  return const SizedBox.shrink();
                }
                if (_controller.filter == 'pending' && task.completed) {
                  return const SizedBox.shrink();
                }

                return _TaskCard(
                  task: task,
                  onToggle: () => _toggleTask(task),
                  onDelete: () => _deleteTask(task),
                );
              },
              separator: const SizedBox(height: 8),
              firstPageLoadingBuilder: (context) => const Center(
                child: SmartLoadingCard(
                  title: 'Loading Tasks',
                  message: 'Fetching your task list...',
                ),
              ),
              firstPageErrorBuilder: (context, error, retry) {
                if (error is SmartException) {
                  return SmartErrorCard.fromException(
                    error,
                    action: 'Retry',
                    onActionPressed: retry,
                  );
                }
                return SmartErrorCard(
                  title: 'Failed to load tasks',
                  message: error.toString(),
                  action: 'Try Again',
                  onActionPressed: retry,
                );
              },
              emptyWidget: const SmartEmptyCard(
                title: 'No Tasks',
                message: 'Create your first task to get started',
                icon: Icons.task_alt,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Task card with tooltip
class _TaskCard extends StatelessWidget {
  final DemoTask task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  Color get _priorityColor {
    switch (task.priority) {
      case 'Urgent':
        return AppColors.error;
      case 'High':
        return Colors.orange;
      case 'Medium':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TooltipCard.builder(
      beakEnabled: true,
      placementSide: TooltipCardPlacementSide.top,
      whenContentVisible: WhenContentVisible.secondaryTapButton,
      whenContentHide: WhenContentHide.pressOutSide,
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        child: ListTile(
          leading: GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: task.completed
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                task.completed
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.completed ? AppColors.success : AppColors.textHint,
              ),
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.completed ? TextDecoration.lineThrough : null,
              color: task.completed ? AppColors.textHint : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  task.priority,
                  style: TextStyle(
                    fontSize: 10,
                    color: _priorityColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatDate(task.createdAt),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline),
            color: AppColors.error,
          ),
        ),
      ),
      builder: (context, close) => TooltipCardContent(
        icon: Icon(
          task.completed ? Icons.task_alt : Icons.pending_actions,
          color: task.completed ? AppColors.success : AppColors.warning,
        ),
        title: task.title,
        subtitle: 'Priority: ${task.priority}',
        content: Text(
          task.description,
          style: AppTextStyles.bodyMedium,
          maxLines: 3,
        ),
        primaryAction: FilledButton(
          onPressed: () {
            close();
            onToggle();
          },
          child: Text(task.completed ? 'Reopen' : 'Complete'),
        ),
        secondaryAction: OutlinedButton(
          onPressed: () {
            close();
            onDelete();
          },
          style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text('Delete'),
        ),
        onClose: close,
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Stat card
class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count.toString(),
                  style: AppTextStyles.displayMedium.copyWith(fontSize: 24),
                ),
                Text(title, style: AppTextStyles.bodyMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Filter chip
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }
}

/// Delete confirmation dialog
class _DeleteConfirmDialog extends StatelessWidget {
  final String taskTitle;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _DeleteConfirmDialog({
    required this.taskTitle,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_forever,
                  size: 40, color: AppColors.error),
            ),
            const SizedBox(height: 20),
            const Text('Delete Task?', style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to delete "$taskTitle"?',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: onConfirm,
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.error),
                    child: const Text('Delete'),
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

/// Create task dialog
class _CreateTaskDialog extends StatefulWidget {
  final void Function(String title, String description) onCreate;

  const _CreateTaskDialog({required this.onCreate});

  @override
  State<_CreateTaskDialog> createState() => _CreateTaskDialogState();
}

class _CreateTaskDialogState extends State<_CreateTaskDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text('New Task', style: AppTextStyles.titleLarge),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) => v?.isEmpty == true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 50),
                    child: Icon(Icons.description),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onCreate(
                      _titleController.text,
                      _descController.text,
                    );
                  }
                },
                child: const Text('Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Success dialog
class _SuccessDialog extends StatefulWidget {
  const _SuccessDialog({
    required this.message,
    required this.onDismiss,
  });

  final String message;
  final VoidCallback onDismiss;

  @override
  State<_SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<_SuccessDialog> {
  late final Timer _dismissTimer;

  @override
  void initState() {
    super.initState();
    _dismissTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted || !Navigator.canPop(context)) return;
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _dismissTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.check, size: 48, color: AppColors.success),
            ),
            const SizedBox(height: 16),
            Text(widget.message, style: AppTextStyles.titleMedium),
          ],
        ),
      ),
    );
  }
}
