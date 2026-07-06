final class PendingAction {
  const PendingAction(this.action, this.timestamp);

  final String action;
  final DateTime timestamp;
}

final class ConnectionStatus {
  const ConnectionStatus({
    required this.hasConnection,
    required this.isWifi,
    required this.isMobile,
  });

  final bool hasConnection;
  final bool isWifi;
  final bool isMobile;
}
