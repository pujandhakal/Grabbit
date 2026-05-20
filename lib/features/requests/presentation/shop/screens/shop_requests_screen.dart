import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/domain/entities/shop_request.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';

abstract final class _ShopRequestAssets {
  static const envelope = 'assets/images/shop_envelope.svg';
}

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
            return const _ShopRequestsEmptyState(
              message:
                  'No matching requests yet. Add categories in your shop profile to receive requests.',
            );
          }

          final pendingRequests = items
              .where((request) => !request.hasResponded)
              .toList(growable: false);
          final respondedRequests = items
              .where((request) => request.hasResponded)
              .toList(growable: false);

          return _IncomingRequestsTabs(
            pendingRequests: pendingRequests,
            respondedRequests: respondedRequests,
          );
        },
      ),
    );
  }
}

class _IncomingRequestsTabs extends StatelessWidget {
  const _IncomingRequestsTabs({
    required this.pendingRequests,
    required this.respondedRequests,
  });

  final List<ShopRequest> pendingRequests;
  final List<ShopRequest> respondedRequests;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: AppSurfaceCard(
              padding: const EdgeInsets.all(6),
              radius: 22,
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textMuted,
                labelStyle: Theme.of(context).textTheme.titleSmall,
                unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                tabs: [
                  Tab(
                    child: FittedBox(
                      child: Text('Needs Response (${pendingRequests.length})'),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      child: Text(
                        'Already Responded (${respondedRequests.length})',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _RequestsTabList(
                  requests: pendingRequests,
                  emptyMessage: 'No requests need a response right now.',
                ),
                _RequestsTabList(
                  requests: respondedRequests,
                  emptyMessage: 'Responses you send will appear here.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RequestsTabList extends StatelessWidget {
  const _RequestsTabList({
    required this.requests,
    required this.emptyMessage,
  });

  final List<ShopRequest> requests;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return _ShopRequestsEmptyState(message: emptyMessage);
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _IncomingRequestCard(request: requests[index]);
      },
    );
  }
}

class _ShopRequestsEmptyState extends StatelessWidget {
  const _ShopRequestsEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              _ShopRequestAssets.envelope,
              width: 156,
              height: 116,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
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
    final isCompleted = request.status == RequestStatus.completed;

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
                    label: isCompleted
                        ? 'Completed'
                        : hasResponded
                            ? 'Responded'
                            : request.age,
                    tone: isCompleted
                        ? AppStatusTone.blue
                        : hasResponded
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
                      isCompleted
                          ? Icons.visibility_outlined
                          : hasResponded
                              ? Icons.edit_outlined
                              : Icons.reply_outlined,
                    ),
                    label: Text(
                      isCompleted
                          ? 'View Response'
                          : hasResponded
                              ? 'Edit Response'
                              : 'Respond',
                    ),
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
