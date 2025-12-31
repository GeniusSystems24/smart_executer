import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

import '../core/app_theme.dart';
import '../core/widgets.dart';

/// Basic usage examples page.
class BasicUsagePage extends StatefulWidget {
  const BasicUsagePage({super.key});

  @override
  State<BasicUsagePage> createState() => _BasicUsagePageState();
}

class _BasicUsagePageState extends State<BasicUsagePage> {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
  ));

  String? _result;
  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: GradientHeader(
              title: 'Basic Usage',
              subtitle: 'Execute operations with loading dialogs and result handling',
              icon: Icons.play_circle_outline,
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Result Card
                if (_result != null) ...[
                  ResultCard(
                    content: _result!,
                    isError: _isError,
                    onClear: () => setState(() => _result = null),
                  ),
                  const SizedBox(height: 24),
                ],

                // Run Operations
                DemoSection(
                  title: 'Run Operations',
                  description: 'Execute with automatic loading dialog',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DemoButton(
                              label: 'With Dialog',
                              icon: Icons.play_arrow,
                              onPressed: _runWithDialog,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DemoButton(
                              label: 'Background',
                              icon: Icons.cloud_sync,
                              onPressed: _runInBackground,
                              isOutlined: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  code: '''await SmartExecuter.run(
  request: () => dio.get('/posts/1'),
  context: context,
);''',
                ),

                // Result Pattern
                DemoSection(
                  title: 'Result Pattern',
                  description: 'Type-safe success and failure handling',
                  child: Row(
                    children: [
                      Expanded(
                        child: DemoButton(
                          label: 'Execute',
                          icon: Icons.check_circle,
                          color: AppColors.success,
                          onPressed: _executeWithResult,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DemoButton(
                          label: 'Handle Failure',
                          icon: Icons.error_outline,
                          color: AppColors.error,
                          onPressed: _handleFailure,
                        ),
                      ),
                    ],
                  ),
                  code: '''final result = await SmartExecuter.execute<Response>(
  () => dio.get('/posts/1'),
);

switch (result) {
  case Success(:final data):
    print('Got: \${data.data}');
  case Failure(:final exception):
    print('Error: \${exception.message}');
}''',
                ),

                // With Metadata
                DemoSection(
                  title: 'With Metadata',
                  description: 'Attach debugging information to operations',
                  child: DemoButton(
                    label: 'Run with Metadata',
                    icon: Icons.data_object,
                    color: AppColors.accent,
                    onPressed: _runWithMetadata,
                  ),
                  code: '''await SmartExecuter.run(
  request: () => dio.get('/posts/1'),
  context: context,
  options: const ExecuterOptions(
    operationName: 'fetchPost',
    metadata: {
      'userId': 'user_123',
      'screen': 'home',
    },
  ),
);''',
                ),

                // Connectivity
                DemoSection(
                  title: 'Connectivity',
                  description: 'Check connection before making requests',
                  child: Row(
                    children: [
                      Expanded(
                        child: DemoButton(
                          label: 'Check',
                          icon: Icons.signal_cellular_alt,
                          onPressed: _checkConnection,
                          isOutlined: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DemoButton(
                          label: 'With Check',
                          icon: Icons.network_check,
                          onPressed: _runWithConnectionCheck,
                        ),
                      ),
                    ],
                  ),
                  code: '''final hasConnection = await ConnectivityChecker.hasConnection();

await SmartExecuter.run(
  request: () => dio.get('/posts/1'),
  context: context,
  options: const ExecuterOptions(checkConnection: true),
  onConnectionError: () async {
    print('No connection');
  },
);''',
                ),

                // Snack Bars
                DemoSection(
                  title: 'Snack Bars',
                  description: 'Show success and error notifications',
                  child: Row(
                    children: [
                      Expanded(
                        child: DemoButton(
                          label: 'Success',
                          icon: Icons.check,
                          color: AppColors.success,
                          onPressed: _showSuccessSnackBar,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DemoButton(
                          label: 'Error',
                          icon: Icons.error,
                          color: AppColors.error,
                          onPressed: _showErrorSnackBar,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _setResult(String result, {bool isError = false}) {
    setState(() {
      _result = result;
      _isError = isError;
    });
  }

  Future<void> _runWithDialog() async {
    final result = await SmartExecuter.run(
      request: () => _dio.get('/posts/1'),
      context: context,
    );

    if (result != null) {
      _setResult('Title: ${result.data['title']}');
    }
  }

  Future<void> _runInBackground() async {
    _setResult('Loading in background...');

    final result = await SmartExecuter.inBackground(
      request: () => _dio.get('/posts/2'),
      context: context,
    );

    if (result != null) {
      _setResult('Background result - Title: ${result.data['title']}');
    }
  }

  Future<void> _executeWithResult() async {
    final result = await SmartExecuter.execute<Response>(
      () => _dio.get('/posts/3'),
    );

    switch (result) {
      case Success(:final data):
        _setResult('Success! Title: ${data.data['title']}');
      case Failure(:final exception):
        _setResult('Failed: ${exception.message}', isError: true);
    }
  }

  Future<void> _handleFailure() async {
    final result = await SmartExecuter.execute<Response>(
      () => _dio.get('/posts/invalid-id'),
    );

    final message = result.fold(
      onSuccess: (data) => 'Got: ${data.data}',
      onFailure: (e) => 'Error handled: ${e.message}',
    );

    _setResult(message, isError: result is Failure);
  }

  Future<void> _runWithMetadata() async {
    await SmartExecuter.run(
      request: () => _dio.get('/posts/5'),
      context: context,
      options: const ExecuterOptions(
        operationName: 'fetchPost',
        metadata: {
          'userId': 'user_123',
          'screen': 'home',
          'action': 'view_post',
        },
      ),
      onSuccess: (response) async {
        _setResult('''Success with metadata!
Title: ${response.data?['title']}

Metadata attached:
• operationName: fetchPost
• userId: user_123
• screen: home''');
      },
      onError: (exception) async {
        _setResult('''Error with metadata:
${exception.message}

Metadata: ${exception.metadata.toMap()}''', isError: true);
      },
    );
  }

  Future<void> _checkConnection() async {
    final hasConnection = await ConnectivityChecker.hasConnection();
    final isWifi = await ConnectivityChecker.isConnectedViaWifi();
    final isMobile = await ConnectivityChecker.isConnectedViaMobile();

    _setResult('''Connection Status:
• Has Connection: $hasConnection
• WiFi: $isWifi
• Mobile: $isMobile''');
  }

  Future<void> _runWithConnectionCheck() async {
    await SmartExecuter.run(
      request: () => _dio.get('/posts/5'),
      context: context,
      options: const ExecuterOptions(checkConnection: true),
      onConnectionError: () async {
        _setResult('No connection - request blocked', isError: true);
      },
      onSuccess: (response) async {
        _setResult('Connected and got: ${response.data?['title']}');
      },
    );
  }

  void _showSuccessSnackBar() {
    SmartSnackBars.showSuccess(context, 'Operation completed successfully!');
  }

  void _showErrorSnackBar() {
    SmartSnackBars.showError(
      context,
      const ConnectionException('Sample connection error'),
    );
  }
}
