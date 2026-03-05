import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

/// Example page demonstrating [DialogErrorBuilder] configuration.
///
/// Shows how to configure per-exception-type Dialog builders,
/// a baseBuilder fallback, and a customBuilder for unknown errors.
class DialogErrorBuilderPage extends StatefulWidget {
  const DialogErrorBuilderPage({super.key});

  @override
  State<DialogErrorBuilderPage> createState() =>
      _DialogErrorBuilderPageState();
}

class _DialogErrorBuilderPageState extends State<DialogErrorBuilderPage> {
  bool _useCustomBuilders = false;

  /// Simulates triggering the given exception via SmartExecuter.
  Future<void> _triggerError(SmartException exception) async {
    final config = SmartExecuterConfig.instance;
    final originalDialogBuilder = config.dialogErrorBuilder;

    // Temporarily apply custom builders if toggled on
    if (_useCustomBuilders) {
      SmartExecuterConfig.initialize(
        dialogErrorBuilder: DialogErrorBuilder(
          baseBuilder: (context, exception) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            icon: const Icon(Icons.warning_amber_rounded,
                color: Color(0xFF5C6BC0), size: 48),
            title: const Text('Custom Base Handler'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  exception.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                if (exception.metadata.operationName != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Operation: ${exception.metadata.operationName}',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
          connectionBuilder: (context, exception) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            icon: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE65100).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wifi_off_rounded,
                  color: Color(0xFFE65100), size: 40),
            ),
            title: const Text(
              'No Internet Connection',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Please check your Wi-Fi or mobile data and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Retry'),
              ),
            ],
          ),
          responseBuilder: (context, exception) {
            final resp = exception as ResponseException;
            final isServerError = resp.isServerError;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              icon: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFC62828).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud_off_rounded,
                    color: Color(0xFFC62828), size: 40),
              ),
              title: Text(
                isServerError
                    ? 'Server Error (${resp.statusCode})'
                    : 'Request Failed (${resp.statusCode ?? 'N/A'})',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    resp.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status Code: ${resp.statusCode ?? 'N/A'}',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Colors.red.shade900,
                          ),
                        ),
                        Text(
                          'Type: ${resp.exceptionType.name}',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Colors.red.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Dismiss'),
                ),
              ],
            );
          },
          sessionExpiredBuilder: (context, exception) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            icon: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6A1B9A).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline_rounded,
                  color: Color(0xFF6A1B9A), size: 40),
            ),
            title: const Text(
              'Session Expired',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Your session has expired. Please sign in again to continue.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.login_rounded, size: 18),
                label: const Text('Sign In'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6A1B9A),
                ),
              ),
            ],
          ),
          customBuilder: (context, exception) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            icon: const Icon(Icons.help_outline_rounded,
                color: Color(0xFF455A64), size: 48),
            title: const Text('Unknown Error'),
            content: Text(
              exception.message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
        // Preserve other config settings
        globalErrorHandler: config.globalErrorHandler,
        snackBarErrorBuilder: config.snackBarErrorBuilder,
      );
    }

    if (!mounted) return;

    await SmartExecuter.execute(
      () => Future.delayed(
        const Duration(milliseconds: 300),
        () => throw exception,
      ),
      context: context,
      viewType: ErrorViewType.dialog,
    );

    // Restore original config
    if (_useCustomBuilders) {
      SmartExecuterConfig.initialize(
        dialogErrorBuilder: originalDialogBuilder,
        globalErrorHandler: config.globalErrorHandler,
        snackBarErrorBuilder: config.snackBarErrorBuilder,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialog Error Builder'),
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

          // Section: Trigger Errors
          Text(
            'Trigger Error Types',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          _ErrorTriggerTile(
            title: 'Connection Error',
            subtitle: 'No internet connection',
            icon: Icons.wifi_off_rounded,
            color: const Color(0xFFE65100),
            onTap: () => _triggerError(const ConnectionException()),
          ),
          _ErrorTriggerTile(
            title: 'Connection Timeout',
            subtitle: 'Server took too long to respond',
            icon: Icons.timer_off_rounded,
            color: const Color(0xFFEF6C00),
            onTap: () => _triggerError(const ConnectionTimeoutException()),
          ),
          _ErrorTriggerTile(
            title: 'Send Timeout',
            subtitle: 'Request upload timed out',
            icon: Icons.upload_rounded,
            color: const Color(0xFFF57C00),
            onTap: () => _triggerError(const SendTimeoutException()),
          ),
          _ErrorTriggerTile(
            title: 'Receive Timeout',
            subtitle: 'Response download timed out',
            icon: Icons.download_rounded,
            color: const Color(0xFFFF8F00),
            onTap: () => _triggerError(const ReceiveTimeoutException()),
          ),
          _ErrorTriggerTile(
            title: 'Cancelled',
            subtitle: 'Request was cancelled by user',
            icon: Icons.cancel_rounded,
            color: const Color(0xFF78909C),
            onTap: () => _triggerError(const CancelledException()),
          ),
          _ErrorTriggerTile(
            title: 'Response Error (500)',
            subtitle: 'Internal server error',
            icon: Icons.cloud_off_rounded,
            color: const Color(0xFFC62828),
            onTap: () => _triggerError(const ResponseException(
              message: 'Internal Server Error',
              statusCode: 500,
            )),
          ),
          _ErrorTriggerTile(
            title: 'Session Expired',
            subtitle: 'Authentication token expired',
            icon: Icons.lock_outline_rounded,
            color: const Color(0xFF6A1B9A),
            onTap: () => _triggerError(const SessionExpiredException()),
          ),
          _ErrorTriggerTile(
            title: 'Unknown Error',
            subtitle: 'An unexpected error occurred',
            icon: Icons.help_outline_rounded,
            color: const Color(0xFF455A64),
            onTap: () =>
                _triggerError(const UnknownException('Something went wrong')),
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
          color: _useCustomBuilders
              ? const Color(0xFF667EEA)
              : Colors.grey.shade300,
          width: _useCustomBuilders ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _useCustomBuilders
                    ? const Color(0xFF667EEA).withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _useCustomBuilders
                    ? Icons.palette_rounded
                    : Icons.auto_awesome_rounded,
                color: _useCustomBuilders
                    ? const Color(0xFF667EEA)
                    : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _useCustomBuilders ? 'Custom Builders' : 'Default Builders',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _useCustomBuilders
                        ? 'Using per-type custom Dialog builders'
                        : 'Using package default Dialog design',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: _useCustomBuilders,
              onChanged: (v) => setState(() => _useCustomBuilders = v),
              activeColor: const Color(0xFF667EEA),
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
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF90CAF9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFF1565C0), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resolution Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Specific builder → baseBuilder → Package default\n\n'
                  'Each builder receives the full SmartException with metadata. '
                  'Use viewType: ErrorViewType.dialog to display errors as dialogs.',
                  style: TextStyle(
                    color: Colors.blue.shade900,
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
            '  dialogErrorBuilder: DialogErrorBuilder(\n'
            '    // Fallback for all types\n'
            '    baseBuilder: (context, exception) =>\n'
            '      AlertDialog(\n'
            '        title: Text(\'Error\'),\n'
            '        content: Text(exception.message),\n'
            '      ),\n'
            '    // Per-type builders\n'
            '    connectionBuilder: (ctx, e) =>\n'
            '      AlertDialog(\n'
            '        icon: Icon(Icons.wifi_off),\n'
            '        title: Text(\'No Internet\'),\n'
            '        actions: [\n'
            '          FilledButton(\n'
            '            onPressed: () {},\n'
            '            child: Text(\'Retry\'),\n'
            '          ),\n'
            '        ],\n'
            '      ),\n'
            '    responseBuilder: (ctx, e) {\n'
            '      final resp = e as ResponseException;\n'
            '      return AlertDialog(\n'
            '        title: Text(\'Error \${resp.statusCode}\'),\n'
            '        content: Text(resp.message),\n'
            '      );\n'
            '    },\n'
            '  ),\n'
            ');\n\n'
            '// Use dialog viewType\n'
            'await SmartExecuter.run(\n'
            '  request: () => api.fetchData(),\n'
            '  context: context,\n'
            '  viewType: ErrorViewType.dialog,\n'
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
