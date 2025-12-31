/// Connectivity utilities for SmartExecuter.
///
/// This library provides utilities for checking internet connectivity.
library;

import 'package:connectivity_plus/connectivity_plus.dart';

/// Utility class for checking network connectivity.
abstract final class ConnectivityChecker {
  static final Connectivity _connectivity = Connectivity();

  /// Checks if the device has an active internet connection.
  ///
  /// Returns `true` if connected, `false` otherwise.
  static Future<bool> hasConnection() async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// Gets the current connectivity status.
  ///
  /// Returns a list of [ConnectivityResult] indicating the current
  /// network connection types.
  static Future<List<ConnectivityResult>> getStatus() async {
    return _connectivity.checkConnectivity();
  }

  /// Returns a stream of connectivity changes.
  ///
  /// Use this to listen for network status changes:
  /// ```dart
  /// ConnectivityChecker.onConnectivityChanged.listen((results) {
  ///   if (results.contains(ConnectivityResult.none)) {
  ///     print('No connection');
  ///   }
  /// });
  /// ```
  static Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }

  /// Checks if connected via WiFi.
  static Future<bool> isConnectedViaWifi() async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.wifi);
  }

  /// Checks if connected via mobile data.
  static Future<bool> isConnectedViaMobile() async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile);
  }

  /// Checks if connected via Ethernet.
  static Future<bool> isConnectedViaEthernet() async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.ethernet);
  }
}
