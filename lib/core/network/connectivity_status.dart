import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/network/api_client.dart';

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final networkConnectionProvider = StreamProvider<bool>((ref) async* {
  final connectivity = ref.watch(connectivityProvider);
  final apiClient = ref.watch(apiClientProvider);

  yield await _canReachBackend(connectivity, apiClient);

  await for (final results in connectivity.onConnectivityChanged) {
    if (!_hasNetwork(results)) {
      yield false;
      continue;
    }

    yield await _canReachBackend(connectivity, apiClient);
  }
});

bool _hasNetwork(List<ConnectivityResult> results) {
  return results.any((result) => result != ConnectivityResult.none);
}

Future<bool> _canReachBackend(
  Connectivity connectivity,
  ApiClient apiClient,
) async {
  try {
    final connectivityResults = await connectivity.checkConnectivity();
    if (!_hasNetwork(connectivityResults)) {
      return false;
    }

    await apiClient.get('/api/health').timeout(const Duration(seconds: 2));
    return true;
  } catch (_) {
    return false;
  }
}
