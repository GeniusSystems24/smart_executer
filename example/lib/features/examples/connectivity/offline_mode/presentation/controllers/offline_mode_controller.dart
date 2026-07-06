import 'package:flutter/foundation.dart';
import 'package:smart_executer/smart_executer.dart';
import 'package:smart_executer_example/features/examples/connectivity/offline_mode/domain/models/offline_models.dart';

final class OfflineModeController extends ChangeNotifier {
  bool _isOnline = true;
  bool _isChecking = false;
  final List<String> _cachedItems = const [
    'Cached Item 1',
    'Cached Item 2',
    'Cached Item 3',
  ];
  final List<PendingAction> _pendingActions = [];

  bool get isOnline => _isOnline;
  bool get isChecking => _isChecking;
  List<String> get cachedItems => List.unmodifiable(_cachedItems);
  List<PendingAction> get pendingActions => List.unmodifiable(_pendingActions);

  Future<ConnectionStatus> checkConnection() async {
    _isChecking = true;
    notifyListeners();

    final status = ConnectionStatus(
      hasConnection: await ConnectivityChecker.hasConnection(),
      isWifi: await ConnectivityChecker.isConnectedViaWifi(),
      isMobile: await ConnectivityChecker.isConnectedViaMobile(),
    );

    _isOnline = status.hasConnection;
    _isChecking = false;
    notifyListeners();
    return status;
  }

  void simulateOffline() {
    _isOnline = false;
    notifyListeners();
  }

  void simulateOnline() {
    _isOnline = true;
    notifyListeners();
  }

  PendingAction addPendingAction(String action) {
    final item = PendingAction(action, DateTime.now());
    _pendingActions.add(item);
    notifyListeners();
    return item;
  }

  Future<int> syncPendingActions() async {
    if (_pendingActions.isEmpty) return 0;
    await Future<void>.delayed(const Duration(seconds: 1));
    final count = _pendingActions.length;
    _pendingActions.clear();
    notifyListeners();
    return count;
  }
}
