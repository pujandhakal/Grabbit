import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/shop/domain/entities/shop_details.dart';
import 'package:grabbit/features/shop/presentation/controllers/shop_providers.dart';

class StoreDetailsScreen extends ConsumerWidget {
  const StoreDetailsScreen({
    required this.shopId,
    super.key,
  });

  final String shopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = ref.watch(shopDetailsProvider(shopId));

    return Scaffold(
      body: Stack(
        children: [
          AppStickyPage(
            header: AppScreenHeader(
              title: 'Store Details',
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
            ),
            child: details.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  'Unable to load store details.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              data: (shop) => ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 124),
                children: [
                  _StoreHeroCard(shop: shop),
                  const SizedBox(height: 16),
                  _AboutStoreCard(shop: shop),
                  const SizedBox(height: 16),
                  _CustomerReviewsCard(shop: shop),
                  const SizedBox(height: 16),
                  _RecentActivityCard(shop: shop),
                  const SizedBox(height: 16),
                  _LocationCard(shop: shop),
                ],
              ),
            ),
          ),
          const _StoreBottomActions(),
        ],
      ),
    );
  }
}

class _StoreHeroCard extends StatelessWidget {
  const _StoreHeroCard({
    required this.shop,
  });

  final ShopDetails shop;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppIconBadge(
                icon: Icons.storefront_rounded,
                size: 58,
                backgroundColor: AppColors.primarySoft,
                foregroundColor: AppColors.primaryDark,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _RatingLine(shop: shop),
                        _MetaItem(
                          icon: Icons.place_outlined,
                          label: shop.distance,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              AppStatusChip(label: shop.openStatus),
              const SizedBox(width: 10),
              Text(
                shop.closingTime,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AboutStoreCard extends StatelessWidget {
  const _AboutStoreCard({
    required this.shop,
  });

  final ShopDetails shop;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(title: 'About Store'),
          const SizedBox(height: 12),
          Text(
            shop.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text('Specialties:', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final specialty in shop.specialties)
                AppStatusChip(
                  label: specialty,
                  tone: _specialtyTone(specialty),
                ),
            ],
          ),
        ],
      ),
    );
  }

  AppStatusTone _specialtyTone(String specialty) {
    return switch (specialty) {
      'Fashion' => AppStatusTone.accent,
      'Accessories' => AppStatusTone.blue,
      'Footwear' => AppStatusTone.neutral,
      _ => AppStatusTone.primary,
    };
  }
}

class _CustomerReviewsCard extends StatelessWidget {
  const _CustomerReviewsCard({
    required this.shop,
  });

  final ShopDetails shop;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: 'Customer Reviews',
            actionLabel: 'See All',
            onActionTap: () {},
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop.rating,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Based on ${shop.reviewCount}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(width: 22),
              const Expanded(
                child: Column(
                  children: [
                    _RatingBreakdown(stars: '5', percent: '85%'),
                    SizedBox(height: 10),
                    _RatingBreakdown(stars: '4', percent: '60%'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          for (var index = 0; index < shop.reviews.length; index++) ...[
            if (index > 0) const Divider(height: 24),
            _ReviewTile(review: shop.reviews[index]),
          ],
        ],
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  const _RecentActivityCard({
    required this.shop,
  });

  final ShopDetails shop;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(title: 'Recent Activity'),
          const SizedBox(height: 12),
          const AppStatusChip(label: 'Fast Responder'),
          const SizedBox(height: 14),
          for (var index = 0; index < shop.activities.length; index++) ...[
            if (index > 0) const Divider(height: 22),
            _ActivityRow(activity: shop.activities[index]),
          ],
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.accentSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.accent,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This store typically responds within',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.text,
                        ),
                  ),
                ),
                Text(
                  shop.typicalResponseTime,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.accent,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard({
    required this.shop,
  });

  final ShopDetails shop;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(title: 'Location'),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: AppColors.primaryDark,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.address,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      shop.landmark,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StoreBottomActions extends StatelessWidget {
  const _StoreBottomActions();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.24),
                blurRadius: 36,
                spreadRadius: -4,
                offset: const Offset(0, 14),
              ),
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.14),
                blurRadius: 14,
                spreadRadius: -2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.directions_outlined),
                  label: const Text('Get Direction'),
                ),
              ),
              const SizedBox(width: 10),
              Tooltip(
                message: 'Contact Store',
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(52, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Icon(Icons.call_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RatingLine extends StatelessWidget {
  const _RatingLine({
    required this.shop,
  });

  final ShopDetails shop;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, size: 18, color: AppColors.accent),
        const SizedBox(width: 4),
        Text(shop.rating, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(width: 6),
        Text(
          '• ${shop.reviewCount}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
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

class _RatingBreakdown extends StatelessWidget {
  const _RatingBreakdown({
    required this.stars,
    required this.percent,
  });

  final String stars;
  final String percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 28,
          child: Row(
            children: [
              Text(stars, style: Theme.of(context).textTheme.bodySmall),
              const Icon(Icons.star_rounded, size: 14, color: AppColors.accent),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: percent == '85%' ? 0.85 : 0.60,
              minHeight: 8,
              color: AppColors.primary,
              backgroundColor: AppColors.outline,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(percent, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({
    required this.review,
  });

  final StoreReview review;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.blueSoft,
          child: Text(
            review.initials,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.blue,
                ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      review.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Text(
                    review.timeAgo,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(review.body, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.activity,
  });

  final StoreActivity activity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppIconBadge(icon: Icons.reply_rounded, size: 40),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Responded to a request for',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 3),
              Text(
                activity.product,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
        Text(activity.timeAgo, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
