import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grabbit/app/application/app_data_refresh.dart';
import 'package:grabbit/app/router/app_router.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/realtime/realtime_connection.dart';

class GrabbitApp extends ConsumerWidget {
  const GrabbitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    ref.watch(realtimeConnectionProvider);
    ref.watch(connectivityAutoRefreshProvider);

    return MaterialApp.router(
      title: 'Grabbit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
    );
  }
}
