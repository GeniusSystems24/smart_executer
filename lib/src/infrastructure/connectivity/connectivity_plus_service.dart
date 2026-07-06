import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:smart_executer/src/application/contracts/connectivity_service.dart';

/// Connectivity implementation backed by `connectivity_plus`.
final class ConnectivityPlusService implements ConnectivityService {
  ConnectivityPlusService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<bool> hasConnection() async {
    final results = await _connectivity.checkConnectivity();
    return !results.contains(ConnectivityResult.none);
  }

  /// Returns the currently reported connectivity transports.
  Future<List<ConnectivityResult>> checkConnectivity() {
    return _connectivity.checkConnectivity();
  }

  /// Emits connectivity transport changes reported by the plugin.
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
