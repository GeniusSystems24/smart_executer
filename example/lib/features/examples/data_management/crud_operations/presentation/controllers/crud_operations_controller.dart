import 'package:flutter/foundation.dart';
import 'package:smart_executer_example/features/examples/data_management/crud_operations/domain/entities/crud_item.dart';

final class CrudOperationsController extends ChangeNotifier {
  final List<CrudItem> _items = [];
  final List<String> _logs = [];
  int _nextId = 1;

  List<CrudItem> get items => List.unmodifiable(_items);
  List<String> get logs => List.unmodifiable(_logs);

  Future<CrudItem> create(String name) async {
    _addLog('Creating "$name"...');
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final item = CrudItem(
      id: _nextId++,
      name: name,
      createdAt: DateTime.now(),
    );
    _items.add(item);
    _addLog('✓ Created item: $name');
    notifyListeners();
    return item;
  }

  void recordRead(CrudItem item) => _addLog('Reading item #${item.id}');

  Future<CrudItem> update(CrudItem item, String newName) async {
    _addLog('Updating item #${item.id}...');
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final updated = item.copyWith(name: newName, updatedAt: DateTime.now());
    final index = _items.indexWhere((candidate) => candidate.id == item.id);
    if (index >= 0) _items[index] = updated;
    _addLog('✓ Updated item #${item.id} to "$newName"');
    notifyListeners();
    return updated;
  }

  Future<void> delete(CrudItem item) async {
    _addLog('Deleting item #${item.id}...');
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _items.removeWhere((candidate) => candidate.id == item.id);
    _addLog('✓ Deleted item #${item.id}');
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }

  void _addLog(String message) {
    final time = DateTime.now().toString().split('.').first.split(' ').last;
    _logs.insert(0, '[$time] $message');
    notifyListeners();
  }
}
