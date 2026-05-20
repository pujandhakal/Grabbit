import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';

abstract final class _HomeAssets {
  static const businessShop = 'assets/images/home_business_shop.svg';
  static const addToCart = 'assets/images/home_add_to_cart.svg';
  static const groupProject = 'assets/images/home_group_project.svg';
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(requestsProvider);

    return Scaffold(
      body: AppStickyPage(
        header: const _Header(),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 130),
          children: [
            _RequestComposerCard(
              onPostRequest: () => context.push(RoutePaths.postRequest),
            ),
            const SizedBox(height: 20),
            _RequestStatusSummary(
              requests: requests,
              onViewRequests: () => context.go(RoutePaths.requests),
            ),
            const SizedBox(height: 20),
            const AppSectionHeader(title: 'Quick Actions'),
            const SizedBox(height: 12),
            _QuickActions(
              onPostRequest: () => context.push(RoutePaths.postRequest),
              onRequests: () => context.go(RoutePaths.requests),
              onChats: () => context.go(RoutePaths.chats),
              onProfile: () => context.go(RoutePaths.profile),
            ),
            const SizedBox(height: 20),
            const AppSectionHeader(title: 'GroupBuy'),
            const SizedBox(height: 12),
            const _GroupBuyComingSoonCard(),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.20),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'G',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Grabbit',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Kathmandu, Nepal',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RequestComposerCard extends StatelessWidget {
  const _RequestComposerCard({
    required this.onPostRequest,
  });

  final VoidCallback onPostRequest;

  @override
  Widget build(BuildContext context) {
    final suggestions = const [
      'Phone accessories',
      'Clothing',
      'Books',
      'Groceries',
      'Electronics',
    ];

    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onPostRequest,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 146,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(child: _RequestComposerCopy()),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 126,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              _HomeAssets.businessShop,
                              width: 122,
                              height: 78,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 8),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.shadow
                                        .withValues(alpha: 0.18),
                                    blurRadius: 18,
                                    spreadRadius: -6,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const SizedBox(
                                width: 120,
                                height: 54,
                                child: _RequestFlowAnimation(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: onPostRequest,
                  icon: const Icon(Icons.edit_note_rounded),
                  label: const Text('Post Request'),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final suggestion in suggestions)
                      ActionChip(
                        label: Text(suggestion),
                        avatar: const Icon(Icons.add_rounded, size: 16),
                        onPressed: onPostRequest,
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
}

class _RequestComposerCopy extends StatelessWidget {
  const _RequestComposerCopy();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'What are you looking for today?',
          style: TextStyle(
            color: AppColors.text,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1.12,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Post once. Nearby shops respond with offers.',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 14,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _RequestFlowAnimation extends StatefulWidget {
  const _RequestFlowAnimation();

  @override
  State<_RequestFlowAnimation> createState() => _RequestFlowAnimationState();
}

class _RequestFlowAnimationState extends State<_RequestFlowAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
      value: 0.08,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final mediaQuery = MediaQuery.maybeOf(context);
    final shouldReduceMotion = (mediaQuery?.disableAnimations ?? false) ||
        (mediaQuery?.accessibleNavigation ?? false);

    if (shouldReduceMotion) {
      _controller.stop();
      _controller.value = 0.58;
      return;
    }

    if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = Curves.easeInOut.transform(_controller.value);
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 12,
              child: _FlowNode(
                icon: Icons.receipt_long_outlined,
                color: AppColors.primary,
                active: _controller.value < 0.55,
              ),
            ),
            Positioned(
              right: 12,
              child: _FlowNode(
                icon: Icons.storefront_outlined,
                color: AppColors.accent,
                active: _controller.value >= 0.45,
              ),
            ),
            Positioned(
              left: 42 + (progress * 28),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue.withValues(alpha: 0.26),
                      blurRadius: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FlowNode extends StatelessWidget {
  const _FlowNode({
    required this.icon,
    required this.color,
    required this.active,
  });

  final IconData icon;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: active ? 48 : 42,
      height: active ? 48 : 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: active ? 0.18 : 0.10),
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: color.withValues(alpha: active ? 0.32 : 0.16)),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _RequestStatusSummary extends StatelessWidget {
  const _RequestStatusSummary({
    required this.requests,
    required this.onViewRequests,
  });

  final AsyncValue<List<RequestSummary>> requests;
  final VoidCallback onViewRequests;

  @override
  Widget build(BuildContext context) {
    return requests.when(
      loading: () => const _StatusLoadingCard(),
      error: (_, __) => _StatusMessageCard(
        title: 'Request status unavailable',
        body: 'Open My Requests to try loading your latest activity.',
        actionLabel: 'Open Requests',
        onAction: onViewRequests,
      ),
      data: (items) {
        final activeCount = items
            .where((item) =>
                item.status == RequestStatus.active ||
                item.status == RequestStatus.pending)
            .length;
        final completedCount = items
            .where((item) => item.status == RequestStatus.completed)
            .length;
        final totalResponses = items.fold<int>(
          0,
          (total, item) => total + _responseCount(item.responseText),
        );

        if (items.isEmpty) {
          return _StatusMessageCard(
            title: 'No requests yet',
            body: 'Post what you need and nearby shops can start responding.',
            actionLabel: 'Post Request',
            illustrationAsset: _HomeAssets.addToCart,
            onAction: () => context.push(RoutePaths.postRequest),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSectionHeader(
              title: 'Your Activity',
              actionLabel: 'View all',
              onActionTap: onViewRequests,
            ),
            const SizedBox(height: 12),
            AppSurfaceCard(
              child: Row(
                children: [
                  Expanded(
                    child: _StatusMetric(
                      label: 'Open',
                      value: activeCount.toString(),
                      icon: Icons.radar_rounded,
                      tone: AppStatusTone.primary,
                    ),
                  ),
                  Expanded(
                    child: _StatusMetric(
                      label: 'Offers',
                      value: totalResponses.toString(),
                      icon: Icons.local_offer_outlined,
                      tone: AppStatusTone.accent,
                    ),
                  ),
                  Expanded(
                    child: _StatusMetric(
                      label: 'Done',
                      value: completedCount.toString(),
                      icon: Icons.check_circle_outline_rounded,
                      tone: AppStatusTone.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  int _responseCount(String text) {
    final match = RegExp(r'\d+').firstMatch(text);
    return int.tryParse(match?.group(0) ?? '') ?? 0;
  }
}

class _StatusLoadingCard extends StatelessWidget {
  const _StatusLoadingCard();

  @override
  Widget build(BuildContext context) {
    return const AppSurfaceCard(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _StatusMessageCard extends StatelessWidget {
  const _StatusMessageCard({
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    this.illustrationAsset,
  });

  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;
  final String? illustrationAsset;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: illustrationAsset == null
                ? const AppIconBadge(
                    icon: Icons.receipt_long_outlined,
                    backgroundColor: AppColors.primarySoft,
                    foregroundColor: AppColors.primaryDark,
                  )
                : SvgPicture.asset(
                    illustrationAsset!,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(body, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: onAction,
                  icon: const Icon(Icons.chevron_right_rounded),
                  label: Text(actionLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusMetric extends StatelessWidget {
  const _StatusMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.tone,
  });

  final String label;
  final String value;
  final IconData icon;
  final AppStatusTone tone;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      AppStatusTone.primary => AppColors.primaryDark,
      AppStatusTone.accent => AppColors.accent,
      AppStatusTone.blue => AppColors.blue,
      AppStatusTone.neutral => AppColors.textMuted,
    };
    final background = switch (tone) {
      AppStatusTone.primary => AppColors.primarySoft,
      AppStatusTone.accent => AppColors.accentSoft,
      AppStatusTone.blue => AppColors.blueSoft,
      AppStatusTone.neutral => const Color(0xFFF2F5F4),
    };

    return Column(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: color, size: 21),
        ),
        const SizedBox(height: 8),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onPostRequest,
    required this.onRequests,
    required this.onChats,
    required this.onProfile,
  });

  final VoidCallback onPostRequest;
  final VoidCallback onRequests;
  final VoidCallback onChats;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          _QuickActionTile(
            icon: Icons.edit_note_rounded,
            title: 'Post another request',
            subtitle: 'Tell nearby shops what you need',
            onTap: onPostRequest,
          ),
          const Divider(height: 1),
          _QuickActionTile(
            icon: Icons.receipt_long_outlined,
            title: 'My requests',
            subtitle: 'Track offers and completed purchases',
            onTap: onRequests,
          ),
          const Divider(height: 1),
          _QuickActionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'Chats',
            subtitle: 'Follow up with shops',
            onTap: onChats,
          ),
          const Divider(height: 1),
          _QuickActionTile(
            icon: Icons.person_outline_rounded,
            title: 'Profile',
            subtitle: 'Manage addresses and preferences',
            onTap: onProfile,
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              AppIconBadge(
                icon: icon,
                size: 40,
                backgroundColor: AppColors.primarySoft,
                foregroundColor: AppColors.primaryDark,
              ),
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

class _GroupBuyComingSoonCard extends StatelessWidget {
  const _GroupBuyComingSoonCard();

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('GroupBuy is coming soon.')),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 92,
                  height: 98,
                  child: SvgPicture.asset(
                    _HomeAssets.groupProject,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'GroupBuy is coming soon',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const AppStatusChip(
                            label: 'Coming Soon',
                            tone: AppStatusTone.blue,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Team up with nearby buyers to unlock better prices from local shops.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          AppStatusChip(
                            label: 'Local shops',
                            tone: AppStatusTone.neutral,
                          ),
                          AppStatusChip(
                            label: 'Better prices',
                            tone: AppStatusTone.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.notifications_none_rounded),
                        label: const Text('Notify me later'),
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
