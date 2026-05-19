import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/core/network/api_client.dart';
import 'package:grabbit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

final realtimeConnectionProvider = Provider<void>((ref) {
  final authState = ref.watch(authControllerProvider);
  final config = ref.watch(appConfigProvider);
  final user = authState.valueOrNull;

  if (user == null || user.token.isEmpty) {
    return;
  }

  final socket = io.io(
    config.apiBaseUrl,
    io.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .setAuth({'token': user.token})
        .build(),
  );

  void refreshRequests(dynamic _) {
    ref.invalidate(requestsProvider);
    ref.invalidate(shopRequestsProvider);
    ref.invalidate(requestResponsesProvider);
  }

  socket
    ..on('request:created', refreshRequests)
    ..on('response:created', refreshRequests)
    ..on('response:updated', refreshRequests)
    ..on('request:updated', refreshRequests)
    ..connect();

  ref.onDispose(() {
    socket
      ..off('request:created')
      ..off('response:created')
      ..off('response:updated')
      ..off('request:updated')
      ..dispose();
  });
});
