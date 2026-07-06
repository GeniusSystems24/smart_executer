import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/features/examples/execution_patterns/parallel/presentation/models/parallel_task.dart';
import 'package:smart_executer_example/shared/application/contracts/demo_http_client.dart';
import 'package:smart_executer_example/shared/domain/models/demo_http_response.dart';

final class ParallelExecutionController extends ChangeNotifier {
  ParallelExecutionController({required DemoHttpClient client})
      : _client = client {
    _resetTasks();
  }

  final DemoHttpClient _client;
  final List<ParallelTask> _tasks = [];
  bool _isRunning = false;
  int _totalTime = 0;

  List<ParallelTask> get tasks => List.unmodifiable(_tasks);
  bool get isRunning => _isRunning;
  int get totalTime => _totalTime;

  Future<void> run() async {
    _isRunning = true;
    _totalTime = 0;
    _resetTasks(status: ParallelTaskStatus.running);
    notifyListeners();

    final startedAt = DateTime.now();
    await Future.wait(
      List.generate(_tasks.length, (index) => _runTask(index)),
    );
    _totalTime = DateTime.now().difference(startedAt).inMilliseconds;
    _isRunning = false;
    notifyListeners();
  }

  Future<void> _runTask(int index) async {
    final task = _tasks[index];
    final startedAt = DateTime.now();
    try {
      final result = await SmartExecuter.execute<DemoHttpResponse<dynamic>>(
        () => _client.get(task.endpoint),
      );
      _tasks[index] = result.fold(
        onSuccess: (response) => task.copyWith(
          status: ParallelTaskStatus.done,
          result: '${(response.data as List<dynamic>).length} items',
          elapsedMilliseconds:
              DateTime.now().difference(startedAt).inMilliseconds,
        ),
        onFailure: (exception) => task.copyWith(
          status: ParallelTaskStatus.error,
          result: exception.message,
          elapsedMilliseconds:
              DateTime.now().difference(startedAt).inMilliseconds,
        ),
      );
    } catch (error) {
      _tasks[index] = task.copyWith(
        status: ParallelTaskStatus.error,
        result: 'Error: $error',
        elapsedMilliseconds:
            DateTime.now().difference(startedAt).inMilliseconds,
      );
    }
    notifyListeners();
  }

  void _resetTasks({ParallelTaskStatus status = ParallelTaskStatus.pending}) {
    _tasks
      ..clear()
      ..addAll([
        ParallelTask(
          name: 'Posts',
          endpoint: '/posts?_limit=10',
          icon: Icons.article_rounded,
          color: AppColors.primary,
          status: status,
        ),
        ParallelTask(
          name: 'Users',
          endpoint: '/users',
          icon: Icons.people_rounded,
          color: AppColors.secondary,
          status: status,
        ),
        ParallelTask(
          name: 'Comments',
          endpoint: '/comments?_limit=10',
          icon: Icons.comment_rounded,
          color: AppColors.accent,
          status: status,
        ),
        ParallelTask(
          name: 'Albums',
          endpoint: '/albums?_limit=10',
          icon: Icons.photo_album_rounded,
          color: AppColors.warning,
          status: status,
        ),
      ]);
  }
}
