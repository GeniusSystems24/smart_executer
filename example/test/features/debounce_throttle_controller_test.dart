import 'package:flutter_test/flutter_test.dart';
import 'package:smart_executer_example/features/examples/execution_patterns/debounce_throttle/presentation/controllers/debounce_throttle_controller.dart';

void main() {
  test('normal and throttled streams are coordinated by the controller', () {
    final controller = DebounceThrottleController();
    addTearDown(controller.dispose);

    controller
      ..onSearchChanged('a')
      ..onSearchChanged('ab');

    expect(controller.normalCount, 2);
    expect(controller.normalLogs, ['[1] "a"', '[2] "ab"']);
    expect(controller.throttledCount, 1);
    expect(controller.throttledLogs, ['[1] "a"']);
  });

  test('clear resets observable state', () {
    final controller = DebounceThrottleController();
    addTearDown(controller.dispose);

    controller
      ..onSearchChanged('query')
      ..clear();

    expect(controller.normalCount, 0);
    expect(controller.debouncedCount, 0);
    expect(controller.throttledCount, 0);
    expect(controller.normalLogs, isEmpty);
  });
}
