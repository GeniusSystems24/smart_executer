import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/features/scenarios/full_integration/domain/entities/demo_task.dart';
import 'package:smart_executer_example/shared/application/contracts/demo_http_client.dart';
import 'package:smart_executer_example/shared/domain/models/demo_http_response.dart';
import 'package:smart_pagination/pagination.dart';

/// Coordinates the full-integration task dashboard.
final class FullIntegrationController extends ChangeNotifier {
  FullIntegrationController({required DemoHttpClient client}) : _client = client {
    tasksCubit = SmartPaginationCubit<DemoTask>(
      request: PaginationRequest(page: 1, pageSize: 15),
      provider: PaginationProvider.future(_fetchTasks),
      dataAge: const Duration(minutes: 10),
    );
  }

  final DemoHttpClient _client;
  late final SmartPaginationCubit<DemoTask> tasksCubit;

  String _filter = 'all';
  int _completedCount = 0;
  int _pendingCount = 0;

  String get filter => _filter;
  int get completedCount => _completedCount;
  int get pendingCount => _pendingCount;

  void setFilter(String value) {
    if (_filter == value) return;
    _filter = value;
    notifyListeners();
  }

  Future<List<DemoTask>> _fetchTasks(PaginationRequest request) async {
    final result = await SmartExecuter.execute<DemoHttpResponse<dynamic>>(
      () => _client.get(
        '/todos',
        queryParameters: {
          '_page': request.page,
          '_limit': request.pageSize,
        },
      ),
    );

    return result.fold(
      onSuccess: (response) {
        final tasks = (response.data as List<dynamic>)
            .map((json) => DemoTask.fromJson(json as Map<String, dynamic>))
            .toList(growable: false);
        if (request.page == 1) _replaceCounts(tasks);
        return tasks;
      },
      onFailure: (exception) => throw exception,
    );
  }

  Future<bool> toggleTask(BuildContext context, DemoTask task) async {
    final newStatus = !task.completed;
    var succeeded = false;
    await SmartExecuter.run<DemoHttpResponse<dynamic>>(
      request: () => _client.patch(
        '/todos/${task.id}',
        data: {'completed': newStatus},
      ),
      context: context,
      options: ExecuterOptions(
        operationName: 'toggleTask',
        metadata: {'taskId': task.id, 'newStatus': newStatus},
      ),
      onSuccess: (_) async {
        tasksCubit.updateWhereEmit(
          (item) => item.id == task.id,
          (item) => item.copyWith(completed: newStatus),
        );
        if (newStatus) {
          _completedCount++;
          if (_pendingCount > 0) _pendingCount--;
        } else {
          _pendingCount++;
          if (_completedCount > 0) _completedCount--;
        }
        succeeded = true;
        notifyListeners();
      },
    );
    return succeeded;
  }

  Future<bool> deleteTask(BuildContext context, DemoTask task) async {
    var succeeded = false;
    await SmartExecuter.run<DemoHttpResponse<dynamic>>(
      request: () => _client.delete('/todos/${task.id}'),
      context: context,
      options: ExecuterOptions(
        operationName: 'deleteTask',
        metadata: {'taskId': task.id},
      ),
      onSuccess: (_) async {
        tasksCubit.removeWhereEmit((item) => item.id == task.id);
        if (task.completed) {
          if (_completedCount > 0) _completedCount--;
        } else {
          if (_pendingCount > 0) _pendingCount--;
        }
        succeeded = true;
        notifyListeners();
      },
    );
    return succeeded;
  }

  Future<DemoTask?> createTask(
    BuildContext context, {
    required String title,
    required String description,
  }) async {
    DemoTask? created;
    await SmartExecuter.run<DemoHttpResponse<dynamic>>(
      request: () => _client.post(
        '/todos',
        data: {
          'title': title,
          'body': description,
          'completed': false,
          'userId': 1,
        },
      ),
      context: context,
      options: const ExecuterOptions(operationName: 'createTask'),
      onSuccess: (response) async {
        final responseData = Map<String, dynamic>.from(
          response.data as Map,
        );
        created = DemoTask.fromJson({
          ...responseData,
          'id': DateTime.now().millisecondsSinceEpoch,
        });
        tasksCubit.addOrUpdateEmit(created!);
        _pendingCount++;
        notifyListeners();
      },
    );
    return created;
  }

  void _replaceCounts(List<DemoTask> tasks) {
    _completedCount = tasks.where((task) => task.completed).length;
    _pendingCount = tasks.length - _completedCount;
    notifyListeners();
  }

  void disposeController() {
    unawaited(tasksCubit.close());
  }
}
