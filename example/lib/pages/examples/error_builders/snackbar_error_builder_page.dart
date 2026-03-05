import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

/// Example page demonstrating [SnackBarErrorBuilder] configuration.
///
/// Shows how to configure per-exception-type SnackBar builders,
/// a baseBuilder fallback, and a customBuilder for unknown errors.
class SnackBarErrorBuilderPage extends StatefulWidget {
  const SnackBarErrorBuilderPage({super.key});

  @override
  State<SnackBarErrorBuilderPage> createState() =>
      _SnackBarErrorBuilderPageState();
}

class _SnackBarErrorBuilderPageState extends State<SnackBarErrorBuilderPage> {
  bool _useCustomBuilders = false;

  /// Simulates triggering the given exception via SmartExecuter.
  Future<void> _triggerError(SmartException exception) async {
    final config = SmartExecuterConfig.instance;
    final originalSnackBarBuilder = config.snackBarErrorBuilder;

    // Temporarily apply custom builders if toggled on
    if (_useCustomBuilders) {
      SmartExecuterConfig.initialize(
        snackBarErrorBuilder: SnackBarErrorBuilder(
          baseBuilder: (context, exception) => SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Custom Base Handler',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        exception.message,
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF5C6BC0),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
          connectionBuilder: (context, exception) => SnackBar(
            content: Row(
              children: [
                const Icon(Icons.wifi_off_rounded,
                    color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Internet Connection',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        'Please check your Wi-Fi or mobile data',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFE65100),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'RETRY',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
          responseBuilder: (context, exception) {
            final resp = exception as ResponseException;
            return SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.cloud_off_rounded,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Server Error ${resp.statusCode ?? ''}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          resp.message,
                          style: TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFFC62828),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            );
          },
          sessionExpiredBuilder: (context, exception) => SnackBar(
            content: Row(
              children: [
                const Icon(Icons.lock_outline_rounded,
                    color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session Expired',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        'Tap to sign in again',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF6A1B9A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
            action: SnackBarAction(
              label: 'SIGN IN',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
          customBuilder: (context, exception) => SnackBar(
            content: Row(
              children: [
                const Icon(Icons.help_outline_rounded,
                    color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Unknown: ${exception.message}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF455A64),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        ),
        // Preserve other config settings
        globalErrorHandler: config.globalErrorHandler,
        dialogErrorBuilder: config.dialogErrorBuilder,
      );
    }

    if (!mounted) return;

    await SmartExecuter.execute(
      () => Future.delayed(
        const Duration(milliseconds: 300),
        () => throw exception,
      ),
      context: context,
      viewType: ErrorViewType.snackBar,
    );

    // Restore original config
    if (_useCustomBuilders) {
      SmartExecuterConfig.initialize(
        snackBarErrorBuilder: originalSnackBarBuilder,
        globalErrorHandler: config.globalErrorHandler,
        dialogErrorBuilder: config.dialogErrorBuilder,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SnackBar Error Builder'),
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
                        ? 'Using per-type custom SnackBar builders'
                        : 'Using package default SnackBar design',
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
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCE93D8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded,
              color: Color(0xFF7B1FA2), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resolution Order',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A148C),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Specific builder → baseBuilder → Package default\n\n'
                  'Each builder receives the full SmartException with metadata, '
                  'operation name, endpoint, and custom data.',
                  style: TextStyle(
                    color: Colors.purple.shade900,
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
            '  snackBarErrorBuilder: SnackBarErrorBuilder(\n'
            '    // Fallback for all types\n'
            '    baseBuilder: (context, exception) => SnackBar(\n'
            '      content: Text(exception.message),\n'
            '    ),\n'
            '    // Per-type builders\n'
            '    connectionBuilder: (ctx, e) => SnackBar(\n'
            '      content: Text(\'No internet\'),\n'
            '      backgroundColor: Colors.orange,\n'
            '      action: SnackBarAction(\n'
            '        label: \'RETRY\',\n'
            '        onPressed: () {},\n'
            '      ),\n'
            '    ),\n'
            '    responseBuilder: (ctx, e) {\n'
            '      final resp = e as ResponseException;\n'
            '      return SnackBar(\n'
            '        content: Text(\'Error \${resp.statusCode}\'),\n'
            '      );\n'
            '    },\n'
            '    // For unknown exception types\n'
            '    customBuilder: (ctx, e) => SnackBar(\n'
            '      content: Text(\'Unknown: \${e.message}\'),\n'
            '    ),\n'
            '  ),\n'
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
