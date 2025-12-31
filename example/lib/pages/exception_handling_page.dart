import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

/// Exception handling showcase page.
class ExceptionHandlingPage extends StatefulWidget {
  const ExceptionHandlingPage({super.key});

  @override
  State<ExceptionHandlingPage> createState() => _ExceptionHandlingPageState();
}

class _ExceptionHandlingPageState extends State<ExceptionHandlingPage> {
  // ignore: unused_field
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
