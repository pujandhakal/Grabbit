import 'package:flutter/material.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';

class ShopDashboardScreen extends StatelessWidget {
  const ShopDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppStickyPage(
        bottomSafeArea: true,
        header: const AppScreenHeader(
          title: 'Shop Dashboard',
          subtitle: 'Respond faster to high-intent local buyers nearby.',
        ),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: const [
            AppSectionHeader(title: 'Overview'),
            SizedBox(height: 12),
            _StatCard(
              title: '12 active customer requests',
              subtitle: '3 requests were posted in the last hour.',
              tone: AppStatusTone.primary,
            ),
            SizedBox(height: 12),
            _StatCard(
              title: '4 group-buy opportunities',
              subtitle: 'Bundle responses can unlock higher conversions.',
              tone: AppStatusTone.blue,
            ),
            SizedBox(height: 12),
            _StatCard(
              title: 'Top message',
              subtitle: 'Laptop accessories and audio gear are trending today.',
              tone: AppStatusTone.accent,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.subtitle,
    required this.tone,
  });

  final String title;
  final String subtitle;
  final AppStatusTone tone;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppStatusChip(
            label: tone == AppStatusTone.primary
                ? 'Live'
                : tone == AppStatusTone.blue
                    ? 'GroupBuy'
                    : 'Trend',
            tone: tone,
          ),
        ],
      ),
    );
  }
}
