import 'package:flutter/material.dart';
import 'package:smart_executer_example/features/examples/connectivity/offline_mode/domain/models/offline_models.dart';
import 'package:smart_executer_example/features/examples/connectivity/offline_mode/presentation/controllers/offline_mode_controller.dart';
import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/premium_widgets.dart';

class OfflineModePage extends StatefulWidget {
  const OfflineModePage({super.key});
  @override
  State<OfflineModePage> createState() => _OfflineModePageState();
}

class _OfflineModePageState extends State<OfflineModePage> {
  late final OfflineModeController _controller;

  bool get _isOnline => _controller.isOnline;
  bool get _isChecking => _controller.isChecking;
  List<String> get _cachedItems => _controller.cachedItems;
  List<PendingAction> get _pendingActions => _controller.pendingActions;

  @override
  void initState() {
    super.initState();
    _controller = OfflineModeController()..addListener(_refreshView);
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

  Future<void> _checkConnection() async {
    final status = await _controller.checkConnection();
    if (!mounted) return;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Connection Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StatusRow('Internet', status.hasConnection),
            _StatusRow('WiFi', status.isWifi),
            _StatusRow('Mobile Data', status.isMobile),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _simulateOffline() {
    _controller.simulateOffline();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📴 Simulating offline mode'),
        backgroundColor: AppColors.warning,
      ),
    );
  }

  Future<void> _simulateOnline() async {
    _controller.simulateOnline();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('📶 Back online'),
        backgroundColor: AppColors.success,
      ),
    );
    if (_pendingActions.isNotEmpty) await _syncPendingActions();
  }

  void _addPendingAction(String action) {
    _controller.addPendingAction(action);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action queued: $action'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  Future<void> _syncPendingActions() async {
    if (_pendingActions.isEmpty) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text('Syncing ${_pendingActions.length} pending actions...'),
        backgroundColor: AppColors.primary,
      ),
    );
    final count = await _controller.syncPendingActions();
    if (!mounted || count == 0) return;
    messenger.showSnackBar(
      SnackBar(
        content: Text('✓ Synced $count actions'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: PremiumPageHeader(
              title: 'Offline Mode',
              subtitle: 'Handle offline scenarios gracefully',
              icon: Icons.wifi_off_rounded,
              gradient:
                  _isOnline ? AppColors.accentGradient : AppColors.warmGradient,
              trailing: _buildStatusBadge(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildConnectionCard(),
                const SizedBox(height: 20),
                _buildCachedDataSection(),
                const SizedBox(height: 20),
                _buildPendingActionsSection(),
                const SizedBox(height: 20),
                _buildActionsSection(),
                const SizedBox(height: 24),
                LiveCodePreview(
                  title: 'Offline Pattern',
                  language: 'dart',
                  code: '''// Check connection before request
Future<void> fetchData() async {
  if (!await ConnectivityChecker.hasConnection()) {
    // Use cached data
    return loadFromCache();
  }
  
  // Make network request
  final result = await SmartExecuter.run(
    request: () => api.getData(),
    context: context,
    onConnectionError: () async {
      // Fallback to cache
      loadFromCache();
    },
  );
  
  // Cache successful response
  if (result != null) {
    saveToCache(result);
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

  Widget _buildStatusBadge() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: _isOnline ? AppColors.success : AppColors.error,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: (_isOnline ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.5),
                  blurRadius: 4)
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(_isOnline ? 'Online' : 'Offline',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _buildConnectionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          (_isOnline ? AppColors.success : AppColors.error)
              .withValues(alpha: 0.1),
          (_isOnline ? AppColors.success : AppColors.error)
              .withValues(alpha: 0.05),
        ]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: (_isOnline ? AppColors.success : AppColors.error)
                .withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        Icon(_isOnline ? Icons.wifi : Icons.wifi_off,
            color: _isOnline ? AppColors.success : AppColors.error, size: 40),
        const SizedBox(width: 16),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(_isOnline ? 'Connected' : 'No Connection',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _isOnline ? AppColors.success : AppColors.error)),
          Text(_isOnline ? 'All features available' : 'Using cached data',
              style: AppTextStyles.bodyMedium),
        ])),
        ElevatedButton(
          onPressed: _isChecking ? null : _checkConnection,
          child: _isChecking
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Check'),
        ),
      ]),
    );
  }

  Widget _buildCachedDataSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.storage, color: AppColors.primary),
          const SizedBox(width: 10),
          Text('Cached Data', style: AppTextStyles.titleMedium),
          const Spacer(),
          Text('${_cachedItems.length} items',
              style: TextStyle(color: AppColors.textHint, fontSize: 12)),
        ]),
        const Divider(height: 24),
        ..._cachedItems.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                const Icon(Icons.check_circle,
                    color: AppColors.success, size: 18),
                const SizedBox(width: 10),
                Text(item),
              ]),
            )),
      ]),
    );
  }

  Widget _buildPendingActionsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.pending_actions, color: AppColors.warning),
          const SizedBox(width: 10),
          Text('Pending Actions', style: AppTextStyles.titleMedium),
          const Spacer(),
          if (_pendingActions.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: AppColors.warning,
                  borderRadius: BorderRadius.circular(10)),
              child: Text('${_pendingActions.length}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
        ]),
        const Divider(height: 24),
        if (_pendingActions.isEmpty)
          const Center(
              child: Text('No pending actions',
                  style: TextStyle(color: AppColors.textHint)))
        else
          ..._pendingActions.map((action) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(children: [
                  const Icon(Icons.schedule,
                      color: AppColors.warning, size: 18),
                  const SizedBox(width: 10),
                  Expanded(child: Text(action.action)),
                  Text(_formatTime(action.timestamp),
                      style:
                          TextStyle(color: AppColors.textHint, fontSize: 11)),
                ]),
              )),
      ]),
    );
  }

  Widget _buildActionsSection() {
    return Wrap(spacing: 12, runSpacing: 12, children: [
      GradientButton(
          label: 'Simulate Offline',
          icon: Icons.wifi_off,
          gradient: AppColors.warmGradient,
          isSmall: true,
          onPressed: _isOnline ? _simulateOffline : null),
      GradientButton(
          label: 'Go Online',
          icon: Icons.wifi,
          gradient: AppColors.accentGradient,
          isSmall: true,
          onPressed: !_isOnline ? _simulateOnline : null),
      GradientButton(
          label: 'Queue Action',
          icon: Icons.add,
          isSmall: true,
          onPressed: () =>
              _addPendingAction('Action ${_pendingActions.length + 1}')),
      if (_pendingActions.isNotEmpty && _isOnline)
        GradientButton(
            label: 'Sync Now',
            icon: Icons.sync,
            gradient: AppColors.coolGradient,
            isSmall: true,
            onPressed: _syncPendingActions),
    ]);
  }

  String _formatTime(DateTime time) =>
      '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
}

class _StatusRow extends StatelessWidget {
  final String label;
  final bool status;
  const _StatusRow(this.label, this.status);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Icon(status ? Icons.check_circle : Icons.cancel,
            color: status ? AppColors.success : AppColors.error, size: 20),
        const SizedBox(width: 10),
        Text(label),
        const Spacer(),
        Text(status ? 'Yes' : 'No',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: status ? AppColors.success : AppColors.error)),
      ]),
    );
  }
}
