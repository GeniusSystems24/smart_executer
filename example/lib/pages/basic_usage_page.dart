import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

import '../core/app_theme.dart';
import '../core/premium_widgets.dart';

/// Redesigned Basic Usage page with premium UI
class BasicUsagePage extends StatefulWidget {
  const BasicUsagePage({super.key});

  @override
  State<BasicUsagePage> createState() => _BasicUsagePageState();
}

class _BasicUsagePageState extends State<BasicUsagePage>
    with SingleTickerProviderStateMixin {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));

  String? _result;
  bool _isError = false;
  bool _isLoading = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _setResult(String result, {bool isError = false}) {
    setState(() {
      _result = result;
      _isError = isError;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: PremiumPageHeader(
              title: 'Basic Usage',
              subtitle:
                  'Execute async operations with built-in loading dialogs, error handling, and result patterns',
              icon: Icons.play_circle_rounded,
              gradient: AppColors.primaryGradient,
              actions: [
                GlassCard(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.api_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text('JSONPlaceholder',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ]),
                ),
              ],
            ),
          ),
          // Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Run Operations'),
                  Tab(text: 'Result Pattern'),
                  Tab(text: 'Connectivity'),
                  Tab(text: 'Snack Bars'),
                  Tab(text: 'Error Views'),
                ],
              ),
            ),
          ),
        ],
        body: Column(
          children: [
            // Result Card
            if (_result != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: _buildResultCard(),
              ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRunOperationsTab(),
                  _buildResultPatternTab(),
                  _buildConnectivityTab(),
                  _buildSnackBarsTab(),
                  _buildErrorViewsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          (_isError ? AppColors.error : AppColors.success)
              .withValues(alpha: 0.1),
          (_isError ? AppColors.error : AppColors.success)
              .withValues(alpha: 0.05),
        ]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: (_isError ? AppColors.error : AppColors.success)
                .withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(_isError ? Icons.error_rounded : Icons.check_circle_rounded,
              color: _isError ? AppColors.error : AppColors.success),
          const SizedBox(width: 12),
          Expanded(
            child: Text(_result!,
                style: TextStyle(
                  color: _isError ? AppColors.error : AppColors.success,
                  fontWeight: FontWeight.w500,
                )),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => setState(() => _result = null),
            color: AppColors.textHint,
          ),
        ],
      ),
    );
  }

  Widget _buildRunOperationsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          InteractiveDemoPanel(
            title: 'Run with Loading Dialog',
            description: 'Execute an operation with automatic loading dialog',
            demo: Row(children: [
              Expanded(
                  child: GradientButton(
                label: _isLoading ? 'Loading...' : 'Run Request',
                icon: Icons.play_arrow_rounded,
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _runWithDialog,
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: GradientButton(
                label: 'Background',
                icon: Icons.cloud_sync_rounded,
                gradient: AppColors.accentGradient,
                onPressed: _runInBackground,
              )),
            ]),
            code: '''final response = await SmartExecuter.run(
  request: () => dio.get('/posts/1'),
  context: context,
);

if (response != null) {
  print('Title: \${response.data['title']}');
}''',
          ),
          InteractiveDemoPanel(
            title: 'With Metadata',
            description: 'Attach debugging information to operations',
            demo: GradientButton(
              label: 'Run with Metadata',
              icon: Icons.data_object_rounded,
              gradient: AppColors.coolGradient,
              onPressed: _runWithMetadata,
            ),
            code: '''await SmartExecuter.run(
  request: () => dio.get('/posts/1'),
  context: context,
  options: const ExecuterOptions(
    operationName: 'fetchPost',
    metadata: {'userId': 'user_123', 'screen': 'home'},
  ),
);''',
          ),
        ],
      ),
    );
  }

  Widget _buildResultPatternTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
            ),
            child: Row(children: [
              const Icon(Icons.lightbulb_rounded, color: AppColors.info),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(
                      'The Result pattern provides type-safe handling of success and failure cases using Dart 3 pattern matching.',
                      style: TextStyle(
                          color: AppColors.info.withValues(alpha: 0.9),
                          fontSize: 13))),
            ]),
          ),
          InteractiveDemoPanel(
            title: 'Execute with Result',
            description: 'Type-safe success and failure handling',
            demo: Row(children: [
              Expanded(
                  child: GradientButton(
                label: 'Success',
                icon: Icons.check_circle_rounded,
                gradient: LinearGradient(colors: [
                  AppColors.success,
                  AppColors.success.withValues(alpha: 0.8)
                ]),
                onPressed: _executeWithResult,
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: GradientButton(
                label: 'Failure',
                icon: Icons.error_rounded,
                gradient: LinearGradient(colors: [
                  AppColors.error,
                  AppColors.error.withValues(alpha: 0.8)
                ]),
                onPressed: _handleFailure,
              )),
            ]),
            code: '''final result = await SmartExecuter.execute<Response>(
  () => dio.get('/posts/1'),
);

switch (result) {
  case Success(:final data):
    print('Got: \${data.data}');
  case Failure(:final exception):
    print('Error: \${exception.message}');
}

// Or use fold
result.fold(
  onSuccess: (data) => handleSuccess(data),
  onFailure: (e) => handleError(e),
);''',
          ),
        ],
      ),
    );
  }

  Widget _buildConnectivityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          InteractiveDemoPanel(
            title: 'Check Connection',
            description: 'Check network connectivity before making requests',
            demo: Row(children: [
              Expanded(
                  child: GradientButton(
                label: 'Check Status',
                icon: Icons.signal_cellular_alt_rounded,
                gradient: AppColors.accentGradient,
                onPressed: _checkConnection,
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: GradientButton(
                label: 'With Check',
                icon: Icons.network_check_rounded,
                onPressed: _runWithConnectionCheck,
              )),
            ]),
            code:
                '''final isConnected = await ConnectivityChecker.hasConnection();
final isWifi = await ConnectivityChecker.isConnectedViaWifi();
final isMobile = await ConnectivityChecker.isConnectedViaMobile();

await SmartExecuter.run(
  request: () => dio.get('/posts/1'),
  context: context,
  options: const ExecuterOptions(checkConnection: true),
  onConnectionError: () async {
    showOfflineMessage();
  },
);''',
          ),
        ],
      ),
    );
  }

  Widget _buildSnackBarsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          InteractiveDemoPanel(
            title: 'Success & Error Snackbars',
            description: 'Show notifications for operation results',
            demo: Row(children: [
              Expanded(
                  child: GradientButton(
                label: 'Success',
                icon: Icons.check_rounded,
                gradient: LinearGradient(colors: [
                  AppColors.success,
                  AppColors.success.withValues(alpha: 0.8)
                ]),
                onPressed: () => SmartSnackBars.showSuccess(
                    context, 'Operation completed successfully!'),
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: GradientButton(
                label: 'Error',
                icon: Icons.error_rounded,
                gradient: LinearGradient(colors: [
                  AppColors.error,
                  AppColors.error.withValues(alpha: 0.8)
                ]),
                onPressed: () => SmartSnackBars.showError(
                    context, const ConnectionException('Connection failed')),
              )),
            ]),
            code: '''SmartSnackBars.showSuccess(context, 'Data saved!');

SmartSnackBars.showError(
  context, 
  ConnectionException('No internet'),
);''',
          ),
        ],
      ),
    );
  }

  // Operations
  Future<void> _runWithDialog() async {
    final result = await SmartExecuter.run(
      request: () => _dio.get('/posts/1'),
      context: context,
    );
    if (result != null) {
      _setResult('✓ Title: ${result.data['title']}');
    }
  }

  Future<void> _runInBackground() async {
    _setResult('⏳ Loading in background...');
    final result = await SmartExecuter.inBackground(
      request: () => _dio.get('/posts/2'),
      context: context,
    );
    if (result != null) {
      _setResult('✓ Background: ${result.data['title']}');
    }
  }

  Future<void> _executeWithResult() async {
    final result =
        await SmartExecuter.execute<Response>(() => _dio.get('/posts/3'));
    switch (result) {
      case Success(:final data):
        _setResult('✓ Success: ${data.data['title']}');
      case Failure(:final exception):
        _setResult('✗ Failed: ${exception.message}', isError: true);
    }
  }

  Future<void> _handleFailure() async {
    final result =
        await SmartExecuter.execute<Response>(() => _dio.get('/posts/invalid'));
    result.fold(
      onSuccess: (data) => _setResult('Got: ${data.data}'),
      onFailure: (e) =>
          _setResult('✗ Error handled: ${e.message}', isError: true),
    );
  }

  Future<void> _runWithMetadata() async {
    await SmartExecuter.run(
      request: () => _dio.get('/posts/5'),
      context: context,
      options: const ExecuterOptions(
          operationName: 'fetchPost', metadata: {'userId': 'user_123'}),
      onSuccess: (r) async =>
          _setResult('✓ With metadata: ${r.data?['title']}'),
      onError: (e) async => _setResult(
          '✗ Error: ${e.message}\nMetadata: ${e.metadata.operationName}',
          isError: true),
    );
  }

  Future<void> _checkConnection() async {
    final hasConnection = await ConnectivityChecker.hasConnection();
    final isWifi = await ConnectivityChecker.isConnectedViaWifi();
    final isMobile = await ConnectivityChecker.isConnectedViaMobile();
    _setResult(
        '📶 Connection: $hasConnection\n📡 WiFi: $isWifi\n📱 Mobile: $isMobile');
  }

  Future<void> _runWithConnectionCheck() async {
    await SmartExecuter.run(
      request: () => _dio.get('/posts/5'),
      context: context,
      options: const ExecuterOptions(checkConnection: true),
      onConnectionError: () async =>
          _setResult('📴 No connection', isError: true),
      onSuccess: (r) async => _setResult('✓ Connected: ${r.data?['title']}'),
    );
  }

  Widget _buildErrorViewsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Info card
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.2)),
            ),
            child: Row(children: [
              const Icon(Icons.lightbulb_rounded, color: AppColors.info),
              const SizedBox(width: 12),
              Expanded(
                  child: Text(
                      'Choose how errors are displayed: as a SnackBar (default) or as a Dialog.',
                      style: TextStyle(
                          color: AppColors.info.withValues(alpha: 0.9),
                          fontSize: 13))),
            ]),
          ),
          InteractiveDemoPanel(
            title: 'Error as SnackBar',
            description: 'Default error display at the bottom of the screen',
            demo: GradientButton(
              label: 'Trigger SnackBar Error',
              icon: Icons.notification_important_rounded,
              onPressed: _triggerSnackBarError,
            ),
            code: '''await SmartExecuter.run(
  request: () => dio.get('/invalid'),
  context: context,
  viewType: ErrorViewType.snackBar, // default
);''',
          ),
          InteractiveDemoPanel(
            title: 'Error as Dialog',
            description: 'Show errors in a centered dialog',
            demo: GradientButton(
              label: 'Trigger Dialog Error',
              icon: Icons.error_rounded,
              gradient: AppColors.warmGradient,
              onPressed: _triggerDialogError,
            ),
            code: '''await SmartExecuter.run(
  request: () => dio.get('/invalid'),
  context: context,
  viewType: ErrorViewType.dialog,
);''',
          ),
          InteractiveDemoPanel(
            title: 'Direct Error Dialog',
            description: 'Show SmartErrorDialog directly',
            demo: Row(children: [
              Expanded(
                  child: GradientButton(
                label: 'Connection',
                icon: Icons.wifi_off_rounded,
                gradient: LinearGradient(colors: [
                  AppColors.warning,
                  AppColors.warning.withValues(alpha: 0.8)
                ]),
                onPressed: () => _showDirectDialog(
                    const ConnectionException('No internet connection')),
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: GradientButton(
                label: 'Server Error',
                icon: Icons.cloud_off_rounded,
                gradient: LinearGradient(colors: [
                  AppColors.error,
                  AppColors.error.withValues(alpha: 0.8)
                ]),
                onPressed: () => _showDirectDialog(const ResponseException(
                    message: 'Internal Server Error', statusCode: 500)),
              )),
            ]),
            code: '''showDialog(
  context: context,
  builder: (_) => SmartErrorDialog(
    exception: ConnectionException('No internet'),
  ),
);''',
          ),
        ],
      ),
    );
  }

  Future<void> _triggerSnackBarError() async {
    await SmartExecuter.run(
      request: () => _dio.get('/posts/invalid-path-snackbar'),
      context: context,
      viewType: ErrorViewType.snackBar,
    );
  }

  Future<void> _triggerDialogError() async {
    await SmartExecuter.run(
      request: () => _dio.get('/posts/invalid-path-dialog'),
      context: context,
      viewType: ErrorViewType.dialog,
    );
  }

  void _showDirectDialog(SmartException exception) {
    showDialog(
      context: context,
      builder: (_) => SmartErrorDialog(exception: exception),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: AppColors.background, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
