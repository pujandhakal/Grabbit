import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/domain/entities/shop_response.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';

class RequestResponsesScreen extends ConsumerWidget {
  const RequestResponsesScreen({
    required this.requestId,
    super.key,
  });

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final responses = ref.watch(requestResponsesProvider(requestId));
    final subtitle = responses.maybeWhen(
      data: (data) => '${data.responses.length} shops have responded',
      orElse: () => 'Loading shop responses',
    );

    return Scaffold(
      body: AppStickyPage(
        bottomSafeArea: true,
        header: AppScreenHeader(
          title: 'Responses',
          subtitle: subtitle,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.chevron_left_rounded),
          ),
        ),
        child: responses.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              'Unable to load responses.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          data: (data) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _RequestSummaryCard(request: data.request),
              const SizedBox(height: 16),
              const Row(
                children: [
                  AppStatusChip(label: 'Nearest First'),
                  SizedBox(width: 10),
                  AppStatusChip(label: 'All Shops', tone: AppStatusTone.blue),
                ],
              ),
              const SizedBox(height: 16),
              ...data.responses.map(
                (response) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ShopResponseCard(response: response),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestSummaryCard extends StatelessWidget {
  const _RequestSummaryCard({
    required this.request,
  });

  final RequestSummary request;

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
                icon: Icons.checkroom_outlined,
                backgroundColor: AppColors.accentSoft,
                foregroundColor: AppColors.accent,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        AppStatusChip(label: _statusLabel(request.status)),
                        AppStatusChip(
                          label: request.category,
                          tone: AppStatusTone.accent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                request.postedAt,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
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

class _ShopResponseCard extends StatelessWidget {
  const _ShopResponseCard({
    required this.response,
  });

  final ShopResponse response;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: AppColors.primarySoft,
                child: Text(
                  response.name.characters.first,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryDark,
                      ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      response.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _MetaItem(
                          icon: Icons.place_outlined,
                          label: response.distance,
                        ),
                        _MetaItem(
                          icon: Icons.access_time_rounded,
                          label: response.respondedAgo,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _RatingBadge(response: response),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            response.message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  'Offered Price:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryDark,
                      ),
                ),
                const Spacer(),
                Text(
                  response.price,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primaryDark,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push(
                    RoutePaths.storeDetailsPath(response.shopId),
                  ),
                  icon: const Icon(Icons.storefront_outlined),
                  label: const Text('View Store'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {},
                constraints: const BoxConstraints.tightFor(
                  width: 40,
                  height: 40,
                ),
                iconSize: 20,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primarySoft,
                  foregroundColor: AppColors.primaryDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                tooltip: 'Message shop',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({
    required this.response,
  });

  final ShopResponse response;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star_rounded,
              size: 18,
              color: AppColors.accent,
            ),
            const SizedBox(width: 3),
            Text(
              response.rating,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          response.reviews,
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
        Icon(icon, size: 15, color: AppColors.textMuted),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
