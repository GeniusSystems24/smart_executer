import 'package:flutter/material.dart';
import 'package:smart_executer_example/features/examples/execution_patterns/debounce_throttle/presentation/controllers/debounce_throttle_controller.dart';

import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/premium_widgets.dart';

class DebounceThrottlePage extends StatefulWidget {
  const DebounceThrottlePage({super.key});
  @override
  State<DebounceThrottlePage> createState() => _DebounceThrottlePageState();
}

class _DebounceThrottlePageState extends State<DebounceThrottlePage> {
  final _searchController = TextEditingController();
  late final DebounceThrottleController _controller;

  List<String> get _normalLogs => _controller.normalLogs;
  List<String> get _debouncedLogs => _controller.debouncedLogs;
  List<String> get _throttledLogs => _controller.throttledLogs;
  int get _normalCount => _controller.normalCount;
  int get _debouncedCount => _controller.debouncedCount;
  int get _throttledCount => _controller.throttledCount;
  int get _debounceMs => _controller.debounceMilliseconds;
  int get _throttleMs => _controller.throttleMilliseconds;

  @override
  void initState() {
    super.initState();
    _controller = DebounceThrottleController()..addListener(_refreshView);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller
      ..removeListener(_refreshView)
      ..dispose();
    super.dispose();
  }

  void _refreshView() {
    if (mounted) setState(() {});
  }

  void _onSearchChanged(String value) => _controller.onSearchChanged(value);

  void _clearLogs() => _controller.clear();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PremiumPageHeader(
              title: 'Debounce & Throttle',
              subtitle: 'Control execution frequency of operations',
              icon: Icons.speed_rounded,
              gradient: AppColors.coolGradient,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSearchField(),
                const SizedBox(height: 20),
                _buildStats(),
                const SizedBox(height: 20),
                _buildComparison(),
                const SizedBox(height: 24),
                LiveCodePreview(
                  title: 'Implementation',
                  language: 'dart',
                  code: '''// Debounce - waits until user stops typing
Timer? _debounceTimer;
void onSearchDebounced(String value) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(Duration(milliseconds: 500), () {
    // Execute only after 500ms of no input
    performSearch(value);
  });
}

// Throttle - executes at most once per interval
DateTime? _lastExecution;
void onSearchThrottled(String value) {
  final now = DateTime.now();
  if (_lastExecution == null || 
      now.difference(_lastExecution!).inMilliseconds >= 1000) {
    _lastExecution = now;
    performSearch(value); // Execute at most once per second
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

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text('Type to see the difference',
                style: AppTextStyles.titleMedium),
            const Spacer(),
            IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _clearLogs();
                }),
          ]),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Start typing...',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(child: _StatBox('Normal', _normalCount, Colors.grey)),
        const SizedBox(width: 12),
        Expanded(
            child: _StatBox('Debounced', _debouncedCount, AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(
            child: _StatBox('Throttled', _throttledCount, AppColors.accent)),
      ],
    );
  }

  Widget _buildComparison() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: _LogPanel(
                'Normal\n(Every keystroke)', _normalLogs, Colors.grey)),
        const SizedBox(width: 12),
        Expanded(
            child: _LogPanel('Debounced\n(After ${_debounceMs}ms pause)',
                _debouncedLogs, AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(
            child: _LogPanel('Throttled\n(Max 1/${_throttleMs}ms)',
                _throttledLogs, AppColors.accent)),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatBox(this.label, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(children: [
        Text('$count',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ]),
    );
  }
}

class _LogPanel extends StatelessWidget {
  final String title;
  final List<String> logs;
  final Color color;
  const _LogPanel(this.title, this.logs, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          const SizedBox(height: 8),
          Expanded(
            child: logs.isEmpty
                ? Center(
                    child: Text('No calls yet',
                        style:
                            TextStyle(color: AppColors.textHint, fontSize: 11)))
                : ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (_, i) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(logs[logs.length - 1 - i],
                          style: const TextStyle(
                              fontSize: 10, fontFamily: 'monospace')),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
