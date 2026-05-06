import 'package:flutter/material.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_soft_background.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';

class ShopDashboardScreen extends StatelessWidget {
  const ShopDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppSoftBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            children: [
              const Text(
                'Shop Dashboard',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Respond faster to high-intent local buyers nearby.',
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 18),
              const AppSectionHeader(title: 'Overview'),
              const SizedBox(height: 12),
              const _StatCard(
                title: '12 active customer requests',
                subtitle: '3 requests were posted in the last hour.',
                tone: AppStatusTone.primary,
              ),
              const SizedBox(height: 12),
              const _StatCard(
                title: '4 group-buy opportunities',
                subtitle: 'Bundle responses can unlock higher conversions.',
                tone: AppStatusTone.blue,
              ),
              const SizedBox(height: 12),
              const _StatCard(
                title: 'Top message',
                subtitle: 'Laptop accessories and audio gear are trending today.',
                tone: AppStatusTone.accent,
              ),
            ],
          ),
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
