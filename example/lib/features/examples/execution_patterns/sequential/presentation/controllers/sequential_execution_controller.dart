import 'package:flutter/foundation.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/features/examples/execution_patterns/sequential/domain/models/execution_step.dart';
import 'package:smart_executer_example/shared/application/contracts/demo_http_client.dart';
import 'package:smart_executer_example/shared/domain/models/demo_http_response.dart';

final class SequentialExecutionController extends ChangeNotifier {
  SequentialExecutionController({required DemoHttpClient client})
      : _client = client {
    _resetSteps();
  }

  final DemoHttpClient _client;
  final List<ExecutionStep> _steps = [];
  bool _isRunning = false;
  int _currentStep = -1;

  List<ExecutionStep> get steps => List.unmodifiable(_steps);
  bool get isRunning => _isRunning;
  int get currentStep => _currentStep;

  Future<void> run() async {
    _isRunning = true;
    _currentStep = -1;
    _resetSteps();
    notifyListeners();

    for (var index = 0; index < _steps.length; index++) {
      _currentStep = index;
      notifyListeners();
      final startedAt = DateTime.now();

      try {
        String resultText;
        if (index == 0) {
          final result = await SmartExecuter.execute<DemoHttpResponse<dynamic>>(
            () => _client.get('/posts', queryParameters: {'_limit': 5}),
          );
          resultText = result.fold(
            onSuccess: (response) =>
                'Got ${(response.data as List<dynamic>).length} posts',
            onFailure: (exception) => throw exception,
          );
        } else if (index == 1) {
          final result = await SmartExecuter.execute<DemoHttpResponse<dynamic>>(
            () => _client.get('/users', queryParameters: {'_limit': 5}),
          );
          resultText = result.fold(
            onSuccess: (response) =>
                'Got ${(response.data as List<dynamic>).length} users',
            onFailure: (exception) => throw exception,
          );
        } else {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          resultText = index == 2 ? 'Data processed' : 'Done!';
        }

        _steps[index] = _steps[index].copyWith(
          status: ExecutionStepStatus.done,
          result: resultText,
          elapsedMilliseconds:
              DateTime.now().difference(startedAt).inMilliseconds,
        );
      } catch (error) {
        _steps[index] = _steps[index].copyWith(
          status: ExecutionStepStatus.error,
          result: 'Error: $error',
          elapsedMilliseconds:
              DateTime.now().difference(startedAt).inMilliseconds,
        );
        notifyListeners();
        break;
      }
      notifyListeners();
    }

    _isRunning = false;
    _currentStep = -1;
    notifyListeners();
  }

  void _resetSteps() {
    _steps
      ..clear()
      ..addAll(const [
        ExecutionStep(title: 'Fetch Posts', description: 'GET /posts?_limit=5'),
        ExecutionStep(title: 'Fetch Users', description: 'GET /users?_limit=5'),
        ExecutionStep(title: 'Process Data', description: 'Match posts with authors'),
        ExecutionStep(title: 'Complete', description: 'Finalize results'),
      ]);
  }
}
