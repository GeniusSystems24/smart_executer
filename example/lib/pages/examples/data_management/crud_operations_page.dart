import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import '../../../core/app_theme.dart';
import '../../../core/premium_widgets.dart';

class CrudOperationsPage extends StatefulWidget {
  const CrudOperationsPage({super.key});
  @override
  State<CrudOperationsPage> createState() => _CrudOperationsPageState();
}

class _CrudOperationsPageState extends State<CrudOperationsPage> {
  final _items = <_Item>[];
  int _nextId = 1;
  final _logs = <String>[];

  void _addLog(String msg) => setState(() => _logs.insert(0,
      '[${DateTime.now().toString().split('.').first.split(' ').last}] $msg'));

  // CREATE
  Future<void> _createItem() async {
    final name = await _showInputDialog('Create Item', 'Enter item name');
    if (name == null || name.isEmpty) return;

    _addLog('Creating "$name"...');
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() => _items.add(_Item(_nextId++, name, DateTime.now())));
    _addLog('✓ Created item: $name');
    if (mounted) SmartSnackBars.showSuccess(context, 'Item created');
  }

  // READ
  void _readItem(_Item item) {
    _addLog('Reading item #${item.id}');
    showDialog(
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
            ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'))
        ],
      ),
    );
  }

  // UPDATE
  Future<void> _updateItem(_Item item) async {
    final newName =
        await _showInputDialog('Update Item', 'Enter new name', item.name);
    if (newName == null || newName.isEmpty || newName == item.name) return;

    _addLog('Updating item #${item.id}...');
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      item.name = newName;
      item.updatedAt = DateTime.now();
    });
    _addLog('✓ Updated item #${item.id} to "$newName"');
    if (mounted) SmartSnackBars.showSuccess(context, 'Item updated');
  }

  // DELETE
  Future<void> _deleteItem(_Item item) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: FilledButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Delete')),
        ],
      ),
    );

    if (confirm != true) return;

    _addLog('Deleting item #${item.id}...');
    await Future.delayed(const Duration(milliseconds: 500));

    setState(() => _items.removeWhere((i) => i.id == item.id));
    _addLog('✓ Deleted item #${item.id}');
    if (mounted) SmartSnackBars.showSuccess(context, 'Item deleted');
  }

  Future<String?> _showInputDialog(String title, String hint,
      [String? initial]) {
    final controller = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(hintText: hint)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Save')),
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
                onPressed: () => setState(() => _logs.clear())),
        ]),
        const SizedBox(height: 8),
        if (_logs.isEmpty)
          const Text('No activity yet',
              style: TextStyle(color: Colors.white38, fontSize: 12))
        else
          ...List.generate(
              _logs.length.clamp(0, 10),
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

class _Item {
  final int id;
  String name;
  final DateTime createdAt;
  DateTime? updatedAt;
  _Item(this.id, this.name, this.createdAt);
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
  final _Item item;
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
