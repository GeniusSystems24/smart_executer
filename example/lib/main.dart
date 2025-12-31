import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

void main() {
  // Initialize SmartExecuter configuration
  SmartExecuterConfig.initialize(
    enableLogging: kDebugMode,
    defaultErrorMessage: 'Something went wrong. Please try again.',
    noConnectionMessage: 'No internet connection. Please check your network.',
    sessionExpiredMessage: 'Your session has expired. Please sign in again.',
    sessionExpiredTitle: 'Session Expired',
    maxRetries: 2,
    retryDelay: const Duration(seconds: 1),
    checkConnectionByDefault: false,
    globalErrorHandler: (exception) async {
      debugPrint('Global error: ${exception.message}');
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Executer Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
  ));

  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Executer Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Result display
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Result:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    _result.isEmpty ? 'No result yet' : _result,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Section: Basic Usage
            _buildSection(
              title: 'Basic Usage',
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

            // Section: Result Pattern
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

            // Section: Error Handling
            _buildSection(
              title: 'Error Handling',
              children: [
                _buildButton(
                  label: 'Simulate Network Error',
                  icon: Icons.wifi_off,
                  onPressed: _simulateNetworkError,
                ),
                _buildButton(
                  label: 'Simulate Server Error',
                  icon: Icons.cloud_off,
                  onPressed: _simulateServerError,
                ),
                _buildButton(
                  label: 'Simulate Timeout',
                  icon: Icons.timer_off,
                  onPressed: _simulateTimeout,
                ),
              ],
            ),

            // Section: Callbacks
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

            // Section: Connectivity
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

            // Section: Snack Bars
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
                _buildButton(
                  label: 'Show Custom Snack Bar',
                  icon: Icons.info,
                  color: Colors.orange,
                  onPressed: _showCustomSnackBar,
                ),
              ],
            ),
          ],
        ),
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

  // Basic Usage Examples

  Future<void> _runWithDialog() async {
    final result = await SmartExecuter.run(
      () => _dio.get('/posts/1'),
      context: context,
    );

    if (result != null) {
      setState(() {
        _result = 'Title: ${result.data['title']}';
      });
    }
  }

  Future<void> _runInBackground() async {
    setState(() => _result = 'Loading in background...');

    final result = await SmartExecuter.inBackground(
      () => _dio.get('/posts/2'),
      context: context,
    );

    if (result != null) {
      setState(() {
        _result = 'Background result - Title: ${result.data['title']}';
      });
    }
  }

  // Result Pattern Examples

  Future<void> _executeWithResult() async {
    final result = await SmartExecuter.execute(
      () => _dio.get('/posts/3'),
    );

    switch (result) {
      case Success(:final data):
        setState(() {
          _result = 'Success! Title: ${data.data['title']}';
        });
      case Failure(:final exception):
        setState(() {
          _result = 'Failed: ${exception.message}';
        });
    }
  }

  Future<void> _handleFailure() async {
    final result = await SmartExecuter.execute(
      () => _dio.get('/posts/invalid-id'),
    );

    final message = result.fold(
      onSuccess: (data) => 'Got: ${data.data}',
      onFailure: (e) => 'Error handled: ${e.message}',
    );

    setState(() => _result = message);
  }

  // Error Handling Examples

  Future<void> _simulateNetworkError() async {
    await SmartExecuter.run(
      () => _dio.get(
        '/posts/1',
        options: Options(
          extra: {'simulate_network_error': true},
        ),
      ),
      context: context,
      onConnectionError: () async {
        setState(() => _result = 'Connection error callback triggered');
      },
      onError: (exception) async {
        setState(() => _result = 'Error: ${exception.message}');
      },
    );
  }

  Future<void> _simulateServerError() async {
    await SmartExecuter.run(
      () => _dio.get('/posts/999999'),
      context: context,
      onResponseError: () async {
        setState(() => _result = 'Server error callback triggered');
      },
    );
  }

  Future<void> _simulateTimeout() async {
    final dio = Dio(BaseOptions(
      baseUrl: 'https://httpbin.org',
      connectTimeout: const Duration(milliseconds: 100),
    ));

    await SmartExecuter.run(
      () => dio.get('/delay/5'),
      context: context,
      onConnectTimeout: () async {
        setState(() => _result = 'Timeout callback triggered');
      },
    );
  }

  // Callbacks Example

  Future<void> _runWithCallbacks() async {
    await SmartExecuter.run(
      () => _dio.get('/posts/4'),
      context: context,
      onSuccess: (response) async {
        setState(() {
          _result = 'onSuccess: ${response.data['title']}';
        });
        SmartSnackBars.showSuccess(context, 'Request successful!');
      },
      onError: (exception) async {
        setState(() {
          _result = 'onError: ${exception.message}';
        });
      },
    );
  }

  // Connectivity Examples

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
      () => _dio.get('/posts/5'),
      context: context,
      options: const ExecuterOptions(
        checkConnection: true,
      ),
      onConnectionError: () async {
        setState(() => _result = 'No connection - request blocked');
      },
      onSuccess: (response) async {
        setState(() {
          _result = 'Connected and got: ${response.data['title']}';
        });
      },
    );
  }

  // Snack Bar Examples

  void _showSuccessSnackBar() {
    SmartSnackBars.showSuccess(
      context,
      'Operation completed successfully!',
    );
  }

  void _showErrorSnackBar() {
    SmartSnackBars.showError(
      context,
      const ConnectionException('Sample connection error'),
    );
  }

  void _showCustomSnackBar() {
    SmartSnackBars.show(
      context,
      'This is a custom message',
      backgroundColor: Colors.orange,
      icon: Icons.warning,
    );
  }
}
