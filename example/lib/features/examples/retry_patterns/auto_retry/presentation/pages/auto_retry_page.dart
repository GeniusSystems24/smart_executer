import 'package:flutter/material.dart';
import 'package:smart_executer_example/app/app_dependencies.dart';
import 'package:smart_executer_example/features/examples/retry_patterns/auto_retry/presentation/controllers/auto_retry_controller.dart';
import 'package:smart_executer_example/features/examples/retry_patterns/auto_retry/presentation/models/retry_log.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/premium_widgets.dart';

class AutoRetryPage extends StatefulWidget {
  const AutoRetryPage({super.key});
  @override
  State<AutoRetryPage> createState() => _AutoRetryPageState();
}

class _AutoRetryPageState extends State<AutoRetryPage> {
  late final AutoRetryController _controller;

  List<RetryLog> get _logs => _controller.logs;
  bool get _isRunning => _controller.isRunning;
  int get _maxRetries => _controller.maxRetries;
  int get _currentAttempt => _controller.currentAttempt;
  bool get _simulateFailure => _controller.simulateFailure;
  int get _failUntilAttempt => _controller.failUntilAttempt;

  @override
  void initState() {
    super.initState();
    _controller = AutoRetryController(
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

  Future<void> _runWithRetry() => _controller.run();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PremiumPageHeader(
              title: 'Manual Retry Pattern',
              subtitle: 'Implement custom retry logic for failed requests',
              icon: Icons.refresh_rounded,
              gradient: AppColors.warmGradient,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSettings(),
                const SizedBox(height: 16),
                if (_isRunning) _buildProgress(),
                const SizedBox(height: 16),
                _buildLogs(),
                const SizedBox(height: 24),
                Center(
                  child: GradientButton(
                    label: _isRunning ? 'Retrying...' : 'Test Auto Retry',
                    icon: Icons.play_arrow_rounded,
                    gradient: AppColors.warmGradient,
                    isLoading: _isRunning,
                    onPressed: _isRunning ? null : _runWithRetry,
                  ),
                ),
                const SizedBox(height: 24),
                LiveCodePreview(
                  title: 'Auto Retry Pattern',
                  language: 'dart',
                  code:
                      '''Future<T> executeWithRetry<T>(Future<T> Function() request, {int maxRetries = 3}) async {
  int attempts = 0;
  while (true) {
    try {
      return await request();
    } catch (e) {
      attempts++;
      if (attempts > maxRetries) rethrow;
      await Future.delayed(Duration(milliseconds: 500 * attempts));
    }
  }
}''',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: AppTextStyles.titleMedium),
          const SizedBox(height: 16),
          Row(children: [
            const Text('Max Retries:'),
            const Spacer(),
            DropdownButton<int>(
              value: _maxRetries,
              items: [1, 2, 3, 4, 5]
                  .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                  .toList(),
              onChanged: (value) => _controller.setMaxRetries(value!),
            ),
          ]),
          Row(children: [
            const Text('Simulate Failure:'),
            const Spacer(),
            Switch(
                value: _simulateFailure,
                onChanged: _controller.setSimulateFailure),
          ]),
          if (_simulateFailure)
            Row(children: [
              const Text('Fail until attempt:'),
              const Spacer(),
              DropdownButton<int>(
                value: _failUntilAttempt,
                items: [1, 2, 3, 4]
                    .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                    .toList(),
                onChanged: (value) => _controller.setFailUntilAttempt(value!),
              ),
            ]),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: AppColors.warning)),
        const SizedBox(width: 16),
        Text('Attempt $_currentAttempt/$_maxRetries',
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _buildLogs() {
    if (_logs.isEmpty) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('Logs',
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.w600)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white54, size: 18),
              onPressed: _controller.clearLogs,
            ),
          ]),
          const SizedBox(height: 8),
          ..._logs.map((log) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Icon(log.icon, color: log.color, size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(log.message,
                          style: TextStyle(
                              color: log.color,
                              fontSize: 12,
                              fontFamily: 'monospace'))),
                ]),
              )),
        ],
      ),
    );
  }
}

