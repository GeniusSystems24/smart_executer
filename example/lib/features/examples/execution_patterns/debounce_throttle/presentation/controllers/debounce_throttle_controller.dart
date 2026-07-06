import 'dart:async';

import 'package:flutter/foundation.dart';

final class DebounceThrottleController extends ChangeNotifier {
  DebounceThrottleController({
    this.debounceMilliseconds = 500,
    this.throttleMilliseconds = 1000,
  });

  final int debounceMilliseconds;
  final int throttleMilliseconds;

  final List<String> _normalLogs = [];
  final List<String> _debouncedLogs = [];
  final List<String> _throttledLogs = [];
  Timer? _debounceTimer;
  DateTime? _lastThrottleTime;
  int _normalCount = 0;
  int _debouncedCount = 0;
  int _throttledCount = 0;

  List<String> get normalLogs => List.unmodifiable(_normalLogs);
  List<String> get debouncedLogs => List.unmodifiable(_debouncedLogs);
  List<String> get throttledLogs => List.unmodifiable(_throttledLogs);
  int get normalCount => _normalCount;
  int get debouncedCount => _debouncedCount;
  int get throttledCount => _throttledCount;

  void onSearchChanged(String value) {
    _normalCount++;
    _normalLogs.add('[$_normalCount] "$value"');

    _debounceTimer?.cancel();
    _debounceTimer = Timer(
      Duration(milliseconds: debounceMilliseconds),
      () {
        _debouncedCount++;
        _debouncedLogs.add('[$_debouncedCount] "$value"');
        notifyListeners();
      },
    );

    final now = DateTime.now();
    if (_lastThrottleTime == null ||
        now.difference(_lastThrottleTime!).inMilliseconds >=
            throttleMilliseconds) {
      _lastThrottleTime = now;
      _throttledCount++;
      _throttledLogs.add('[$_throttledCount] "$value"');
    }
    notifyListeners();
  }

  void clear() {
    _debounceTimer?.cancel();
    _normalLogs.clear();
    _debouncedLogs.clear();
    _throttledLogs.clear();
    _normalCount = 0;
    _debouncedCount = 0;
    _throttledCount = 0;
    _lastThrottleTime = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
