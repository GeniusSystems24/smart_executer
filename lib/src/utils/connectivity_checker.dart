/// Connectivity utilities for SmartExecuter.
library;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:smart_executer/src/internal/smart_executer_runtime.dart';

/// Backward-compatible connectivity facade.
///
/// The concrete plugin dependency is owned by the package composition root,
/// while this class preserves the original static API.
abstract final class ConnectivityChecker {
  static final _service = SmartExecuterRuntime.connectivityService;

  /// Checks if the device has an active network transport.
  static Future<bool> hasConnection() => _service.hasConnection();

  /// Gets the current connectivity status.
  static Future<List<ConnectivityResult>> getStatus() =>
      _service.checkConnectivity();

  /// Returns a stream of connectivity changes.
  static Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _service.onConnectivityChanged;

  /// Checks if connected via WiFi.
  static Future<bool> isConnectedViaWifi() async {
    final result = await _service.checkConnectivity();
    return result.contains(ConnectivityResult.wifi);
  }

  /// Checks if connected via mobile data.
  static Future<bool> isConnectedViaMobile() async {
    final result = await _service.checkConnectivity();
    return result.contains(ConnectivityResult.mobile);
  }

  /// Checks if connected via Ethernet.
  static Future<bool> isConnectedViaEthernet() async {
    final result = await _service.checkConnectivity();
    return result.contains(ConnectivityResult.ethernet);
  }
}
