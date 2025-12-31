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
      if (exception.metadata.hasData) {
        debugPrint('Metadata: ${exception.metadata.toMap()}');
      }
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
      home: const MainNavigationPage(),
    );
  }
}

/// Main navigation page with bottom navigation bar.
class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    BasicUsagePage(),
    StatusCardsPage(),
    LoadingDialogsPage(),
    ExceptionHandlingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Basic',
          ),
          NavigationDestination(
            icon: Icon(Icons.credit_card_outlined),
            selectedIcon: Icon(Icons.credit_card),
            label: 'Cards',
          ),
          NavigationDestination(
            icon: Icon(Icons.hourglass_empty),
            selectedIcon: Icon(Icons.hourglass_full),
            label: 'Loading',
          ),
          NavigationDestination(
            icon: Icon(Icons.bug_report_outlined),
            selectedIcon: Icon(Icons.bug_report),
            label: 'Errors',
          ),
        ],
      ),
    );
  }
}

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
            // Result display
            _buildResultCard(),
            const SizedBox(height: 24.0),

            // Section: Basic Usage
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

            // Section: With Metadata
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

/// Status cards showcase page.
class StatusCardsPage extends StatelessWidget {
  const StatusCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Cards'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        children: [
          _buildSectionTitle(context, 'Basic Status Cards'),

          // Error Card
          SmartErrorCard(
            title: 'Something went wrong',
            message: 'Please try again later',
            action: 'Retry',
            onActionPressed: () => _showSnackBar(context, 'Retry pressed'),
          ),

          // Success Card
          SmartSuccessCard(
            title: 'Success!',
            message: 'Your order has been placed successfully',
            action: 'Continue',
            onActionPressed: () => _showSnackBar(context, 'Continue pressed'),
          ),

          // Warning Card
          SmartWarningCard(
            title: 'Warning',
            message: 'Your session will expire in 5 minutes',
            action: 'Extend Session',
            onActionPressed: () => _showSnackBar(context, 'Extend pressed'),
          ),

          // Info Card
          SmartInfoCard(
            title: 'Did you know?',
            message: 'You can swipe to dismiss notifications',
            action: 'Got it',
            onActionPressed: () => _showSnackBar(context, 'Got it pressed'),
          ),

          // Empty Card
          SmartEmptyCard(
            title: 'No items yet',
            message: 'Add your first item to get started',
            action: 'Add Item',
            onActionPressed: () => _showSnackBar(context, 'Add pressed'),
          ),

          // Loading Card
          const SmartLoadingCard(
            title: 'Loading...',
            message: 'Please wait while we fetch your data',
          ),

          _buildSectionTitle(context, 'Pre-configured Cards'),

          // Offline Card
          SmartOfflineCard(
            onActionPressed: () => _showSnackBar(context, 'Retrying...'),
          ),

          // Session Expired Card
          SmartSessionExpiredCard(
            onActionPressed: () => _showSnackBar(context, 'Navigate to login'),
          ),

          // Timeout Card
          SmartTimeoutCard(
            onActionPressed: () => _showSnackBar(context, 'Retrying...'),
          ),

          // Server Error Card
          SmartServerErrorCard(
            onActionPressed: () => _showSnackBar(context, 'Retrying...'),
            onSecondaryActionPressed: () =>
                _showSnackBar(context, 'Contact support'),
          ),

          // Maintenance Card
          const SmartMaintenanceCard(),

          // Permission Denied Card
          SmartPermissionDeniedCard(
            permission: 'Camera',
            onActionPressed: () => _showSnackBar(context, 'Requesting...'),
            onSecondaryActionPressed: () =>
                _showSnackBar(context, 'Open settings'),
          ),

          // Not Found Card
          SmartNotFoundCard(
            itemName: 'Product',
            onActionPressed: () => _showSnackBar(context, 'Go back'),
          ),

          _buildSectionTitle(context, 'From Exception'),

          // Card from exception
          SmartErrorCard.fromException(
            const ConnectionException('Unable to connect to server'),
            action: 'Retry',
            onActionPressed: () => _showSnackBar(context, 'Retrying...'),
          ),

          SmartErrorCard.fromException(
            const SessionExpiredException(),
            action: 'Sign In',
            onActionPressed: () => _showSnackBar(context, 'Sign in'),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}

/// Loading dialogs showcase page.
class LoadingDialogsPage extends StatelessWidget {
  const LoadingDialogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loading Dialogs'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSection(
            context,
            title: 'Standard Loading Dialog',
            description: 'Shows a circular progress indicator with message',
            child: ElevatedButton.icon(
              onPressed: () => _showLoadingDialog(context),
              icon: const Icon(Icons.hourglass_empty),
              label: const Text('Show Loading Dialog'),
            ),
          ),

          _buildSection(
            context,
            title: 'Progress Dialog',
            description: 'Shows linear progress with percentage',
            child: ElevatedButton.icon(
              onPressed: () => _showProgressDialog(context),
              icon: const Icon(Icons.trending_up),
              label: const Text('Show Progress Dialog'),
            ),
          ),

          _buildSection(
            context,
            title: 'Loading Overlay',
            description: 'Minimal fullscreen overlay',
            child: ElevatedButton.icon(
              onPressed: () => _showLoadingOverlay(context),
              icon: const Icon(Icons.layers),
              label: const Text('Show Loading Overlay'),
            ),
          ),

          _buildSection(
            context,
            title: 'Custom Loading',
            description: 'Loading dialog with custom widget',
            child: ElevatedButton.icon(
              onPressed: () => _showCustomLoading(context),
              icon: const Icon(Icons.brush),
              label: const Text('Show Custom Loading'),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Preview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          // Inline preview
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: SmartLoadingDialog(message: 'Loading preview...'),
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: SmartProgressDialog(
                progress: 0.65,
                message: 'Uploading file...',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String description,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: child),
        ],
      ),
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const SmartLoadingDialog(message: 'Please wait...'),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  void _showProgressDialog(BuildContext context) {
    double progress = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // Simulate progress
            if (progress < 1.0) {
              Future.delayed(const Duration(milliseconds: 100), () {
                if (progress < 1.0) {
                  setDialogState(() => progress += 0.05);
                } else {
                  Navigator.of(dialogContext).pop();
                }
              });
            } else {
              Future.delayed(const Duration(milliseconds: 300), () {
                Navigator.of(dialogContext).pop();
              });
            }

            return SmartProgressDialog(
              progress: progress,
              message: 'Uploading... ${(progress * 100).toInt()}%',
            );
          },
        );
      },
    );
  }

  void _showLoadingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (_) => const SmartLoadingOverlay(),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  void _showCustomLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.rocket_launch, size: 48, color: Colors.blue),
              ),
              const SizedBox(height: 16),
              const Text(
                'Launching...',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }
}

/// Exception handling showcase page.
class ExceptionHandlingPage extends StatefulWidget {
  const ExceptionHandlingPage({super.key});

  @override
  State<ExceptionHandlingPage> createState() => _ExceptionHandlingPageState();
}

class _ExceptionHandlingPageState extends State<ExceptionHandlingPage> {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
  ));

  SmartException? _lastException;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exception Handling'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (_lastException != null) ...[
            _buildExceptionCard(),
            const SizedBox(height: 24),
          ],

          Text(
            'Simulate Errors',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          _buildErrorButton(
            'Connection Error',
            Icons.wifi_off,
            Colors.red,
            _simulateConnectionError,
          ),

          _buildErrorButton(
            'Server Error (500)',
            Icons.cloud_off,
            Colors.orange,
            _simulateServerError,
          ),

          _buildErrorButton(
            'Not Found (404)',
            Icons.search_off,
            Colors.grey,
            _simulateNotFound,
          ),

          _buildErrorButton(
            'Connection Timeout',
            Icons.timer_off,
            Colors.purple,
            _simulateTimeout,
          ),

          _buildErrorButton(
            'Session Expired (401)',
            Icons.lock_clock,
            Colors.amber,
            _simulateSessionExpired,
          ),

          const SizedBox(height: 24),

          Text(
            'Exception Types',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),

          _buildExceptionTypeCard(
            'ConnectionException',
            'Thrown when there is no internet connection',
            Icons.wifi_off,
          ),
          _buildExceptionTypeCard(
            'ConnectionTimeoutException',
            'Thrown when connection takes too long',
            Icons.timer_off,
          ),
          _buildExceptionTypeCard(
            'SendTimeoutException',
            'Thrown when sending data takes too long',
            Icons.upload,
          ),
          _buildExceptionTypeCard(
            'ReceiveTimeoutException',
            'Thrown when receiving data takes too long',
            Icons.download,
          ),
          _buildExceptionTypeCard(
            'ResponseException',
            'Thrown when server returns an error (4xx, 5xx)',
            Icons.cloud_off,
          ),
          _buildExceptionTypeCard(
            'SessionExpiredException',
            'Thrown when authentication fails (401)',
            Icons.lock_clock,
          ),
          _buildExceptionTypeCard(
            'CancelledException',
            'Thrown when request is cancelled',
            Icons.cancel,
          ),
          _buildExceptionTypeCard(
            'UnknownException',
            'Thrown for unhandled errors',
            Icons.error_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildExceptionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bug_report, color: Colors.red.shade700),
              const SizedBox(width: 8),
              Text(
                'Last Exception',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Type: ${_lastException.runtimeType}',
            style: const TextStyle(fontFamily: 'monospace'),
          ),
          const SizedBox(height: 4),
          Text(
            'Message: ${_lastException!.message}',
            style: const TextStyle(fontFamily: 'monospace'),
          ),
          if (_lastException!.metadata.hasData) ...[
            const SizedBox(height: 8),
            Text(
              'Metadata:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _lastException!.metadata.toMap().entries
                  .map((e) => '  ${e.key}: ${e.value}')
                  .join('\n'),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => setState(() => _lastException = null),
              child: const Text('Clear'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    );
  }

  Widget _buildExceptionTypeCard(String name, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(name, style: const TextStyle(fontFamily: 'monospace')),
        subtitle: Text(description),
      ),
    );
  }

  void _simulateConnectionError() {
    final exception = const ConnectionException('Network unreachable');
    setState(() => _lastException = exception);
    _showExceptionCard(exception);
  }

  void _simulateServerError() {
    final exception = const ResponseException(
      message: 'Internal Server Error',
      statusCode: 500,
    );
    setState(() => _lastException = exception);
    _showExceptionCard(exception);
  }

  void _simulateNotFound() {
    final exception = const ResponseException(
      message: 'Resource not found',
      statusCode: 404,
    );
    setState(() => _lastException = exception);
    _showExceptionCard(exception);
  }

  void _simulateTimeout() {
    final exception = ConnectionTimeoutException(
      'Connection timeout after 30 seconds',
      null,
      null,
      ExceptionMetadata(
        operationName: 'fetchUserData',
        endpoint: '/api/users/123',
        requestMethod: 'GET',
        timestamp: DateTime.now(),
      ),
    );
    setState(() => _lastException = exception);
    _showExceptionCard(exception);
  }

  void _simulateSessionExpired() {
    final exception = SessionExpiredException(
      'Token expired',
      null,
      null,
      ExceptionMetadata(
        operationName: 'refreshToken',
        userId: 'user_456',
        sessionId: 'session_789',
        timestamp: DateTime.now(),
      ),
    );
    setState(() => _lastException = exception);
    _showExceptionCard(exception);
  }

  void _showExceptionCard(SmartException exception) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.only(bottom: 32),
        child: SmartErrorCard.fromException(
          exception,
          action: 'Dismiss',
          onActionPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
