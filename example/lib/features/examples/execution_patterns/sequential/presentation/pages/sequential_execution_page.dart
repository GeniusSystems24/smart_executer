import 'package:flutter/material.dart';
import 'package:smart_executer_example/app/app_dependencies.dart';
import 'package:smart_executer_example/features/examples/execution_patterns/sequential/domain/models/execution_step.dart';
import 'package:smart_executer_example/features/examples/execution_patterns/sequential/presentation/controllers/sequential_execution_controller.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/premium_widgets.dart';

class SequentialExecutionPage extends StatefulWidget {
  const SequentialExecutionPage({super.key});
  @override
  State<SequentialExecutionPage> createState() =>
      _SequentialExecutionPageState();
}

class _SequentialExecutionPageState extends State<SequentialExecutionPage> {
  late final SequentialExecutionController _controller;

  List<ExecutionStep> get _steps => _controller.steps;
  bool get _isRunning => _controller.isRunning;
  int get _currentStep => _controller.currentStep;

  @override
  void initState() {
    super.initState();
    _controller = SequentialExecutionController(
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

  Future<void> _runSequential() => _controller.run();

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

class _StepCard extends StatelessWidget {
  final int index;
  final ExecutionStep step;
  final bool isActive, isLast;
  const _StepCard(
      {required this.index,
      required this.step,
      required this.isActive,
      required this.isLast});

  @override
  Widget build(BuildContext context) {
    final color = step.status == ExecutionStepStatus.done
        ? AppColors.success
        : step.status == ExecutionStepStatus.error
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
                      step.status == ExecutionStepStatus.done
                          ? Icons.check
                          : step.status == ExecutionStepStatus.error
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
                      if (step.elapsedMilliseconds != null)
                        Text('${step.elapsedMilliseconds}ms',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textHint)),
                    ]),
                    const SizedBox(height: 4),
                    Text(step.description, style: AppTextStyles.bodyMedium),
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
