import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import '../../../core/app_theme.dart';
import '../../../core/premium_widgets.dart';

class SequentialExecutionPage extends StatefulWidget {
  const SequentialExecutionPage({super.key});
  @override
  State<SequentialExecutionPage> createState() =>
      _SequentialExecutionPageState();
}

class _SequentialExecutionPageState extends State<SequentialExecutionPage> {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));
  final List<_Step> _steps = [];
  bool _isRunning = false;
  int _currentStep = -1;

  @override
  void initState() {
    super.initState();
    _initSteps();
  }

  void _initSteps() {
    _steps.clear();
    _steps.addAll([
      _Step('Fetch Posts', 'GET /posts?_limit=5'),
      _Step('Fetch Users', 'GET /users?_limit=5'),
      _Step('Process Data', 'Match posts with authors'),
      _Step('Complete', 'Finalize results'),
    ]);
  }

  Future<void> _runSequential() async {
    setState(() {
      _isRunning = true;
      _currentStep = -1;
      _initSteps();
    });

    for (int i = 0; i < _steps.length; i++) {
      setState(() => _currentStep = i);
      final start = DateTime.now();

      try {
        if (i == 0) {
          final r = await SmartExecuter.execute<Response>(
              () => _dio.get('/posts?_limit=5'));
          r.fold(
            onSuccess: (d) => _steps[i].result = 'Got ${d.data.length} posts',
            onFailure: (e) => throw e,
          );
        } else if (i == 1) {
          final r = await SmartExecuter.execute<Response>(
              () => _dio.get('/users?_limit=5'));
          r.fold(
            onSuccess: (d) => _steps[i].result = 'Got ${d.data.length} users',
            onFailure: (e) => throw e,
          );
        } else {
          await Future.delayed(const Duration(milliseconds: 500));
          _steps[i].result = i == 2 ? 'Data processed' : 'Done!';
        }
        _steps[i].status = _Status.done;
      } catch (e) {
        _steps[i].status = _Status.error;
        _steps[i].result = 'Error: $e';
        break;
      }
      _steps[i].ms = DateTime.now().difference(start).inMilliseconds;
      setState(() {});
    }
    setState(() {
      _isRunning = false;
      _currentStep = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PremiumPageHeader(
              title: 'Sequential Execution',
              subtitle: 'Execute operations one after another',
              icon: Icons.format_list_numbered_rounded,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ..._steps.asMap().entries.map((e) => _StepCard(
                      index: e.key,
                      step: e.value,
                      isActive: e.key == _currentStep,
                      isLast: e.key == _steps.length - 1,
                    )),
                const SizedBox(height: 24),
                Center(
                  child: GradientButton(
                    label: _isRunning ? 'Running...' : 'Run Sequential',
                    icon: Icons.play_arrow_rounded,
                    isLoading: _isRunning,
                    onPressed: _isRunning ? null : _runSequential,
                  ),
                ),
                const SizedBox(height: 24),
                LiveCodePreview(
                  title: 'Example Code',
                  language: 'dart',
                  code:
                      '''final result1 = await SmartExecuter.execute(() => dio.get('/posts'));
final result2 = await SmartExecuter.execute(() => dio.get('/users'));
// Process results sequentially''',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

enum _Status { pending, done, error }

class _Step {
  final String title, desc;
  _Status status = _Status.pending;
  String? result;
  int? ms;
  _Step(this.title, this.desc);
}

class _StepCard extends StatelessWidget {
  final int index;
  final _Step step;
  final bool isActive, isLast;
  const _StepCard(
      {required this.index,
      required this.step,
      required this.isActive,
      required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = step.status == _Status.done
        ? AppColors.success
        : step.status == _Status.error
            ? AppColors.error
            : isActive
                ? AppColors.warning
                : AppColors.textHint;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: isActive
                  ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : Icon(
                      step.status == _Status.done
                          ? Icons.check
                          : step.status == _Status.error
                              ? Icons.close
                              : Icons.circle_outlined,
                      color: color,
                      size: 18),
            ),
            if (!isLast)
              Container(
                  width: 2, height: 24, color: color.withValues(alpha: 0.3)),
          ]),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : AppColors.surfaceVariant.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(14),
                border: isActive
                    ? Border.all(color: color.withValues(alpha: 0.3))
                    : null,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(step.title, style: AppTextStyles.titleMedium),
                      const Spacer(),
                      if (step.ms != null)
                        Text('${step.ms}ms',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textHint)),
                    ]),
                    const SizedBox(height: 4),
                    Text(step.desc, style: AppTextStyles.bodyMedium),
                    if (step.result != null) ...[
                      const SizedBox(height: 8),
                      Text(step.result!,
                          style: TextStyle(
                              fontSize: 12,
                              color: color,
                              fontWeight: FontWeight.w500)),
                    ],
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
