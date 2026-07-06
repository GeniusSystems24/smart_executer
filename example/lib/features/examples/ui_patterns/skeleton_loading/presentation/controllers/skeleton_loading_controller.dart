import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:smart_executer_example/features/examples/ui_patterns/skeleton_loading/domain/entities/skeleton_item.dart';

final class SkeletonLoadingController extends ChangeNotifier {
  SkeletonLoadingController({Random? random}) : _random = random ?? Random();

  final Random _random;
  final List<SkeletonItem> _items = [];
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  List<SkeletonItem> get items => List.unmodifiable(_items);

  Future<void> load() async {
    _isLoading = true;
    _items.clear();
    notifyListeners();

    await Future<void>.delayed(const Duration(seconds: 2));
    _items.addAll(
      List.generate(
        8,
        (index) => SkeletonItem(
          title: 'Item ${index + 1} Title',
          subtitle: 'This is the description for item ${index + 1}',
          avatar: 'https://i.pravatar.cc/100?img=${index + 1}',
          value: _random.nextInt(1000),
        ),
      ),
    );
    _isLoading = false;
    notifyListeners();
  }
}
