import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/requests/domain/entities/shop_request.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';

class ShopRequestsScreen extends ConsumerWidget {
  const ShopRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(shopRequestsProvider);

    return AppStickyPage(
      bottomSafeArea: true,
      header: const AppScreenHeader(
        title: 'Incoming Requests',
        subtitle: 'Customer requests that match your shop categories.',
      ),
      child: requests.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Unable to load incoming requests.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'No matching requests yet. Add categories in your shop profile to receive requests.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            );
          }

          final pendingRequests = items
              .where((request) => !request.hasResponded)
              .toList(growable: false);
          final respondedRequests = items
              .where((request) => request.hasResponded)
              .toList(growable: false);

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              if (pendingRequests.isNotEmpty) ...[
                AppSectionHeader(
                  title: 'Needs response (${pendingRequests.length})',
                ),
                const SizedBox(height: 12),
                for (final item in pendingRequests) ...[
                  _IncomingRequestCard(request: item),
                  const SizedBox(height: 12),
                ],
              ],
              if (respondedRequests.isNotEmpty) ...[
                if (pendingRequests.isNotEmpty) const SizedBox(height: 8),
                AppSectionHeader(
                  title: 'Already responded (${respondedRequests.length})',
                ),
                const SizedBox(height: 12),
                for (final item in respondedRequests) ...[
                  _IncomingRequestCard(request: item),
                  const SizedBox(height: 12),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _IncomingRequestCard extends StatelessWidget {
  const _IncomingRequestCard({required this.request});

  final ShopRequest request;

  @override
  Widget build(BuildContext context) {
    final hasResponded = request.hasResponded;

    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => context.push(RoutePaths.shopRequestDetailPath(request.id)),
        child: Padding(
          padding: const EdgeInsets.all(18),
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
                  const SizedBox(width: 12),
                  AppStatusChip(
                    label: hasResponded ? 'Responded' : request.age,
                    tone: hasResponded
                        ? AppStatusTone.blue
                        : AppStatusTone.primary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (!hasResponded && request.isNew)
                    const AppStatusChip(label: 'New'),
                  if (request.isUrgent)
                    const AppStatusChip(
                      label: 'Urgent',
                      tone: AppStatusTone.accent,
                    ),
                  AppStatusChip(
                    label: request.category,
                    tone: AppStatusTone.neutral,
                  ),
                  if (hasResponded && request.respondedAgo.isNotEmpty)
                    AppStatusChip(
                      label: 'Edited ${request.respondedAgo}',
                      tone: AppStatusTone.neutral,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                request.subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (hasResponded) ...[
                const SizedBox(height: 14),
                _ResponsePreview(request: request),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.payments_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    request.budget,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => context.push(
                      RoutePaths.shopRequestDetailPath(request.id),
                    ),
                    icon: Icon(
                      hasResponded ? Icons.edit_outlined : Icons.reply_outlined,
                    ),
                    label: Text(hasResponded ? 'Edit Response' : 'Respond'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResponsePreview extends StatelessWidget {
  const _ResponsePreview({required this.request});

  final ShopRequest request;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blueSoft.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 18,
                color: AppColors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                'Your response',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.blue,
                    ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  request.responsePrice,
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
          if (request.responseMessage.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              request.responseMessage,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
