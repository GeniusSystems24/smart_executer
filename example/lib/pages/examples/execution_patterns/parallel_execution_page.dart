import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import '../../../core/app_theme.dart';
import '../../../core/premium_widgets.dart';

class ParallelExecutionPage extends StatefulWidget {
  const ParallelExecutionPage({super.key});
  @override
  State<ParallelExecutionPage> createState() => _ParallelExecutionPageState();
}

class _ParallelExecutionPageState extends State<ParallelExecutionPage> {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
  final List<_Task> _tasks = [];
  bool _isRunning = false;
  int _totalTime = 0;

  @override
  void initState() {
    super.initState();
    _initTasks();
  }

  void _initTasks() {
    _tasks.clear();
    _tasks.addAll([
      _Task('Posts', '/posts?_limit=10', Icons.article_rounded,
          AppColors.primary),
      _Task('Users', '/users', Icons.people_rounded, AppColors.secondary),
      _Task('Comments', '/comments?_limit=10', Icons.comment_rounded,
          AppColors.accent),
      _Task('Albums', '/albums?_limit=10', Icons.photo_album_rounded,
          AppColors.warning),
    ]);
  }

  Future<void> _runParallel() async {
    setState(() {
      _isRunning = true;
      _initTasks();
      _totalTime = 0;
    });

    for (var t in _tasks) {
      t.status = _Status.running;
    }
    setState(() {});

    final start = DateTime.now();

    final futures = _tasks.map((task) async {
      final taskStart = DateTime.now();
      try {
        final r = await SmartExecuter.execute<Response>(
            () => _dio.get(task.endpoint));
        task.ms = DateTime.now().difference(taskStart).inMilliseconds;
        r.fold(
          onSuccess: (d) {
            task.result = '${d.data.length} items';
            task.status = _Status.done;
          },
          onFailure: (e) {
            task.result = e.message;
            task.status = _Status.error;
          },
        );
      } catch (e) {
        task.ms = DateTime.now().difference(taskStart).inMilliseconds;
        task.result = 'Error: $e';
        task.status = _Status.error;
      }
      setState(() {});
    });

    await Future.wait(futures);
    _totalTime = DateTime.now().difference(start).inMilliseconds;
    setState(() => _isRunning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PremiumPageHeader(
              title: 'Parallel Execution',
              subtitle: 'Execute multiple operations simultaneously',
              icon: Icons.call_split_rounded,
              gradient: AppColors.accentGradient,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (_totalTime > 0) _buildStats(),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: _tasks.map((t) => _TaskCard(task: t)).toList(),
                ),
                const SizedBox(height: 24),
                Center(
                  child: GradientButton(
                    label: _isRunning ? 'Running...' : 'Run Parallel',
                    icon: Icons.play_arrow_rounded,
                    gradient: AppColors.accentGradient,
                    isLoading: _isRunning,
                    onPressed: _isRunning ? null : _runParallel,
                  ),
                ),
                const SizedBox(height: 24),
                LiveCodePreview(
                  title: 'Example Code',
                  language: 'dart',
                  code: '''// Execute all requests in parallel
final results = await Future.wait([
  SmartExecuter.execute(() => dio.get('/posts')),
  SmartExecuter.execute(() => dio.get('/users')),
  SmartExecuter.execute(() => dio.get('/comments')),
]);

// Process all results
for (final result in results) {
  result.fold(
    onSuccess: (data) => print('Got: \${data.data}'),
    onFailure: (e) => print('Error: \${e.message}'),
  );
}''',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final done = _tasks.where((t) => t.status == _Status.done).length;
    final slowest =
        _tasks.map((t) => t.ms ?? 0).reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Stat('Total Time', '${_totalTime}ms', Icons.timer_rounded),
          _Stat(
              'Success', '$done/${_tasks.length}', Icons.check_circle_rounded),
          _Stat('Slowest', '${slowest}ms', Icons.speed_rounded),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _Stat(this.label, this.value, this.icon);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(icon, color: Colors.white70, size: 20),
      const SizedBox(height: 4),
      Text(value,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
    ]);
  }
}

enum _Status { pending, running, done, error }

class _Task {
  final String name, endpoint;
  final IconData icon;
  final Color color;
  _Status status = _Status.pending;
  String? result;
  int? ms;
  _Task(this.name, this.endpoint, this.icon, this.color);
}

class _TaskCard extends StatelessWidget {
  final _Task task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: task.status == _Status.done
                ? AppColors.success.withValues(alpha: 0.3)
                : task.status == _Status.error
                    ? AppColors.error.withValues(alpha: 0.3)
                    : AppColors.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: task.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Icon(task.icon, color: task.color, size: 20),
            ),
            const Spacer(),
            if (task.status == _Status.running)
              const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            if (task.status == _Status.done)
              Icon(Icons.check_circle, color: AppColors.success, size: 20),
            if (task.status == _Status.error)
              Icon(Icons.error, color: AppColors.error, size: 20),
          ]),
          const Spacer(),
          Text(task.name, style: AppTextStyles.titleMedium),
          if (task.result != null)
            Text(task.result!,
                style: TextStyle(
                    fontSize: 12,
                    color: task.status == _Status.error
                        ? AppColors.error
                        : AppColors.textSecondary)),
          if (task.ms != null)
            Text('${task.ms}ms',
                style: TextStyle(fontSize: 11, color: AppColors.textHint)),
        ],
      ),
    );
  }
}
