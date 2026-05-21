import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_discovery_radar.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_soft_background.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/chat/data/repositories/chat_repository.dart';
import 'package:grabbit/features/profile/data/repositories/shop_profile_repository.dart';
import 'package:grabbit/features/profile/domain/entities/shop_profile.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';

class ShopDashboardScreen extends ConsumerWidget {
  const ShopDashboardScreen({super.key});

  static const double _expandedHeight = 140;
  static const double _collapsedHeight = 72;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topInset = MediaQuery.of(context).padding.top;
    final profileAsync = ref.watch(shopProfileProvider);
    final requestsAsync = ref.watch(shopRequestsProvider);
    final chatsAsync = ref.watch(chatThreadsProvider);
    final profile = profileAsync.valueOrNull;

    final pendingCount = requestsAsync.valueOrNull
        ?.where((request) => !request.hasResponded)
        .length;
    final respondedCount = requestsAsync.valueOrNull
        ?.where((request) => request.hasResponded)
        .length;
    final unreadChatCount = chatsAsync.valueOrNull?.fold<int>(
      0,
      (total, thread) => total + thread.unreadCount,
    );

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
                return _CollapsibleShopHeader(
                  t: t,
                  profile: profile,
                );
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                _StoreStatusCard(profileAsync: profileAsync),
                const SizedBox(height: 18),
                const AppSectionHeader(title: 'Today at a glance'),
                const SizedBox(height: 12),
                _MetricsGrid(
                  profile: profile,
                  pendingCount: pendingCount,
                  respondedCount: respondedCount,
                  unreadChatCount: unreadChatCount,
                ),
                const SizedBox(height: 18),
                _NextActionCard(
                  isVerified: profile?.isVerified ?? false,
                  pendingCount: pendingCount,
                  unreadChatCount: unreadChatCount,
                ),
                const SizedBox(height: 18),
                const AppSectionHeader(title: 'Quick actions'),
                const SizedBox(height: 12),
                const _QuickActionsCard(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleShopHeader extends StatelessWidget {
  const _CollapsibleShopHeader({
    required this.t,
    required this.profile,
  });

  final double t;
  final ShopProfile? profile;

  @override
  Widget build(BuildContext context) {
    final avatarRadius = lerpDouble(18, 30, t)!;
    final subtitleGap = lerpDouble(0, 4, t)!;
    final chipsGap = lerpDouble(0, 10, t)!;
    final alignY = lerpDouble(0, 1, t)!;
    final backgroundOpacity = lerpDouble(0.42, 0.96, 1 - t)!;
    final shopName = profile?.businessName ?? 'My Shop';
    final initials = profile?.initials ?? 'MS';
    final categoryText = profile?.categories.isNotEmpty == true
        ? profile!.categories.take(2).join(' & ')
        : 'Set up your store categories';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: backgroundOpacity),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outline.withValues(alpha: 1 - t),
          ),
        ),
      ),
      child: SafeArea(
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
                        initials,
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
                            decoration: BoxDecoration(
                              color: profile?.isVerified == true
                                  ? AppColors.primary
                                  : AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              profile?.isVerified == true
                                  ? Icons.check_rounded
                                  : Icons.priority_high_rounded,
                              color: Colors.white,
                              size: 14,
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
                        shopName,
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
                              categoryText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                AppStatusChip(
                                  label: profile?.isVerified == true
                                      ? 'Verified'
                                      : 'Needs setup',
                                ),
                                if ((profile?.openStatus ?? '').isNotEmpty)
                                  AppStatusChip(
                                    label: profile!.openStatus,
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
      ),
    );
  }
}

class _StoreStatusCard extends StatelessWidget {
  const _StoreStatusCard({required this.profileAsync});

  final AsyncValue<ShopProfile> profileAsync;

  @override
  Widget build(BuildContext context) {
    final profile = profileAsync.valueOrNull;
    final isVerified = profile?.isVerified ?? false;
    final title = isVerified ? 'Store is visible' : 'Verify Your Store';
    final body = isVerified
        ? 'Customers can view your public store details after you respond.'
        : 'Complete your public store details so customers can trust your responses.';

    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppIconBadge(
                icon: isVerified
                    ? Icons.storefront_outlined
                    : Icons.verified_outlined,
                backgroundColor:
                    isVerified ? AppColors.primarySoft : AppColors.accentSoft,
                foregroundColor:
                    isVerified ? AppColors.primaryDark : AppColors.accent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        AppStatusChip(
                          label: isVerified ? 'Verified' : 'Incomplete',
                          tone: isVerified
                              ? AppStatusTone.primary
                              : AppStatusTone.accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(body, style: Theme.of(context).textTheme.bodyMedium),
                    if (profileAsync.isLoading) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Checking store status...',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => context.go(RoutePaths.shopProfile),
                      icon: const Icon(Icons.storefront_outlined),
                      label: Text(
                          isVerified ? 'Manage Store' : 'Complete Details'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const SizedBox(
            height: 92,
            width: double.infinity,
            child: AppDiscoveryRadar(
              nodeSide: RadarNodeSide.right,
              nodeIcon: Icons.storefront_rounded,
              pins: [
                RadarPin(
                  fx: 0.12,
                  fy: 0.30,
                  color: AppColors.blue,
                  glyph: Icons.shopping_bag_outlined,
                ),
                RadarPin(
                  fx: 0.30,
                  fy: 0.74,
                  color: AppColors.accent,
                  glyph: Icons.search_rounded,
                ),
                RadarPin(
                  fx: 0.48,
                  fy: 0.40,
                  color: AppColors.primaryDark,
                  glyph: Icons.local_mall_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({
    required this.profile,
    required this.pendingCount,
    required this.respondedCount,
    required this.unreadChatCount,
  });

  final ShopProfile? profile;
  final int? pendingCount;
  final int? respondedCount;
  final int? unreadChatCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.18,
      children: [
        _MetricCard(
          title: 'Needs Response',
          value: _countLabel(pendingCount),
          caption: 'Open incoming tab',
          icon: Icons.near_me_outlined,
          tone: AppStatusTone.primary,
          onTap: () => context.go(RoutePaths.shopRequests),
        ),
        _MetricCard(
          title: 'Active Responses',
          value: _countLabel(respondedCount),
          caption: 'Offers sent',
          icon: Icons.send_outlined,
          tone: AppStatusTone.blue,
          onTap: () => context.go(RoutePaths.shopRequests),
        ),
        _MetricCard(
          title: 'Unread Chats',
          value: _countLabel(unreadChatCount),
          caption: 'Customer replies',
          icon: Icons.mark_chat_unread_outlined,
          tone: AppStatusTone.accent,
          onTap: () => context.go(RoutePaths.shopChats),
        ),
        _MetricCard(
          title: 'Shop Rating',
          value: profile == null
              ? '-'
              : profile!.reviewCount == 0
                  ? '-'
                  : profile!.rating.toStringAsFixed(1),
          caption: profile == null
              ? 'Loading reviews'
              : profile!.reviewCount == 0
                  ? 'No ratings yet'
                  : '${profile!.reviewCount} reviews',
          icon: Icons.star_border_rounded,
          tone: AppStatusTone.neutral,
          onTap: () => context.go(RoutePaths.shopProfile),
        ),
      ],
    );
  }

  String _countLabel(int? count) {
    return count == null ? '-' : count.toString();
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.caption,
    required this.icon,
    required this.tone,
    required this.onTap,
  });

  final String title;
  final String value;
  final String caption;
  final IconData icon;
  final AppStatusTone tone;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
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
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NextActionCard extends StatelessWidget {
  const _NextActionCard({
    required this.isVerified,
    required this.pendingCount,
    required this.unreadChatCount,
  });

  final bool isVerified;
  final int? pendingCount;
  final int? unreadChatCount;

  @override
  Widget build(BuildContext context) {
    final action = _nextAction();

    return AppSurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIconBadge(
            icon: action.icon,
            backgroundColor: action.tone == AppStatusTone.accent
                ? AppColors.accentSoft
                : AppColors.primarySoft,
            foregroundColor: action.tone == AppStatusTone.accent
                ? AppColors.accent
                : AppColors.primaryDark,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(action.title,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(action.body,
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.go(action.route),
                  icon: Icon(action.buttonIcon),
                  label: Text(action.buttonLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _DashboardAction _nextAction() {
    if (!isVerified) {
      return const _DashboardAction(
        title: 'Complete your store profile',
        body:
            'Verified store details make your responses more useful to customers.',
        buttonLabel: 'Verify Store',
        route: RoutePaths.shopProfile,
        icon: Icons.verified_outlined,
        buttonIcon: Icons.storefront_outlined,
        tone: AppStatusTone.accent,
      );
    }

    if ((pendingCount ?? 0) > 0) {
      return _DashboardAction(
        title: '${pendingCount ?? 0} requests need attention',
        body:
            'Open Incoming Requests to respond while the opportunity is fresh.',
        buttonLabel: 'Review Requests',
        route: RoutePaths.shopRequests,
        icon: Icons.reply_outlined,
        buttonIcon: Icons.near_me_outlined,
        tone: AppStatusTone.primary,
      );
    }

    if ((unreadChatCount ?? 0) > 0) {
      return _DashboardAction(
        title: '${unreadChatCount ?? 0} unread customer messages',
        body: 'Customers are waiting for your reply in Shop Chats.',
        buttonLabel: 'Open Chats',
        route: RoutePaths.shopChats,
        icon: Icons.chat_bubble_outline_rounded,
        buttonIcon: Icons.mark_chat_unread_outlined,
        tone: AppStatusTone.primary,
      );
    }

    return const _DashboardAction(
      title: 'You are caught up',
      body: 'No pending requests or unread chats right now.',
      buttonLabel: 'View Requests',
      route: RoutePaths.shopRequests,
      icon: Icons.check_circle_outline_rounded,
      buttonIcon: Icons.near_me_outlined,
      tone: AppStatusTone.primary,
    );
  }
}

class _DashboardAction {
  const _DashboardAction({
    required this.title,
    required this.body,
    required this.buttonLabel,
    required this.route,
    required this.icon,
    required this.buttonIcon,
    required this.tone,
  });

  final String title;
  final String body;
  final String buttonLabel;
  final String route;
  final IconData icon;
  final IconData buttonIcon;
  final AppStatusTone tone;
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          _QuickActionTile(
            icon: Icons.near_me_outlined,
            title: 'Incoming Requests',
            subtitle: 'Review matching customer requests',
            onTap: () => context.go(RoutePaths.shopRequests),
          ),
          const Divider(height: 1),
          _QuickActionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Shop Chats',
            subtitle: 'Follow up with customers',
            onTap: () => context.go(RoutePaths.shopChats),
          ),
          const Divider(height: 1),
          _QuickActionTile(
            icon: Icons.storefront_outlined,
            title: 'Store Profile',
            subtitle: 'Manage public store details',
            onTap: () => context.go(RoutePaths.shopProfile),
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              _ToneIcon(icon: icon, tone: AppStatusTone.neutral, size: 38),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded,
                  color: AppColors.textMuted),
            ],
          ),
        ),
      ),
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
