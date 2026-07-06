import 'package:flutter/foundation.dart';
import 'package:smart_executer_example/features/examples/ui_patterns/optimistic_update/domain/entities/todo_item.dart';

final class OptimisticUpdateController extends ChangeNotifier {
  OptimisticUpdateController() {
    reset();
  }

  final List<TodoItem> _items = [];
  List<TodoItem>? _deleteSnapshot;
  bool _simulateError = false;

  List<TodoItem> get items => List.unmodifiable(_items);
  bool get simulateError => _simulateError;

  void setSimulateError(bool value) {
    _simulateError = value;
    notifyListeners();
  }

  void reset() {
    _items
      ..clear()
      ..addAll(const [
        TodoItem(id: 1, title: 'Complete project documentation', done: false),
        TodoItem(id: 2, title: 'Review pull requests', done: false),
        TodoItem(id: 3, title: 'Update dependencies', done: true),
        TodoItem(id: 4, title: 'Write unit tests', done: false),
        TodoItem(id: 5, title: 'Deploy to staging', done: false),
      ]);
    _deleteSnapshot = null;
    notifyListeners();
  }

  Future<bool> toggle(int index) async {
    if (index < 0 || index >= _items.length) return false;
    final previous = _items[index];
    _items[index] = previous.copyWith(done: !previous.done);
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!_simulateError) return true;

    final currentIndex = _items.indexWhere((item) => item.id == previous.id);
    if (currentIndex >= 0) _items[currentIndex] = previous;
    notifyListeners();
    return false;
  }

  Future<bool> delete(int index) async {
    if (index < 0 || index >= _items.length) return false;
    _deleteSnapshot = List<TodoItem>.from(_items);
    _items.removeAt(index);
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!_simulateError) return true;

    undoLastDelete();
    return false;
  }

  void undoLastDelete() {
    final snapshot = _deleteSnapshot;
    if (snapshot == null) return;
    _items
      ..clear()
      ..addAll(snapshot);
    _deleteSnapshot = null;
    notifyListeners();
  }
}
