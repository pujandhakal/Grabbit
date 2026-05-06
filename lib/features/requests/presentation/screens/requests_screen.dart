import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_soft_background.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppSoftBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 130),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Requests',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Track live responses and request status updates.',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push(RoutePaths.postRequest),
                    icon: const Icon(Icons.add_circle_outline_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const AppSectionHeader(
                title: 'Recent activity',
                actionLabel: 'View all',
              ),
              const SizedBox(height: 14),
              ..._requests.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RequestCard(item: item),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.item,
  });

  final _RequestItem item;

  @override
  Widget build(BuildContext context) {
    final tone = switch (item.status) {
      'Active' => AppStatusTone.primary,
      'Pending' => AppStatusTone.accent,
      'Completed' => AppStatusTone.blue,
      _ => AppStatusTone.neutral,
    };

    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIconBadge(
                icon: item.icon,
                backgroundColor: item.badgeColor,
                foregroundColor: item.badgeForeground,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 5),
                    Text(item.subtitle, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              AppStatusChip(label: item.status, tone: tone),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(Icons.schedule_rounded,
                  size: 16, color: AppColors.textMuted),
              const SizedBox(width: 6),
              Text(item.time, style: Theme.of(context).textTheme.bodySmall),
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
    );
  }
}

class _RequestItem {
  const _RequestItem({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.time,
    required this.responseText,
    required this.icon,
    required this.badgeColor,
    required this.badgeForeground,
  });

  final String title;
  final String subtitle;
  final String status;
  final String time;
  final String responseText;
  final IconData icon;
  final Color badgeColor;
  final Color badgeForeground;
}

const _requests = [
  _RequestItem(
    title: 'Wireless keyboard',
    subtitle: 'Active request with multiple nearby supplier responses.',
    status: 'Active',
    time: 'Updated 8 mins ago',
    responseText: '4 offers received',
    icon: Icons.keyboard_outlined,
    badgeColor: AppColors.primarySoft,
    badgeForeground: AppColors.primaryDark,
  ),
  _RequestItem(
    title: 'Running shoes',
    subtitle: 'Waiting for more stores to respond to your size request.',
    status: 'Pending',
    time: 'Updated 35 mins ago',
    responseText: '2 shops responded',
    icon: Icons.directions_run_outlined,
    badgeColor: AppColors.accentSoft,
    badgeForeground: AppColors.accent,
  ),
  _RequestItem(
    title: 'Second-hand textbooks',
    subtitle: 'Request closed after pickup confirmation.',
    status: 'Completed',
    time: 'Closed yesterday',
    responseText: 'Completed',
    icon: Icons.menu_book_outlined,
    badgeColor: AppColors.blueSoft,
    badgeForeground: AppColors.blue,
  ),
];
