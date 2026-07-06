import 'package:flutter/material.dart';
import 'package:smart_executer_example/app/app_dependencies.dart';
import 'package:smart_executer_example/features/examples/execution_patterns/parallel/presentation/controllers/parallel_execution_controller.dart';
import 'package:smart_executer_example/features/examples/execution_patterns/parallel/presentation/models/parallel_task.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/premium_widgets.dart';

class ParallelExecutionPage extends StatefulWidget {
  const ParallelExecutionPage({super.key});
  @override
  State<ParallelExecutionPage> createState() => _ParallelExecutionPageState();
}

class _ParallelExecutionPageState extends State<ParallelExecutionPage> {
  late final ParallelExecutionController _controller;

  List<ParallelTask> get _tasks => _controller.tasks;
  bool get _isRunning => _controller.isRunning;
  int get _totalTime => _controller.totalTime;

  @override
  void initState() {
    super.initState();
    _controller = ParallelExecutionController(
      client: AppDependencies.createHttpClient(),
    )..addListener(_refreshView);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_refreshView)
      ..dispose();
    super.dispose();
  }

  void _refreshView() {
    if (mounted) setState(() {});
  }

  Future<void> _runParallel() => _controller.run();

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
    final done = _tasks.where((t) => t.status == ParallelTaskStatus.done).length;
    final slowest =
        _tasks.map((t) => t.elapsedMilliseconds ?? 0).reduce((a, b) => a > b ? a : b);
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

class _TaskCard extends StatelessWidget {
  final ParallelTask task;
  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: task.status == ParallelTaskStatus.done
                ? AppColors.success.withValues(alpha: 0.3)
                : task.status == ParallelTaskStatus.error
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
            if (task.status == ParallelTaskStatus.running)
              const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            if (task.status == ParallelTaskStatus.done)
              Icon(Icons.check_circle, color: AppColors.success, size: 20),
            if (task.status == ParallelTaskStatus.error)
              Icon(Icons.error, color: AppColors.error, size: 20),
          ]),
          const Spacer(),
          Text(task.name, style: AppTextStyles.titleMedium),
          if (task.result != null)
            Text(task.result!,
                style: TextStyle(
                    fontSize: 12,
                    color: task.status == ParallelTaskStatus.error
                        ? AppColors.error
                        : AppColors.textSecondary)),
          if (task.elapsedMilliseconds != null)
            Text('${task.elapsedMilliseconds}ms',
                style: TextStyle(fontSize: 11, color: AppColors.textHint)),
        ],
      ),
    );
  }
}
