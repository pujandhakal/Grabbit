import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';

class RequestsScreen extends ConsumerWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(requestsProvider);

    return Scaffold(
      body: AppStickyPage(
        header: AppScreenHeader(
          title: 'My Requests',
          subtitle: 'Track live responses and request status updates.',
          trailing: IconButton(
            onPressed: () => context.push(RoutePaths.postRequest),
            icon: const Icon(Icons.add_circle_outline_rounded),
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
          children: [
            const AppSectionHeader(
              title: 'Recent activity',
              actionLabel: 'View all',
            ),
            const SizedBox(height: 14),
            requests.when(
              loading: () => const Padding(
                padding: EdgeInsets.only(top: 48),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Text(
                  'Unable to load requests.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              data: (items) => Column(
                children: [
                  ...items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _RequestCard(
                        item: item,
                        onTap: () => context.push(
                          RoutePaths.requestResponsesPath(item.id),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.item,
    required this.onTap,
  });

  final RequestSummary item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tone = switch (item.status) {
      RequestStatus.active => AppStatusTone.primary,
      RequestStatus.pending => AppStatusTone.accent,
      RequestStatus.completed => AppStatusTone.blue,
    };
    final icon = switch (item.category) {
      'Clothing' => Icons.checkroom_outlined,
      'Sports' => Icons.directions_run_outlined,
      'Books' => Icons.menu_book_outlined,
      _ => Icons.receipt_long_outlined,
    };
    final badgeColor = switch (item.category) {
      'Clothing' => AppColors.accentSoft,
      'Sports' => AppColors.primarySoft,
      'Books' => AppColors.blueSoft,
      _ => AppColors.primarySoft,
    };
    final badgeForeground = switch (item.category) {
      'Clothing' => AppColors.accent,
      'Sports' => AppColors.primaryDark,
      'Books' => AppColors.blue,
      _ => AppColors.primaryDark,
    };

    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppIconBadge(
                      icon: icon,
                      backgroundColor: badgeColor,
                      foregroundColor: badgeForeground,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.subtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    AppStatusChip(label: _statusLabel(item.status), tone: tone),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.time,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      item.responseText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _statusLabel(RequestStatus status) {
    return switch (status) {
      RequestStatus.active => 'Active',
      RequestStatus.pending => 'Pending',
      RequestStatus.completed => 'Completed',
    };
  }
}
