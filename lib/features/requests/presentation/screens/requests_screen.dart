import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/application/app_data_refresh.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/config/request_categories.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/network/connectivity_status.dart';
import 'package:grabbit/core/widgets/app_error_state.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/requests/data/repositories/api_requests_repository.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';

abstract final class _RequestAssets {
  static const addToCart = 'assets/images/home_add_to_cart.svg';
}

class RequestsScreen extends ConsumerWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(requestsProvider);
    final hasNetwork = ref.watch(networkConnectionProvider).valueOrNull ?? true;

    return Scaffold(
      body: AppStickyPage(
        header: AppScreenHeader(
          title: 'My Requests',
          subtitle: 'Track live responses and request status updates.',
        ),
        child: !hasNetwork
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: AppErrorState.offline(
                    onRetry: () => refreshSignedInData(ref),
                  ),
                ),
              )
            : requests.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AppErrorState.fromError(
                      error: error,
                      fallbackTitle: 'Unable to load requests',
                      fallbackMessage: 'Unable to load requests.',
                      onRetry: () => refreshSignedInData(ref),
                    ),
                  ),
                ),
                data: (items) {
                  final pendingRequests = items
                      .where((item) => item.status != RequestStatus.completed)
                      .toList(growable: false);
                  final completedRequests = items
                      .where((item) => item.status == RequestStatus.completed)
                      .toList(growable: false);

                  return _RequestTabs(
                    pendingRequests: pendingRequests,
                    completedRequests: completedRequests,
                    onRequestTap: (request) => context.push(
                      RoutePaths.requestResponsesPath(request.id),
                    ),
                    onDelete: (request) =>
                        _deleteRequest(context, ref, request),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _deleteRequest(
    BuildContext context,
    WidgetRef ref,
    RequestSummary request,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete request?'),
        content: Text(
          'This will remove "${request.title}" from your requests. Shops will no longer see it in incoming requests.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(requestsRepositoryProvider).deleteRequest(request.id);
      refreshSignedInData(ref);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request deleted.')),
      );
    } catch (error) {
      if (!context.mounted) return;
      final message =
          error is AppException ? error.message : 'Unable to delete request.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}

class _RequestTabs extends StatelessWidget {
  const _RequestTabs({
    required this.pendingRequests,
    required this.completedRequests,
    required this.onRequestTap,
    required this.onDelete,
  });

  final List<RequestSummary> pendingRequests;
  final List<RequestSummary> completedRequests;
  final ValueChanged<RequestSummary> onRequestTap;
  final ValueChanged<RequestSummary> onDelete;

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
                      child: Text('Pending (${pendingRequests.length})'),
                    ),
                  ),
                  Tab(
                    child: FittedBox(
                      child: Text('Completed (${completedRequests.length})'),
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
                  emptyMessage: 'No pending requests right now.',
                  onRequestTap: onRequestTap,
                  onDelete: onDelete,
                ),
                _RequestsTabList(
                  requests: completedRequests,
                  emptyMessage: 'Completed purchases will appear here.',
                  onRequestTap: onRequestTap,
                  onDelete: onDelete,
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
    required this.onRequestTap,
    required this.onDelete,
  });

  final List<RequestSummary> requests;
  final String emptyMessage;
  final ValueChanged<RequestSummary> onRequestTap;
  final ValueChanged<RequestSummary> onDelete;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                _RequestAssets.addToCart,
                width: 150,
                height: 112,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = requests[index];
        return _RequestCard(
          item: item,
          onTap: () => onRequestTap(item),
          onDelete: () => onDelete(item),
        );
      },
    );
  }
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.item,
    required this.onTap,
    required this.onDelete,
  });

  final RequestSummary item;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final tone = switch (item.status) {
      RequestStatus.active => AppStatusTone.primary,
      RequestStatus.pending => AppStatusTone.accent,
      RequestStatus.completed => AppStatusTone.blue,
    };
    final icon = switch (item.category) {
      RequestCategories.fashionClothing => Icons.checkroom_outlined,
      RequestCategories.electronicsMobileAccessories => Icons.devices_rounded,
      RequestCategories.groceriesFood => Icons.local_grocery_store_outlined,
      RequestCategories.beautyPersonalCare => Icons.spa_outlined,
      RequestCategories.homeKitchenAppliances => Icons.kitchen_outlined,
      RequestCategories.healthPharmacy => Icons.local_pharmacy_outlined,
      RequestCategories.booksStationery => Icons.menu_book_outlined,
      RequestCategories.babyKids => Icons.child_friendly_outlined,
      RequestCategories.sportsFitness => Icons.directions_run_outlined,
      RequestCategories.giftsLifestyle => Icons.card_giftcard_outlined,
      _ => Icons.receipt_long_outlined,
    };
    final badgeColor = switch (item.category) {
      RequestCategories.fashionClothing => AppColors.accentSoft,
      RequestCategories.electronicsMobileAccessories => AppColors.blueSoft,
      RequestCategories.groceriesFood => AppColors.primarySoft,
      RequestCategories.beautyPersonalCare => AppColors.accentSoft,
      RequestCategories.homeKitchenAppliances => AppColors.blueSoft,
      RequestCategories.healthPharmacy => AppColors.primarySoft,
      RequestCategories.booksStationery => AppColors.blueSoft,
      RequestCategories.babyKids => AppColors.accentSoft,
      RequestCategories.sportsFitness => AppColors.primarySoft,
      RequestCategories.giftsLifestyle => AppColors.accentSoft,
      _ => AppColors.primarySoft,
    };
    final badgeForeground = switch (item.category) {
      RequestCategories.fashionClothing => AppColors.accent,
      RequestCategories.electronicsMobileAccessories => AppColors.blue,
      RequestCategories.groceriesFood => AppColors.primaryDark,
      RequestCategories.beautyPersonalCare => AppColors.accent,
      RequestCategories.homeKitchenAppliances => AppColors.blue,
      RequestCategories.healthPharmacy => AppColors.primaryDark,
      RequestCategories.booksStationery => AppColors.blue,
      RequestCategories.babyKids => AppColors.accent,
      RequestCategories.sportsFitness => AppColors.primaryDark,
      RequestCategories.giftsLifestyle => AppColors.accent,
      _ => AppColors.primaryDark,
    };

    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppIconBadge(
                      icon: icon,
                      backgroundColor: badgeColor,
                      foregroundColor: badgeForeground,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.subtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppStatusChip(
                          label: _statusLabel(item.status),
                          tone: tone,
                        ),
                        const SizedBox(height: 8),
                        IconButton(
                          tooltip: 'Delete request',
                          onPressed: onDelete,
                          constraints: const BoxConstraints.tightFor(
                            width: 38,
                            height: 38,
                          ),
                          iconSize: 19,
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFFFECEE),
                            foregroundColor: const Color(0xFFE5484D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: const Icon(Icons.delete_outline_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item.time,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
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
          ),
        ),
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
