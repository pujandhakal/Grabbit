import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/widgets/app_primary_button.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/profile/data/repositories/shop_profile_repository.dart';
import 'package:grabbit/features/requests/data/repositories/api_requests_repository.dart';
import 'package:grabbit/features/requests/domain/entities/create_shop_response_payload.dart';
import 'package:grabbit/features/requests/domain/entities/request_summary.dart';
import 'package:grabbit/features/requests/domain/entities/shop_request.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';

class ShopRequestDetailScreen extends ConsumerStatefulWidget {
  const ShopRequestDetailScreen({
    required this.requestId,
    super.key,
  });

  final String requestId;

  @override
  ConsumerState<ShopRequestDetailScreen> createState() =>
      _ShopRequestDetailScreenState();
}

class _ShopRequestDetailScreenState
    extends ConsumerState<ShopRequestDetailScreen> {
  final _priceController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;
  String? _syncedRequestId;

  void _syncExistingResponse(ShopRequest request) {
    if (_syncedRequestId == request.id) {
      return;
    }

    if (request.hasResponded) {
      _priceController.text = request.responsePrice;
      _messageController.text = request.responseMessage;
    }
    _syncedRequestId = request.id;
  }

  @override
  void dispose() {
    _priceController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitResponse(ShopRequest request) async {
    if (request.status == RequestStatus.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completed responses cannot be edited.')),
      );
      return;
    }

    if (_priceController.text.trim().isEmpty ||
        _messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a price and message to respond.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final payload = CreateShopResponsePayload(
        requestId: widget.requestId,
        price: _priceController.text.trim(),
        message: _messageController.text.trim(),
      );

      if (request.hasResponded) {
        await ref.read(requestsRepositoryProvider).updateShopResponse(payload);
      } else {
        await ref.read(requestsRepositoryProvider).createShopResponse(payload);
      }

      ref.invalidate(shopRequestsProvider);
      ref.invalidate(requestResponsesProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            request.hasResponded
                ? 'Response updated.'
                : 'Response sent to customer.',
          ),
        ),
      );
      context.pop();
    } catch (error) {
      if (!mounted) return;
      final message = error is AppException
          ? error.message
          : 'Unable to send response. Please try again.';
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
    final request = ref.watch(shopRequestDetailProvider(widget.requestId));
    // Treat an unloaded profile as unverified so responding stays locked until
    // verification is confirmed. The backend enforces this regardless.
    final isVerified =
        ref.watch(shopProfileProvider).valueOrNull?.isVerified ?? false;

    return Scaffold(
      body: AppStickyPage(
        bottomSafeArea: true,
        header: AppScreenHeader(
          title: 'Request Detail',
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.chevron_left_rounded),
          ),
        ),
        child: request.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Unable to load this request.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          data: (item) {
            _syncExistingResponse(item);
            return _RequestResponseForm(
              request: item,
              isVerified: isVerified,
              priceController: _priceController,
              messageController: _messageController,
              isSubmitting: _isSubmitting,
              onSubmit: () {
                _submitResponse(item);
              },
            );
          },
        ),
      ),
    );
  }
}

class _RequestResponseForm extends StatelessWidget {
  const _RequestResponseForm({
    required this.request,
    required this.isVerified,
    required this.priceController,
    required this.messageController,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final ShopRequest request;
  final bool isVerified;
  final TextEditingController priceController;
  final TextEditingController messageController;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final isCompleted = request.status == RequestStatus.completed;
    // Unverified shops can read the request but cannot respond yet.
    final isLocked = !isCompleted && !isVerified;
    final fieldsReadOnly = isCompleted || isLocked;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        const AppSectionHeader(title: 'Customer request'),
        const SizedBox(height: 12),
        AppSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                request.description.isEmpty
                    ? request.subtitle
                    : request.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  Text(request.category),
                  Text(request.budget),
                  Text(request.distance),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppSectionHeader(
          title: isCompleted
              ? 'Completed response'
              : request.hasResponded
                  ? 'Edit response'
                  : 'Your response',
        ),
        const SizedBox(height: 12),
        AppSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                readOnly: fieldsReadOnly,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'e.g. Rs. 2,200'),
              ),
              const SizedBox(height: 14),
              Text(
                'Message',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: messageController,
                readOnly: fieldsReadOnly,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Share availability, pickup time, or offer details',
                ),
              ),
              const SizedBox(height: 18),
              if (isCompleted)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.blueSoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    'This purchase is completed. Your response is kept for history and cannot be edited.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.blue,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                )
              else if (isLocked) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.accent,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Your store is not verified yet. Complete your store '
                          'profile to unlock responding to customer requests '
                          'with your offers.',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.text,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                AppPrimaryButton(
                  label: 'Complete Store Profile',
                  icon: Icons.storefront_outlined,
                  onPressed: () => context.go(RoutePaths.shopProfile),
                ),
              ] else
                AppPrimaryButton(
                  label:
                      request.hasResponded ? 'Save Response' : 'Send Response',
                  icon: request.hasResponded
                      ? Icons.edit_outlined
                      : Icons.reply_outlined,
                  isLoading: isSubmitting,
                  onPressed: onSubmit,
                ),
              if (request.hasResponded && request.customerId.isNotEmpty) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => context.push(
                    '${RoutePaths.shopChatDetail}'
                    '?peerUserId=${request.customerId}'
                    '&requestId=${request.id}'
                    '&peer=${Uri.encodeComponent(request.customerName)}',
                  ),
                  icon: const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: AppColors.primaryDark,
                  ),
                  label: const Text('Message customer'),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
