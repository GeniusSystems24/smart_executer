import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/features/exception_handling/presentation/controllers/exception_handling_controller.dart';

import 'package:smart_executer_example/app/theme/app_theme.dart';
import 'package:smart_executer_example/shared/presentation/widgets/common_widgets.dart';

/// Exception handling showcase page.
class ExceptionHandlingPage extends StatefulWidget {
  const ExceptionHandlingPage({super.key});

  @override
  State<ExceptionHandlingPage> createState() => _ExceptionHandlingPageState();
}

class _ExceptionHandlingPageState extends State<ExceptionHandlingPage> {
  late final ExceptionHandlingController _controller;

  SmartException? get _lastException => _controller.lastException;

  @override
  void initState() {
    super.initState();
    _controller = ExceptionHandlingController()..addListener(_refreshView);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Header
          const SliverToBoxAdapter(
            child: GradientHeader(
              title: 'Exception Handling',
              subtitle: 'Comprehensive exception handling with metadata',
              icon: Icons.bug_report_outlined,
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Exception Display
                if (_lastException != null) ...[
                  _buildExceptionCard(),
                  const SizedBox(height: 24),
                ],

                // Simulate Errors
                const SectionHeader(
                  title: 'Simulate Errors',
                  subtitle: 'Tap to trigger different exception types',
                ),

                _buildErrorGrid(),

                const SizedBox(height: 24),

                // Exception Types
                const SectionHeader(
                  title: 'Exception Hierarchy',
                  subtitle: 'All SmartException types available',
                ),

                _buildExceptionTypesList(),

                const SizedBox(height: 16),

                // Code Example
                const CodePreview(
                  language: 'dart',
                  code: '''// Using pattern matching
switch (result) {
  case Success(:final data):
    handleSuccess(data);
  case Failure(:final exception):
    switch (exception) {
      case ConnectionException():
        showOfflineUI();
      case SessionExpiredException():
        navigateToLogin();
      case ResponseException(:final statusCode):
        handleHttpError(statusCode);
      default:
        showGenericError();
    }
}''',
                ),

                const SizedBox(height: 24),

                // Metadata Section
                const SectionHeader(
                  title: 'Exception Metadata',
                  subtitle: 'Attach debugging information to exceptions',
                ),

                const CodePreview(
                  language: 'dart',
                  code: '''final exception = ConnectionTimeoutException(
  'Connection timeout',
  null,
  null,
  ExceptionMetadata(
    operationName: 'fetchUserData',
    endpoint: '/api/users/123',
    requestMethod: 'GET',
    userId: 'user_456',
    sessionId: 'session_789',
    timestamp: DateTime.now(),
    extra: {'retryCount': 3},
  ),
);

// Access exception type
print(exception.exceptionType); // SmartExceptionType.response

// Access metadata
print(exception.metadata.operationName);
print(exception.metadata.toMap());''',
                ),

                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExceptionCard() {
    return Card(
      color: AppColors.error.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      Icon(Icons.bug_report, color: AppColors.error, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Last Exception',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _controller.clear,
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppColors.textHint,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildExceptionRow('Type', _lastException.runtimeType.toString()),
            _buildExceptionRow('Message', _lastException!.message),
            if (_lastException!.metadata.hasData) ...[
              const SizedBox(height: 12),
              Text(
                'Metadata',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _lastException!.metadata
                      .toMap()
                      .entries
                      .map((e) => '${e.key}: ${e.value}')
                      .join('\n'),
                  style: AppTextStyles.code.copyWith(fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExceptionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.code.copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorGrid() {
    final errors = [
      _ErrorItem(
        'Connection',
        Icons.wifi_off,
        AppColors.error,
        _simulateConnectionError,
      ),
      _ErrorItem(
        'Server (500)',
        Icons.cloud_off,
        const Color(0xFFF97316),
        _simulateServerError,
      ),
      _ErrorItem(
        'Not Found',
        Icons.search_off,
        AppColors.textSecondary,
        _simulateNotFound,
      ),
      _ErrorItem(
        'Timeout',
        Icons.timer_off,
        AppColors.accent,
        _simulateTimeout,
      ),
      _ErrorItem(
        'Session (401)',
        Icons.lock_clock,
        AppColors.warning,
        _simulateSessionExpired,
      ),
      _ErrorItem(
        'Cancelled',
        Icons.cancel_outlined,
        AppColors.info,
        _simulateCancelled,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 300,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: errors.length,
      itemBuilder: (context, index) {
        final error = errors[index];
        return Card(
          child: InkWell(
            onTap: error.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: error.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(error.icon, color: error.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      error.label,
                      style: AppTextStyles.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildExceptionTypesList() {
    final types = [
      _ExceptionType(
        'ConnectionException',
        'No internet connection',
        Icons.wifi_off,
      ),
      _ExceptionType(
        'ConnectionTimeoutException',
        'Connection takes too long',
        Icons.timer_off,
      ),
      _ExceptionType(
        'SendTimeoutException',
        'Sending data takes too long',
        Icons.upload,
      ),
      _ExceptionType(
        'ReceiveTimeoutException',
        'Receiving data takes too long',
        Icons.download,
      ),
      _ExceptionType(
        'ResponseException',
        'Server returns error (4xx, 5xx)',
        Icons.cloud_off,
      ),
      _ExceptionType(
        'SessionExpiredException',
        'Authentication fails (401)',
        Icons.lock_clock,
      ),
      _ExceptionType(
        'CancelledException',
        'Request is cancelled',
        Icons.cancel,
      ),
      _ExceptionType(
        'UnknownException',
        'Unhandled errors',
        Icons.error_outline,
      ),
    ];

    return Column(
      children: types.map((type) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(type.icon, size: 20, color: AppColors.textSecondary),
            ),
            title: Text(
              type.name,
              style: AppTextStyles.code.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              type.description,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _simulateConnectionError() {
    final exception = const ConnectionException('Network unreachable');
    _controller.select(exception);
    _showExceptionBottomSheet(exception);
  }

  void _simulateServerError() {
    final exception = const ResponseException(
      message: 'Internal Server Error',
      statusCode: 500,
    );
    _controller.select(exception);
    _showExceptionBottomSheet(exception);
  }

  void _simulateNotFound() {
    final exception = const ResponseException(
      message: 'Resource not found',
      statusCode: 404,
    );
    _controller.select(exception);
    _showExceptionBottomSheet(exception);
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
    _controller.select(exception);
    _showExceptionBottomSheet(exception);
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
    _controller.select(exception);
    _showExceptionBottomSheet(exception);
  }

  void _simulateCancelled() {
    final exception = const CancelledException('Request was cancelled by user');
    _controller.select(exception);
    _showExceptionBottomSheet(exception);
  }

  void _showExceptionBottomSheet(SmartException exception) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        child: SmartErrorCard.fromException(
          exception,
          action: 'Dismiss',
          onActionPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

class _ErrorItem {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _ErrorItem(this.label, this.icon, this.color, this.onTap);
}

class _ExceptionType {
  final String name;
  final String description;
  final IconData icon;

  _ExceptionType(this.name, this.description, this.icon);
}
