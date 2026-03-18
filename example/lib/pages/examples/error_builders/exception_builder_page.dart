import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

/// Example page demonstrating [ExceptionBuilder] usage.
///
/// Shows how to customize exception mapping globally via
/// [SmartExecuterConfig.initialize] using the [exceptionBuilder] callback.
class ExceptionBuilderPage extends StatefulWidget {
  const ExceptionBuilderPage({super.key});

  @override
  State<ExceptionBuilderPage> createState() => _ExceptionBuilderPageState();
}

class _ExceptionBuilderPageState extends State<ExceptionBuilderPage> {
  bool _useCustomBuilder = false;
  String _lastExceptionType = '';
  String _lastMessage = '';

  void _applyCustomBuilder() {
    final config = SmartExecuterConfig.instance;

    SmartExecuterConfig.initialize(
      exceptionBuilder: _useCustomBuilder
          ? (error, stackTrace, metadata) {
              // Custom: map 403 to a friendly message
              if (error is DioException &&
                  error.response?.statusCode == 403) {
                return ResponseException(
                  message: 'You do not have permission to perform this action',
                  statusCode: 403,
                  responseData: error.response?.data,
                  cause: error,
                  stackTrace: stackTrace,
                  metadata: metadata,
                );
              }

              // Custom: parse server error messages from response body
              if (error is DioException &&
                  error.response?.statusCode != null &&
                  error.response!.statusCode! >= 400) {
                final data = error.response?.data;
                final serverMessage =
                    data is Map ? data['message'] as String? : null;
                if (serverMessage != null) {
                  return ResponseException(
                    message: serverMessage,
                    statusCode: error.response!.statusCode,
                    responseData: data,
                    cause: error,
                    stackTrace: stackTrace,
                    metadata: metadata,
                  );
                }
              }

              // Custom: wrap FormatException with a friendly message
              if (error is FormatException) {
                return UnknownException(
                  'Invalid data format received from server',
                  error,
                  stackTrace,
                  metadata,
                );
              }

              return null; // fall back to default ExceptionMapper
            }
          : null,
      // Preserve other config
      snackBarErrorBuilder: config.snackBarErrorBuilder,
      dialogErrorBuilder: config.dialogErrorBuilder,
      globalErrorHandler: config.globalErrorHandler,
    );
  }

  Future<void> _triggerError(Object error) async {
    _applyCustomBuilder();

    if (!mounted) return;

    final result = await SmartExecuter.execute(
      () => Future.delayed(
        const Duration(milliseconds: 300),
        () => throw error,
      ),
      context: context,
      viewType: ErrorViewType.snackBar,
      operationName: 'exceptionBuilderDemo',
    );

    result.onFailure((exception) {
      if (mounted) {
        setState(() {
          _lastExceptionType = exception.runtimeType.toString();
          _lastMessage = exception.message;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exception Builder'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Toggle Card
          _buildToggleCard(),
          const SizedBox(height: 24),

          // Info Card
          _buildInfoCard(),
          const SizedBox(height: 24),

          // Last Result
          if (_lastExceptionType.isNotEmpty) ...[
            _buildLastResultCard(),
            const SizedBox(height: 24),
          ],

          // Trigger Errors
          Text(
            'Trigger Error Types',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          _ErrorTriggerTile(
            title: '403 Forbidden',
            subtitle: _useCustomBuilder
                ? 'Custom: friendly permission message'
                : 'Default: raw server error',
            icon: Icons.block_rounded,
            color: const Color(0xFFD32F2F),
            onTap: () => _triggerError(
              DioException(
                requestOptions: RequestOptions(path: '/api/admin'),
                response: Response(
                  requestOptions: RequestOptions(path: '/api/admin'),
                  statusCode: 403,
                  data: {'error': 'Forbidden'},
                ),
                type: DioExceptionType.badResponse,
              ),
            ),
          ),
          _ErrorTriggerTile(
            title: '422 with Server Message',
            subtitle: _useCustomBuilder
                ? 'Custom: extracts message from response body'
                : 'Default: generic server error',
            icon: Icons.message_rounded,
            color: const Color(0xFFE64A19),
            onTap: () => _triggerError(
              DioException(
                requestOptions: RequestOptions(path: '/api/users'),
                response: Response(
                  requestOptions: RequestOptions(path: '/api/users'),
                  statusCode: 422,
                  data: {'message': 'Email already exists'},
                ),
                type: DioExceptionType.badResponse,
              ),
            ),
          ),
          _ErrorTriggerTile(
            title: 'FormatException',
            subtitle: _useCustomBuilder
                ? 'Custom: "Invalid data format..."'
                : 'Default: raw exception message',
            icon: Icons.data_object_rounded,
            color: const Color(0xFF7B1FA2),
            onTap: () =>
                _triggerError(const FormatException('Unexpected character')),
          ),
          _ErrorTriggerTile(
            title: 'Connection Error',
            subtitle: 'Falls back to default mapper (both modes)',
            icon: Icons.wifi_off_rounded,
            color: const Color(0xFFE65100),
            onTap: () => _triggerError(
              DioException(
                requestOptions: RequestOptions(path: '/api/data'),
                type: DioExceptionType.connectionError,
                message: 'Connection refused',
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Code Preview
          _buildCodePreview(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildToggleCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: _useCustomBuilder
              ? const Color(0xFF00897B)
              : Colors.grey.shade300,
          width: _useCustomBuilder ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _useCustomBuilder
                    ? const Color(0xFF00897B).withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _useCustomBuilder
                    ? Icons.build_rounded
                    : Icons.auto_awesome_rounded,
                color: _useCustomBuilder
                    ? const Color(0xFF00897B)
                    : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _useCustomBuilder
                        ? 'Custom Exception Builder'
                        : 'Default ExceptionMapper',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _useCustomBuilder
                        ? 'Custom mapping for 403, server messages, FormatException'
                        : 'Using built-in ExceptionMapper logic',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: _useCustomBuilder,
              onChanged: (v) => setState(() => _useCustomBuilder = v),
              activeColor: const Color(0xFF00897B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF80CBC4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFF00695C), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How it works',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D40),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'exceptionBuilder receives:\n'
                  '  - Object error (original error)\n'
                  '  - StackTrace? stackTrace\n'
                  '  - ExceptionMetadata metadata\n\n'
                  'Return SmartException → used directly\n'
                  'Return null → default ExceptionMapper',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastResultCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFE082)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bug_report_rounded,
                  color: Color(0xFFF57F17), size: 20),
              const SizedBox(width: 8),
              const Text(
                'Last Exception Result',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF57F17),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Type', _lastExceptionType),
          const SizedBox(height: 4),
          _buildDetailRow('Message', _lastMessage),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.orange.shade900,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.orange.shade800,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCodePreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configuration Code',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const SelectableText(
            'SmartExecuterConfig.initialize(\n'
            '  exceptionBuilder: (error, stackTrace, metadata) {\n'
            '    if (error is DioException &&\n'
            '        error.response?.statusCode == 403) {\n'
            '      return ResponseException(\n'
            '        message: \'Access denied\',\n'
            '        statusCode: 403,\n'
            '        metadata: metadata,\n'
            '      );\n'
            '    }\n'
            '\n'
            '    // Parse server messages\n'
            '    if (error is DioException) {\n'
            '      final data = error.response?.data;\n'
            '      final msg = data is Map\n'
            '          ? data[\'message\'] as String?\n'
            '          : null;\n'
            '      if (msg != null) {\n'
            '        return ResponseException(\n'
            '          message: msg,\n'
            '          statusCode: error.response!.statusCode,\n'
            '          metadata: metadata,\n'
            '        );\n'
            '      }\n'
            '    }\n'
            '\n'
            '    return null; // default mapping\n'
            '  },\n'
            ');',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Color(0xFFCDD6F4),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorTriggerTile extends StatelessWidget {
  const _ErrorTriggerTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
        trailing: Icon(
          Icons.play_circle_filled_rounded,
          color: color,
          size: 28,
        ),
        onTap: onTap,
      ),
    );
  }
}
