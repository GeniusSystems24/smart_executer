import 'package:flutter/material.dart';
import 'package:smart_executer_example/features/examples/ui_patterns/optimistic_update/domain/entities/todo_item.dart';
import 'package:smart_executer_example/features/examples/ui_patterns/optimistic_update/presentation/controllers/optimistic_update_controller.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/premium_widgets.dart';

class OptimisticUpdatePage extends StatefulWidget {
  const OptimisticUpdatePage({super.key});
  @override
  State<OptimisticUpdatePage> createState() => _OptimisticUpdatePageState();
}

class _OptimisticUpdatePageState extends State<OptimisticUpdatePage> {
  late final OptimisticUpdateController _controller;

  List<TodoItem> get _items => _controller.items;
  bool get _simulateError => _controller.simulateError;

  @override
  void initState() {
    super.initState();
    _controller = OptimisticUpdateController()..addListener(_refreshView);
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

  Future<void> _toggleItem(int index) async {
    final item = _items[index];
    final targetDone = !item.done;
    final future = _controller.toggle(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(targetDone ? 'Marked as done' : 'Marked as pending'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.success,
      ),
    );
    final succeeded = await future;
    if (!mounted || succeeded) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to update - rolled back'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Future<void> _deleteItem(int index) async {
    final future = _controller.delete(index);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: _controller.undoLastDelete,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
    final succeeded = await future;
    if (!mounted || succeeded) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed - restored item'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PremiumPageHeader(
              title: 'Optimistic Updates',
              subtitle: 'Update UI immediately, sync with server later',
              icon: Icons.flash_on_rounded,
              gradient: AppColors.warmGradient,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSettings(),
                const SizedBox(height: 20),
                _buildInfo(),
                const SizedBox(height: 20),
                ..._items.asMap().entries.map((e) => _TodoCard(
                      item: e.value,
                      onToggle: () => _toggleItem(e.key),
                      onDelete: () => _deleteItem(e.key),
                    )),
                const SizedBox(height: 24),
                Center(
                  child: TextButton.icon(
                    onPressed: _controller.reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Items'),
                  ),
                ),
                const SizedBox(height: 24),
                LiveCodePreview(
                  title: 'Optimistic Update Pattern',
                  language: 'dart',
                  code: '''Future<void> toggleTodo(int id, bool done) async {
  // 1. Save previous state
  final previousState = todos[id].done;
  
  // 2. Update UI immediately (optimistic)
  setState(() => todos[id].done = done);
  
  // 3. Make API call
  final result = await SmartExecuter.execute(
    () => api.updateTodo(id, done),
  );
  
  // 4. Rollback on failure
  if (result is Failure) {
    setState(() => todos[id].done = previousState);
    showError('Update failed');
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

  Widget _buildSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Icon(_simulateError ? Icons.bug_report : Icons.check_circle,
            color: _simulateError ? AppColors.error : AppColors.success),
        const SizedBox(width: 12),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Simulate API Errors',
                style: TextStyle(fontWeight: FontWeight.w600)),
            Text(
                _simulateError
                    ? 'Updates will fail and rollback'
                    : 'Updates will succeed',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ]),
        ),
        Switch(
            value: _simulateError,
            onChanged: _controller.setSimulateError),
      ]),
    );
  }

  Widget _buildInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
      ),
      child: Row(children: [
        const Icon(Icons.info_outline, color: AppColors.warning),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
              'Tap items to toggle, swipe to delete. Notice how the UI updates instantly!',
              style: TextStyle(fontSize: 13, color: AppColors.warning)),
        ),
      ]),
    );
  }
}

class _TodoCard extends StatelessWidget {
  final TodoItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  const _TodoCard(
      {required this.item, required this.onToggle, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: item.done
                    ? AppColors.success.withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: item.done
                      ? AppColors.success.withValues(alpha: 0.3)
                      : AppColors.border,
                ),
              ),
              child: Row(children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: item.done ? AppColors.success : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color:
                            item.done ? AppColors.success : AppColors.textHint,
                        width: 2),
                  ),
                  child: item.done
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration: item.done ? TextDecoration.lineThrough : null,
                      color: item.done
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(Icons.chevron_left, color: AppColors.textHint, size: 20),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
