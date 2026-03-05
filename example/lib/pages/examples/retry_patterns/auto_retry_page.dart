import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import '../../../core/app_theme.dart';
import '../../../core/premium_widgets.dart';

class AutoRetryPage extends StatefulWidget {
  const AutoRetryPage({super.key});
  @override
  State<AutoRetryPage> createState() => _AutoRetryPageState();
}

class _AutoRetryPageState extends State<AutoRetryPage> {
  final _logs = <_Log>[];
  bool _isRunning = false;
  int _maxRetries = 3;
  int _currentAttempt = 0;
  bool _simulateFailure = true;
  int _failUntilAttempt = 2;

  Future<void> _runWithRetry() async {
    setState(() {
      _isRunning = true;
      _logs.clear();
      _currentAttempt = 0;
    });
    _addLog('Starting request with max $_maxRetries retries...', LogType.info);

    int attempts = 0;
    SmartException? lastError;

    while (attempts <= _maxRetries) {
      attempts++;
      setState(() => _currentAttempt = attempts);
      _addLog('Attempt $attempts/$_maxRetries', LogType.info);

      try {
        if (_simulateFailure && attempts < _failUntilAttempt) {
          await Future.delayed(const Duration(milliseconds: 500));
          throw const ConnectionException('Simulated network error');
        }

        final result = await SmartExecuter.execute<Response>(
          () => Dio().get('https://jsonplaceholder.typicode.com/posts/1'),
        );

        result.fold(
          onSuccess: (data) {
            _addLog('✓ Request successful!', LogType.success);
            _addLog('Title: ${data.data['title']}', LogType.success);
          },
          onFailure: (e) => throw e,
        );
        break;
      } catch (e) {
        lastError = e is SmartException ? e : UnknownException(e.toString());
        _addLog(
            '✗ Attempt $attempts failed: ${lastError.message}', LogType.error);

        if (attempts <= _maxRetries) {
          final delay = Duration(milliseconds: 500 * attempts);
          _addLog('Waiting ${delay.inMilliseconds}ms before retry...',
              LogType.warning);
          await Future.delayed(delay);
        }
      }
    }

    if (lastError != null &&
        _logs.any((l) => l.type == LogType.success) == false) {
      _addLog(
          'All $_maxRetries retries exhausted. Final error: ${lastError.message}',
          LogType.error);
    }

    setState(() {
      _isRunning = false;
      _currentAttempt = 0;
    });
  }

  void _addLog(String msg, LogType type) {
    setState(() => _logs.add(_Log(msg, type, DateTime.now())));
  }

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
              onChanged: (v) => setState(() => _maxRetries = v!),
            ),
          ]),
          Row(children: [
            const Text('Simulate Failure:'),
            const Spacer(),
            Switch(
                value: _simulateFailure,
                onChanged: (v) => setState(() => _simulateFailure = v)),
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
                onChanged: (v) => setState(() => _failUntilAttempt = v!),
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
              onPressed: () => setState(() => _logs.clear()),
            ),
          ]),
          const SizedBox(height: 8),
          ..._logs.map((log) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  Icon(log.icon, color: log.color, size: 14),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(log.msg,
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

enum LogType { info, success, warning, error }

class _Log {
  final String msg;
  final LogType type;
  final DateTime time;
  _Log(this.msg, this.type, this.time);

  Color get color => switch (type) {
        LogType.info => Colors.white70,
        LogType.success => AppColors.success,
        LogType.warning => AppColors.warning,
        LogType.error => AppColors.error,
      };

  IconData get icon => switch (type) {
        LogType.info => Icons.info_outline,
        LogType.success => Icons.check_circle_outline,
        LogType.warning => Icons.warning_amber_rounded,
        LogType.error => Icons.error_outline,
      };
}
