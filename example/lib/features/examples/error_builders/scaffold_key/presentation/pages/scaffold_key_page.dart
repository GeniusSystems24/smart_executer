import 'package:flutter/material.dart';
import 'package:smart_executer/smart_executer.dart';

/// Example page demonstrating [GlobalKey<ScaffoldState>] usage with SmartExecuter.
///
/// Shows how to use a scaffold key to control where SnackBars are displayed,
/// both globally via [SmartExecuterConfig] and per-operation.
class ScaffoldKeyPage extends StatefulWidget {
  const ScaffoldKeyPage({super.key});

  @override
  State<ScaffoldKeyPage> createState() => _ScaffoldKeyPageState();
}

class _ScaffoldKeyPageState extends State<ScaffoldKeyPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _useScaffoldKey = false;

  Future<void> _triggerError() async {
    if (!mounted) return;

    await SmartExecuter.execute(
      () => Future.delayed(
        const Duration(milliseconds: 300),
        () => throw const ConnectionException('No internet connection'),
      ),
      context: context,
      viewType: ErrorViewType.snackBar,
      scaffoldKey: _useScaffoldKey ? _scaffoldKey : null,
    );
  }

  Future<void> _triggerGlobalScaffoldKey() async {
    final config = SmartExecuterConfig.instance;
    final originalKey = config.scaffoldKey;

    SmartExecuterConfig.initialize(
      scaffoldKey: _scaffoldKey,
      snackBarErrorBuilder: config.snackBarErrorBuilder,
      dialogErrorBuilder: config.dialogErrorBuilder,
      globalErrorHandler: config.globalErrorHandler,
    );

    if (!mounted) return;

    await SmartExecuter.execute(
      () => Future.delayed(
        const Duration(milliseconds: 300),
        () => throw const ResponseException(
          message: 'Server error via global scaffoldKey',
          statusCode: 500,
        ),
      ),
      context: context,
      viewType: ErrorViewType.snackBar,
    );

    // Restore
    SmartExecuterConfig.initialize(
      scaffoldKey: originalKey,
      snackBarErrorBuilder: config.snackBarErrorBuilder,
      dialogErrorBuilder: config.dialogErrorBuilder,
      globalErrorHandler: config.globalErrorHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Scaffold Key'),
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

          // Actions
          Text(
            'Trigger Errors',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          _ActionTile(
            title: 'Per-Operation scaffoldKey',
            subtitle: _useScaffoldKey
                ? 'SnackBar uses scaffoldKey context'
                : 'SnackBar uses caller context (default)',
            icon: Icons.vpn_key_rounded,
            color: const Color(0xFF1976D2),
            onTap: _triggerError,
          ),
          _ActionTile(
            title: 'Global scaffoldKey',
            subtitle: 'Set scaffoldKey in SmartExecuterConfig',
            icon: Icons.settings_rounded,
            color: const Color(0xFF7B1FA2),
            onTap: _triggerGlobalScaffoldKey,
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
          color: _useScaffoldKey
              ? const Color(0xFF1976D2)
              : Colors.grey.shade300,
          width: _useScaffoldKey ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _useScaffoldKey
                    ? const Color(0xFF1976D2).withValues(alpha: 0.1)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _useScaffoldKey
                    ? Icons.vpn_key_rounded
                    : Icons.vpn_key_off_rounded,
                color: _useScaffoldKey
                    ? const Color(0xFF1976D2)
                    : Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _useScaffoldKey
                        ? 'Using scaffoldKey'
                        : 'Default (no scaffoldKey)',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _useScaffoldKey
                        ? 'SnackBars use scaffoldKey.currentContext'
                        : 'SnackBars use ScaffoldMessenger.of(context)',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Switch.adaptive(
              value: _useScaffoldKey,
              onChanged: (v) => setState(() => _useScaffoldKey = v),
              activeThumbColor: const Color(0xFF1976D2),
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
                  'Per-operation scaffoldKey → config.scaffoldKey → '
                  'ScaffoldMessenger.of(context)\n\n'
                  'Useful when the calling context is not under a '
                  'ScaffoldMessenger (e.g., dialogs, overlays).',
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
            '// Global scaffold key\n'
            'final scaffoldKey = GlobalKey<ScaffoldState>();\n'
            '\n'
            'SmartExecuterConfig.initialize(\n'
            '  scaffoldKey: scaffoldKey,\n'
            ');\n'
            '\n'
            '// Per-operation override\n'
            'await SmartExecuter.run(\n'
            '  request: () => apiService.getUser(id),\n'
            '  context: context,\n'
            '  scaffoldKey: pageScaffoldKey,\n'
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

class _ActionTile extends StatelessWidget {
  const _ActionTile({
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
