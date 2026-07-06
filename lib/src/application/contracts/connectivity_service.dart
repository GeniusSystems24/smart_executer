/// Abstraction for checking whether an operation may access the network.
abstract interface class ConnectivityService {
  /// Returns whether at least one supported network transport is available.
  Future<bool> hasConnection();
}
