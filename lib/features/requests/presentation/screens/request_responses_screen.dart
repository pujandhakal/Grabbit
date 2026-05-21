import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/application/app_data_refresh.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/marketplace/data/repositories/api_shops_repository.dart';
import 'package:grabbit/features/requests/data/repositories/api_requests_repository.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/domain/entities/shop_response.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';

enum _ResponseFilter { all, nearest }

class RequestResponsesScreen extends ConsumerStatefulWidget {
  const RequestResponsesScreen({
    required this.requestId,
    super.key,
  });

  final String requestId;

  @override
  ConsumerState<RequestResponsesScreen> createState() =>
      _RequestResponsesScreenState();
}

class _RequestResponsesScreenState
    extends ConsumerState<RequestResponsesScreen> {
  var _filter = _ResponseFilter.all;

  @override
  Widget build(BuildContext context) {
    final responses = ref.watch(requestResponsesProvider(widget.requestId));
    final request = responses.valueOrNull?.request;
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
          trailing: IconButton(
            tooltip: 'Delete request',
            onPressed: request == null
                ? null
                : () => _deleteRequest(context, ref, request),
            icon: const Icon(Icons.delete_outline_rounded),
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
          data: (data) {
            final responses = _filteredResponses(data.responses);
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                _RequestSummaryCard(request: data.request),
                const SizedBox(height: 16),
                _ResponseFilters(
                  selected: _filter,
                  onChanged: (filter) => setState(() {
                    _filter = filter;
                  }),
                ),
                const SizedBox(height: 16),
                ...responses.map(
                  (response) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ShopResponseCard(
                      response: response,
                      requestId: widget.requestId,
                      requestStatus: data.request.status,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<ShopResponse> _filteredResponses(List<ShopResponse> responses) {
    if (_filter == _ResponseFilter.all) {
      return responses;
    }

    final sorted = [...responses];
    sorted.sort((a, b) {
      return _distanceSortValue(a.distance)
          .compareTo(_distanceSortValue(b.distance));
    });
    return sorted;
  }

  double _distanceSortValue(String distance) {
    final normalized = distance.trim().toLowerCase();
    if (normalized == 'nearby') return 0;

    final match = RegExp(r'(\d+(?:\.\d+)?)\s*(km|m)').firstMatch(normalized);
    if (match == null) return double.infinity;

    final value = double.tryParse(match.group(1) ?? '');
    if (value == null) return double.infinity;

    return match.group(2) == 'km' ? value * 1000 : value;
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
      context.pop();
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

class _ResponseFilters extends StatelessWidget {
  const _ResponseFilters({
    required this.selected,
    required this.onChanged,
  });

  final _ResponseFilter selected;
  final ValueChanged<_ResponseFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        ChoiceChip(
          label: const Text('All Shops'),
          selected: selected == _ResponseFilter.all,
          selectedColor: AppColors.primarySoft,
          onSelected: (_) => onChanged(_ResponseFilter.all),
          labelStyle: TextStyle(
            color: selected == _ResponseFilter.all
                ? AppColors.primaryDark
                : AppColors.textMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
        ChoiceChip(
          label: const Text('Nearest First'),
          selected: selected == _ResponseFilter.nearest,
          selectedColor: AppColors.primarySoft,
          onSelected: (_) => onChanged(_ResponseFilter.nearest),
          labelStyle: TextStyle(
            color: selected == _ResponseFilter.nearest
                ? AppColors.primaryDark
                : AppColors.textMuted,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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

class _ShopResponseCard extends ConsumerStatefulWidget {
  const _ShopResponseCard({
    required this.response,
    required this.requestId,
    required this.requestStatus,
  });

  final ShopResponse response;
  final String requestId;
  final RequestStatus requestStatus;

  @override
  ConsumerState<_ShopResponseCard> createState() => _ShopResponseCardState();
}

class _ShopResponseCardState extends ConsumerState<_ShopResponseCard> {
  bool _isCompleting = false;

  Future<void> _markPurchased() async {
    if (widget.response.shopUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Purchase confirmation is not available.')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark purchase complete?'),
        content: Text(
          'Confirm that you purchased this item from ${widget.response.name}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isCompleting = true;
    });

    try {
      await ref.read(requestsRepositoryProvider).completeRequestPurchase(
            requestId: widget.requestId,
            shopUserId: widget.response.shopUserId,
          );
      ref.invalidate(requestsProvider);
      ref.invalidate(requestResponsesProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase marked complete.')),
      );
      await _showRatingSheet();
    } catch (error) {
      if (!mounted) return;
      final message = error is AppException
          ? error.message
          : 'Unable to complete this purchase.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
    }
  }

  Future<void> _showRatingSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _RatingSheet(
        shopName: widget.response.name,
        onSubmit: (rating, body) async {
          await ref.read(shopsRepositoryProvider).submitReview(
                shopId: widget.response.shopId,
                requestId: widget.requestId,
                rating: rating,
                body: body,
              );
          ref.invalidate(requestResponsesProvider);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final response = widget.response;
    final isCompleted = widget.requestStatus == RequestStatus.completed;
    Widget buildViewStoreButton() => OutlinedButton.icon(
          onPressed: () => context.push(
            RoutePaths.storeDetailsPath(response.shopId),
          ),
          icon: const Icon(Icons.storefront_outlined, size: 18),
          label: const Text('View Store'),
        );

    Widget buildMessageButton() => IconButton(
          onPressed: response.shopUserId.isEmpty
              ? null
              : () => context.push(
                    '${RoutePaths.chatDetail}'
                    '?peerUserId=${response.shopUserId}'
                    '&requestId=${widget.requestId}'
                    '&peer=${Uri.encodeComponent(response.name)}',
                  ),
          constraints: const BoxConstraints.tightFor(width: 44, height: 44),
          iconSize: 20,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.primarySoft,
            foregroundColor: AppColors.primaryDark,
            disabledBackgroundColor: AppColors.outline.withValues(alpha: 0.25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: const Icon(Icons.chat_bubble_outline_rounded),
          tooltip: response.shopUserId.isEmpty
              ? 'Messaging not available yet'
              : 'Message ${response.name}',
        );

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
              Expanded(child: buildViewStoreButton()),
              const SizedBox(width: 10),
              buildMessageButton(),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: isCompleted || _isCompleting ? null : _markPurchased,
              icon: _isCompleting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.shopping_bag_outlined, size: 18),
              label: Text(isCompleted ? 'Purchased' : 'Mark Purchased'),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingSheet extends StatefulWidget {
  const _RatingSheet({
    required this.shopName,
    required this.onSubmit,
  });

  final String shopName;
  final Future<void> Function(int rating, String body) onSubmit;

  @override
  State<_RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<_RatingSheet> {
  final _bodyController = TextEditingController();
  var _rating = 5;
  var _isSubmitting = false;

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(_rating, _bodyController.text.trim());
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thanks for rating this shop.')),
      );
    } catch (error) {
      if (!mounted) return;
      final message =
          error is AppException ? error.message : 'Unable to submit rating.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Rate ${widget.shopName}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              'Your rating helps other customers choose trusted shops.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    onPressed: () => setState(() => _rating = i),
                    icon: Icon(
                      i <= _rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: AppColors.accent,
                      size: 34,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _bodyController,
              minLines: 3,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Share what went well with this purchase',
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.star_rounded),
              label: const Text('Submit Rating'),
            ),
          ],
        ),
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
