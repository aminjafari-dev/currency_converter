import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstraction over device connectivity checks.
///
/// Repositories call [isConnected] before hitting the network so they can
/// fall back to cache when offline.
///
/// Example:
/// ```dart
/// if (await networkInfo.isConnected) { ... }
/// ```
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// [NetworkInfo] implementation backed by [connectivity_plus].
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final results = await connectivity.checkConnectivity();
    // None means offline; any other result (wifi/mobile/ethernet) is online.
    return results.any((r) => r != ConnectivityResult.none);
  }
}
