import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

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

  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Usage'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildResultCard(),
            const SizedBox(height: 24.0),
            _buildSection(
              title: 'Run Operations',
              children: [
                _buildButton(
                  label: 'Run with Loading Dialog',
                  icon: Icons.play_arrow,
                  onPressed: _runWithDialog,
                ),
                _buildButton(
                  label: 'Run in Background',
                  icon: Icons.cloud_sync,
                  onPressed: _runInBackground,
                ),
              ],
            ),
            _buildSection(
              title: 'Result Pattern',
              children: [
                _buildButton(
                  label: 'Execute with Result',
                  icon: Icons.check_circle,
                  onPressed: _executeWithResult,
                ),
                _buildButton(
                  label: 'Handle Failure',
                  icon: Icons.error_outline,
                  onPressed: _handleFailure,
                ),
              ],
            ),
            _buildSection(
              title: 'With Metadata',
              children: [
                _buildButton(
                  label: 'Run with Operation Metadata',
                  icon: Icons.data_object,
                  onPressed: _runWithMetadata,
                ),
              ],
            ),
            _buildSection(
              title: 'With Callbacks',
              children: [
                _buildButton(
                  label: 'Run with Callbacks',
                  icon: Icons.call_received,
                  onPressed: _runWithCallbacks,
                ),
              ],
            ),
            _buildSection(
              title: 'Connectivity',
              children: [
                _buildButton(
                  label: 'Check Connection',
                  icon: Icons.signal_cellular_alt,
                  onPressed: _checkConnection,
                ),
                _buildButton(
                  label: 'Run with Connection Check',
                  icon: Icons.network_check,
                  onPressed: _runWithConnectionCheck,
                ),
              ],
            ),
            _buildSection(
              title: 'Snack Bars',
              children: [
                _buildButton(
                  label: 'Show Success Snack Bar',
                  icon: Icons.check,
                  color: Colors.green,
                  onPressed: _showSuccessSnackBar,
                ),
                _buildButton(
                  label: 'Show Error Snack Bar',
                  icon: Icons.error,
                  color: Colors.red,
                  onPressed: _showErrorSnackBar,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Result:', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8.0),
          Text(
            _result.isEmpty ? 'No result yet' : _result,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12.0),
        ...children,
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: color != null ? Colors.white : null,
          minimumSize: const Size(double.infinity, 48.0),
        ),
      ),
    );
  }

  Future<void> _runWithDialog() async {
    final result = await SmartExecuter.run(
      request: () => _dio.get('/posts/1'),
      context: context,
    );

    if (result != null) {
      setState(() => _result = 'Title: ${result.data['title']}');
    }
  }

  Future<void> _runInBackground() async {
    setState(() => _result = 'Loading in background...');

    final result = await SmartExecuter.inBackground(
      request: () => _dio.get('/posts/2'),
      context: context,
    );

    if (result != null) {
      setState(() => _result = 'Background result - Title: ${result.data['title']}');
    }
  }

  Future<void> _executeWithResult() async {
    final result = await SmartExecuter.execute<Response>(
      () => _dio.get('/posts/3'),
    );

    switch (result) {
      case Success(:final data):
        setState(() => _result = 'Success! Title: ${data.data['title']}');
      case Failure(:final exception):
        setState(() => _result = 'Failed: ${exception.message}');
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

    setState(() => _result = message);
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
        setState(() {
          _result = '''
Success with metadata!
Title: ${response.data?['title']}

Metadata attached to operation:
- operationName: fetchPost
- userId: user_123
- screen: home
''';
        });
      },
      onError: (exception) async {
        setState(() {
          _result = '''
Error with metadata:
${exception.message}

Metadata: ${exception.metadata.toMap()}
''';
        });
      },
    );
  }

  Future<void> _runWithCallbacks() async {
    await SmartExecuter.run(
      request: () => _dio.get('/posts/4'),
      context: context,
      onSuccess: (response) async {
        setState(() => _result = 'onSuccess: ${response.data?['title']}');
        SmartSnackBars.showSuccess(context, 'Request successful!');
      },
      onError: (exception) async {
        setState(() => _result = 'onError: ${exception.message}');
      },
    );
  }

  Future<void> _checkConnection() async {
    final hasConnection = await ConnectivityChecker.hasConnection();
    final isWifi = await ConnectivityChecker.isConnectedViaWifi();
    final isMobile = await ConnectivityChecker.isConnectedViaMobile();

    setState(() {
      _result = '''
Connection Status:
  Has Connection: $hasConnection
  WiFi: $isWifi
  Mobile: $isMobile
''';
    });
  }

  Future<void> _runWithConnectionCheck() async {
    await SmartExecuter.run(
      request: () => _dio.get('/posts/5'),
      context: context,
      options: const ExecuterOptions(checkConnection: true),
      onConnectionError: () async {
        setState(() => _result = 'No connection - request blocked');
      },
      onSuccess: (response) async {
        setState(() => _result = 'Connected and got: ${response.data?['title']}');
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
