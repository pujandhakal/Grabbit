import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_soft_background.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/profile/data/repositories/shop_profile_repository.dart';

class ShopDashboardScreen extends ConsumerStatefulWidget {
  const ShopDashboardScreen({super.key});

  @override
  ConsumerState<ShopDashboardScreen> createState() =>
      _ShopDashboardScreenState();
}

class _ShopDashboardScreenState extends ConsumerState<ShopDashboardScreen> {
  bool _showOnlyNew = true;

  static const double _expandedHeight = 140;
  static const double _collapsedHeight = 72;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final shopProfile = ref.watch(shopProfileProvider);

    return AppSoftBackground(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 2,
            shadowColor: AppColors.shadow.withValues(alpha: 0.15),
            automaticallyImplyLeading: false,
            toolbarHeight: _collapsedHeight,
            expandedHeight: _expandedHeight,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final maxHeight = _expandedHeight + topInset;
                final minHeight = _collapsedHeight + topInset;
                final t = ((constraints.maxHeight - minHeight) /
                        (maxHeight - minHeight))
                    .clamp(0.0, 1.0);
                return _CollapsibleShopHeader(t: t, topInset: topInset);
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                if (shopProfile.valueOrNull?.isVerified == false) ...[
                  const _VerifyStoreCard(),
                  const SizedBox(height: 16),
                ],
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.18,
                  children: const [
                    _MetricCard(
                      title: 'New Requests Near You',
                      value: '12',
                      caption: '2 urgent',
                      icon: Icons.near_me_outlined,
                      tone: AppStatusTone.primary,
                    ),
                    _MetricCard(
                      title: 'Responses Sent',
                      value: '28',
                      caption: '+5 today',
                      icon: Icons.send_outlined,
                      tone: AppStatusTone.blue,
                    ),
                    _MetricCard(
                      title: 'Pending Conversations',
                      value: '7',
                      caption: 'Inbox',
                      icon: Icons.mark_chat_unread_outlined,
                      tone: AppStatusTone.accent,
                    ),
                    _MetricCard(
                      title: 'Shop Rating',
                      value: '4.8',
                      caption: '127 reviews',
                      icon: Icons.star_border_rounded,
                      tone: AppStatusTone.neutral,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _FilterCard(
                  showOnlyNew: _showOnlyNew,
                  onShowOnlyNewChanged: (value) {
                    setState(() {
                      _showOnlyNew = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const AppSectionHeader(title: '5 Requests Near You'),
                const SizedBox(height: 12),
                for (final request in _nearbyRequests) ...[
                  _RequestOpportunityCard(request: request),
                  const SizedBox(height: 12),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifyStoreCard extends StatelessWidget {
  const _VerifyStoreCard();

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppIconBadge(
            icon: Icons.verified_outlined,
            backgroundColor: AppColors.accentSoft,
            foregroundColor: AppColors.accent,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify your store',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Complete public store details so customers can view your store after you respond.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => context.go(RoutePaths.shopProfile),
                  icon: const Icon(Icons.storefront_outlined),
                  label: const Text('Complete Details'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleShopHeader extends StatelessWidget {
  const _CollapsibleShopHeader({required this.t, required this.topInset});

  final double t;
  final double topInset;

  @override
  Widget build(BuildContext context) {
    final avatarRadius = lerpDouble(18, 30, t)!;
    final subtitleGap = lerpDouble(0, 4, t)!;
    final chipsGap = lerpDouble(0, 10, t)!;
    final alignY = lerpDouble(0, 1, t)!;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Align(
          alignment: Alignment(-1, alignY),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: avatarRadius,
                    backgroundColor: AppColors.primarySoft,
                    child: Text(
                      'KE',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w800,
                        fontSize: lerpDouble(12, 16, t),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -4,
                    top: -6,
                    child: IgnorePointer(
                      ignoring: t < 0.5,
                      child: Opacity(
                        opacity: t,
                        child: Container(
                          width: 22,
                          height: 22,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '3',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kathmandu Electronics',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: subtitleGap),
                    ClipRect(
                      child: Align(
                        alignment: Alignment.topLeft,
                        heightFactor: t,
                        child: Opacity(
                          opacity: t,
                          child: Text(
                            'Connect with customers near you',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: chipsGap),
                    ClipRect(
                      child: Align(
                        alignment: Alignment.topLeft,
                        heightFactor: t,
                        child: Opacity(
                          opacity: t,
                          child: const Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              AppStatusChip(label: '+3 today'),
                              AppStatusChip(
                                label: '+5 today',
                                tone: AppStatusTone.blue,
                              ),
                            ],
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
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.caption,
    required this.icon,
    required this.tone,
  });

  final String title;
  final String value;
  final String caption;
  final IconData icon;
  final AppStatusTone tone;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToneIcon(icon: icon, tone: tone, size: 32),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 1),
          Text(caption, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _FilterCard extends StatelessWidget {
  const _FilterCard({
    required this.showOnlyNew,
    required this.onShowOnlyNewChanged,
  });

  final bool showOnlyNew;
  final ValueChanged<bool> onShowOnlyNewChanged;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Filter & Sort Requests',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: () => onShowOnlyNewChanged(false),
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: _FilterField(
                  label: 'Category',
                  value: 'All Categories',
                  icon: Icons.category_outlined,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _FilterField(
                  label: 'Sort By',
                  value: 'Nearest First',
                  icon: Icons.sort_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SwitchListTile.adaptive(
            value: showOnlyNew,
            onChanged: onShowOnlyNewChanged,
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Show only new requests',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            subtitle: Text(
              'Focus on fresh opportunities',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterField extends StatelessWidget {
  const _FilterField({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestOpportunityCard extends StatelessWidget {
  const _RequestOpportunityCard({required this.request});

  final _DashboardRequest request;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  request.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (request.isNew) const AppStatusChip(label: 'New'),
                  if (request.isUrgent)
                    const AppStatusChip(
                      label: 'Urgent',
                      tone: AppStatusTone.accent,
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'by ${request.customerName}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          Text(request.description,
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _RequestMeta(icon: Icons.place_outlined, label: request.distance),
              _RequestMeta(icon: Icons.schedule_rounded, label: request.age),
              _RequestMeta(
                icon: Icons.payments_outlined,
                label: request.budget,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => context.push(
                    RoutePaths.shopRequestDetailPath(request.id),
                  ),
                  icon: const Icon(Icons.reply_outlined, size: 18),
                  label: const Text('Respond'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push(
                    RoutePaths.shopRequestDetailPath(request.id),
                  ),
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('View Details'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RequestMeta extends StatelessWidget {
  const _RequestMeta({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _ToneIcon extends StatelessWidget {
  const _ToneIcon({
    required this.icon,
    required this.tone,
    this.size = 42,
  });

  final IconData icon;
  final AppStatusTone tone;
  final double size;

  @override
  Widget build(BuildContext context) {
    late final Color background;
    late final Color foreground;

    switch (tone) {
      case AppStatusTone.primary:
        background = AppColors.primarySoft;
        foreground = AppColors.primaryDark;
      case AppStatusTone.accent:
        background = AppColors.accentSoft;
        foreground = AppColors.accent;
      case AppStatusTone.blue:
        background = AppColors.blueSoft;
        foreground = AppColors.blue;
      case AppStatusTone.neutral:
        background = const Color(0xFFF2F5F4);
        foreground = AppColors.textMuted;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size / 2.6),
      ),
      child: Icon(icon, color: foreground, size: size * 0.52),
    );
  }
}

class _DashboardRequest {
  const _DashboardRequest({
    required this.id,
    required this.title,
    required this.customerName,
    required this.description,
    required this.distance,
    required this.age,
    required this.budget,
    this.isNew = false,
    this.isUrgent = false,
  });

  final String id;
  final String title;
  final String customerName;
  final String description;
  final String distance;
  final String age;
  final String budget;
  final bool isNew;
  final bool isUrgent;
}

const _nearbyRequests = [
  _DashboardRequest(
    id: 'red-hoodie-size-l',
    title: 'Looking for Red Hoodie',
    customerName: 'Rajesh K.',
    description:
        'Need a red hoodie, size L, preferably cotton material. Looking for good quality.',
    distance: '350m away',
    age: '10 minutes ago',
    budget: 'Rs. 2000-3000',
    isNew: true,
  ),
  _DashboardRequest(
    id: 'iphone-14-pro-case',
    title: 'iPhone 14 Pro Case',
    customerName: 'Priya S.',
    description:
        'Looking for a durable phone case for iPhone 14 Pro, preferably with drop protection.',
    distance: '1.2km away',
    age: '25 minutes ago',
    budget: 'Rs. 1500',
    isNew: true,
    isUrgent: true,
  ),
  _DashboardRequest(
    id: 'basmati-rice-2kg',
    title: '2kg Basmati Rice',
    customerName: 'Amit P.',
    description:
        'Need good quality basmati rice, 2kg pack. Prefer India Gate or similar brand.',
    distance: '500m away',
    age: '1 hour ago',
    budget: 'Rs. 800-1000',
  ),
  _DashboardRequest(
    id: 'wireless-headphones',
    title: 'Wireless Headphones',
    customerName: 'Sneha M.',
    description:
        'Looking for wireless headphones with good battery life. Budget friendly options preferred.',
    distance: '800m away',
    age: '2 hours ago',
    budget: 'Rs. 3000-5000',
    isNew: true,
  ),
  _DashboardRequest(
    id: 'yoga-mat',
    title: 'Yoga Mat',
    customerName: 'Maya L.',
    description:
        'Need a non-slip yoga mat, preferably 6mm thickness. Any color is fine.',
    distance: '1.5km away',
    age: '3 hours ago',
    budget: 'Rs. 1500-2000',
  ),
];
