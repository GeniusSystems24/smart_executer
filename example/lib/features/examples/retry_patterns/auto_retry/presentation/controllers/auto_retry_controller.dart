import 'package:flutter/foundation.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/features/examples/retry_patterns/auto_retry/presentation/models/retry_log.dart';
import 'package:smart_executer_example/shared/application/contracts/demo_http_client.dart';
import 'package:smart_executer_example/shared/domain/models/demo_http_response.dart';

final class AutoRetryController extends ChangeNotifier {
  AutoRetryController({required DemoHttpClient client}) : _client = client;

  final DemoHttpClient _client;
  final List<RetryLog> _logs = [];
  bool _isRunning = false;
  int _maxRetries = 3;
  int _currentAttempt = 0;
  bool _simulateFailure = true;
  int _failUntilAttempt = 2;

  List<RetryLog> get logs => List.unmodifiable(_logs);
  bool get isRunning => _isRunning;
  int get maxRetries => _maxRetries;
  int get currentAttempt => _currentAttempt;
  bool get simulateFailure => _simulateFailure;
  int get failUntilAttempt => _failUntilAttempt;

  void setMaxRetries(int value) {
    _maxRetries = value;
    notifyListeners();
  }

  void setSimulateFailure(bool value) {
    _simulateFailure = value;
    notifyListeners();
  }

  void setFailUntilAttempt(int value) {
    _failUntilAttempt = value;
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    notifyListeners();
  }

  Future<void> run() async {
    _isRunning = true;
    _logs.clear();
    _currentAttempt = 0;
    _addLog(
      'Starting request with max $_maxRetries retries...',
      RetryLogType.info,
    );

    var attempts = 0;
    SmartException? lastError;

    while (attempts <= _maxRetries) {
      attempts++;
      _currentAttempt = attempts;
      _addLog('Attempt $attempts/$_maxRetries', RetryLogType.info);

      try {
        if (_simulateFailure && attempts < _failUntilAttempt) {
          await Future<void>.delayed(const Duration(milliseconds: 500));
          throw const ConnectionException('Simulated network error');
        }

        final result = await SmartExecuter.execute<DemoHttpResponse<dynamic>>(
          () => _client.get('/posts/1'),
        );
        result.fold(
          onSuccess: (response) {
            _addLog('✓ Request successful!', RetryLogType.success);
            _addLog(
              'Title: ${(response.data as Map)['title']}',
              RetryLogType.success,
            );
          },
          onFailure: (exception) => throw exception,
        );
        lastError = null;
        break;
      } catch (error) {
        lastError = error is SmartException
            ? error
            : UnknownException(error.toString());
        _addLog(
          '✗ Attempt $attempts failed: ${lastError.message}',
          RetryLogType.error,
        );

        if (attempts <= _maxRetries) {
          final delay = Duration(milliseconds: 500 * attempts);
          _addLog(
            'Waiting ${delay.inMilliseconds}ms before retry...',
            RetryLogType.warning,
          );
          await Future<void>.delayed(delay);
        }
      }
    }

    if (lastError != null &&
        !_logs.any((log) => log.type == RetryLogType.success)) {
      _addLog(
        'All $_maxRetries retries exhausted. Final error: '
        '${lastError.message}',
        RetryLogType.error,
      );
    }

    _isRunning = false;
    _currentAttempt = 0;
    notifyListeners();
  }

  void _addLog(String message, RetryLogType type) {
    _logs.add(RetryLog(message, type, DateTime.now()));
    notifyListeners();
  }
}
