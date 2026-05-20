import 'package:flutter/material.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    required this.title,
    required this.message,
    this.icon = Icons.error_outline_rounded,
    this.onRetry,
    super.key,
  });

  factory AppErrorState.fromError({
    required Object error,
    required String fallbackTitle,
    required String fallbackMessage,
    VoidCallback? onRetry,
  }) {
    final message = error is AppException ? error.message : fallbackMessage;
    final isConnectionError = _isConnectionError(message);

    return AppErrorState(
      title: isConnectionError ? 'No internet connection' : fallbackTitle,
      message: isConnectionError
          ? 'Turn on Wi-Fi or mobile data, then try again.'
          : message,
      icon: isConnectionError
          ? Icons.wifi_off_rounded
          : Icons.error_outline_rounded,
      onRetry: onRetry,
    );
  }

  factory AppErrorState.offline({VoidCallback? onRetry}) {
    return AppErrorState(
      title: 'No server connection',
      message: 'Connect to the same Wi-Fi as the server, then try again.',
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
    );
  }

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      radius: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppIconBadge(
            icon: icon,
            backgroundColor: AppColors.accentSoft,
            foregroundColor: AppColors.accent,
            size: 52,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ],
      ),
    );
  }

  static bool _isConnectionError(String message) {
    final normalized = message.toLowerCase();
    return normalized.contains('no connection') ||
        normalized.contains('unable to reach') ||
        normalized.contains('network') ||
        normalized.contains('socket') ||
        normalized.contains('connection failed');
  }
}
