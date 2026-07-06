import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/features/examples/data_management/crud_operations/domain/entities/crud_item.dart';
import 'package:smart_executer_example/features/examples/data_management/crud_operations/presentation/controllers/crud_operations_controller.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/premium_widgets.dart';

class CrudOperationsPage extends StatefulWidget {
  const CrudOperationsPage({super.key});
  @override
  State<CrudOperationsPage> createState() => _CrudOperationsPageState();
}

class _CrudOperationsPageState extends State<CrudOperationsPage> {
  late final CrudOperationsController _controller;

  List<CrudItem> get _items => _controller.items;
  List<String> get _logs => _controller.logs;

  @override
  void initState() {
    super.initState();
    _controller = CrudOperationsController()..addListener(_refreshView);
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

  Future<void> _createItem() async {
    final name = await _showInputDialog('Create Item', 'Enter item name');
    if (name == null || name.isEmpty) return;
    await _controller.create(name);
    if (mounted) SmartSnackBars.showSuccess(context, 'Item created');
  }

  void _readItem(CrudItem item) {
    _controller.recordRead(item);
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Item #${item.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow('ID', '${item.id}'),
            _InfoRow('Name', item.name),
            _InfoRow('Created', item.createdAt.toString().split('.').first),
            if (item.updatedAt != null)
              _InfoRow('Updated', item.updatedAt.toString().split('.').first),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateItem(CrudItem item) async {
    final newName = await _showInputDialog(
      'Update Item',
      'Enter new name',
      item.name,
    );
    if (newName == null || newName.isEmpty || newName == item.name) return;
    await _controller.update(item, newName);
    if (mounted) SmartSnackBars.showSuccess(context, 'Item updated');
  }

  Future<void> _deleteItem(CrudItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _controller.delete(item);
    if (mounted) SmartSnackBars.showSuccess(context, 'Item deleted');
  }

  Future<String?> _showInputDialog(
    String title,
    String hint, [
    String? initial,
  ]) {
    final textController = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: textController,
          autofocus: true,
          decoration: InputDecoration(hintText: hint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, textController.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createItem,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
        backgroundColor: AppColors.primary,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PremiumPageHeader(
              title: 'CRUD Operations',
              subtitle: 'Create, Read, Update, Delete patterns',
              icon: Icons.storage_rounded,
              gradient: AppColors.primaryGradient,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildOperationsGuide(),
                const SizedBox(height: 20),
                _buildItemsList(),
                const SizedBox(height: 20),
                _buildLogsSection(),
                const SizedBox(height: 80), // Space for FAB
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationsGuide() {
    return Row(
        children: [
      _OpCard('C', 'Create', Icons.add_circle, AppColors.success),
      _OpCard('R', 'Read', Icons.visibility, AppColors.info),
      _OpCard('U', 'Update', Icons.edit, AppColors.warning),
      _OpCard('D', 'Delete', Icons.delete, AppColors.error),
    ].map((w) => Expanded(child: w)).toList());
  }

  Widget _buildItemsList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Text('Items', style: AppTextStyles.titleMedium),
          const Spacer(),
          Text('${_items.length} total',
              style: TextStyle(color: AppColors.textHint, fontSize: 12)),
        ]),
        const Divider(height: 24),
        if (_items.isEmpty)
          const Center(
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('No items yet. Tap + to add one.',
                      style: TextStyle(color: AppColors.textHint))))
        else
          ..._items.map((item) => _ItemTile(
              item: item,
              onRead: () => _readItem(item),
              onUpdate: () => _updateItem(item),
              onDelete: () => _deleteItem(item))),
      ]),
    );
  }

  Widget _buildLogsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('Activity Log',
              style: TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.w600)),
          const Spacer(),
          if (_logs.isNotEmpty)
            IconButton(
                icon: const Icon(Icons.clear, color: Colors.white54, size: 18),
                onPressed: _controller.clearLogs),
        ]),
        const SizedBox(height: 8),
        if (_logs.isEmpty)
          const Text('No activity yet',
              style: TextStyle(color: Colors.white38, fontSize: 12))
        else
          ...List.generate(
              _logs.length.clamp(0, 10).toInt(),
              (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(_logs[i],
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontFamily: 'monospace')),
                  )),
      ]),
    );
  }
}

class _OpCard extends StatelessWidget {
  final String letter, label;
  final IconData icon;
  final Color color;
  const _OpCard(this.letter, this.label, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3))),
      child: Column(children: [
        Text(letter,
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: color)),
      ]),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final CrudItem item;
  final VoidCallback onRead, onUpdate, onDelete;
  const _ItemTile(
      {required this.item,
      required this.onRead,
      required this.onUpdate,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.surfaceVariant.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text('#${item.id}',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(item.name, style: AppTextStyles.titleMedium)),
        IconButton(
            icon: const Icon(Icons.visibility, size: 20),
            color: AppColors.info,
            onPressed: onRead),
        IconButton(
            icon: const Icon(Icons.edit, size: 20),
            color: AppColors.warning,
            onPressed: onUpdate),
        IconButton(
            icon: const Icon(Icons.delete, size: 20),
            color: AppColors.error,
            onPressed: onDelete),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value)
      ]));
}
