import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/profile/data/repositories/shop_profile_repository.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';

class ShopSettingsScreen extends ConsumerStatefulWidget {
  const ShopSettingsScreen({super.key});

  @override
  ConsumerState<ShopSettingsScreen> createState() => _ShopSettingsScreenState();
}

class _ShopSettingsScreenState extends ConsumerState<ShopSettingsScreen> {
  bool _isSaving = false;

  Future<void> _setShowAll(bool showAll) async {
    setState(() => _isSaving = true);
    try {
      await ref.read(shopProfileRepositoryProvider).updateRequestVisibility(
            showAll,
          );
      ref.invalidate(shopProfileProvider);
      ref.invalidate(shopRequestsProvider);
    } catch (error) {
      if (!mounted) return;
      final message = error is AppException
          ? error.message
          : 'Unable to update settings. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(shopProfileProvider);

    return Scaffold(
      body: AppStickyPage(
        bottomSafeArea: true,
        header: AppScreenHeader(
          title: 'Settings',
          subtitle: 'Control how Grabbit works for your store.',
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.chevron_left_rounded),
          ),
        ),
        child: profile.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Unable to load settings.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
          data: (data) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                const AppSectionHeader(title: 'Incoming requests'),
                const SizedBox(height: 12),
                AppSurfaceCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: SwitchListTile(
                    value: data.showAllRequests,
                    onChanged: _isSaving ? null : _setShowAll,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    title: Text(
                      'Show all requests',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        data.showAllRequests
                            ? 'You see every nearby customer request.'
                            : 'You only see requests in your selected '
                                'categories.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    'Turn this off to only receive requests that match the '
                    'categories set in your store profile.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
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
}
