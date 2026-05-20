import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/application/app_data_refresh.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/network/connectivity_status.dart';
import 'package:grabbit/core/widgets/app_error_state.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:grabbit/features/profile/data/repositories/customer_profile_repository.dart';
import 'package:grabbit/features/profile/presentation/widgets/delete_account_sheet.dart';

const _dangerColor = Color(0xFFE5484D);
const _dangerSoftColor = Color(0xFFFFECEE);

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(customerProfileProvider);
    final hasNetwork = ref.watch(networkConnectionProvider).valueOrNull ?? true;

    return Scaffold(
      body: AppStickyPage(
        header: const AppScreenHeader(title: 'Profile'),
        child: !hasNetwork
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: AppErrorState.offline(
                    onRetry: () => refreshSignedInData(ref),
                  ),
                ),
              )
            : profile.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: AppErrorState.fromError(
                      error: error,
                      fallbackTitle: 'Unable to load profile',
                      fallbackMessage: 'Unable to load profile.',
                      onRetry: () => refreshSignedInData(ref),
                    ),
                  ),
                ),
                data: (profile) {
                  final name = profile.user.name;
                  final initial = name.trim().isNotEmpty
                      ? name.trim()[0].toUpperCase()
                      : 'C';
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
                    children: [
                      _ProfileHeaderCard(
                        initial: initial,
                        name: name,
                        email: profile.user.email,
                        phone: profile.user.phone.isEmpty
                            ? 'Phone not added'
                            : profile.user.phone,
                        requests: profile.stats.totalRequests.toString(),
                        completed: profile.stats.completedRequests.toString(),
                        reviews: profile.stats.reviewCount.toString(),
                      ),
                      const SizedBox(height: 18),
                      const AppSectionHeader(title: 'Account'),
                      const SizedBox(height: 12),
                      _ProfileSectionCard(
                        rows: [
                          _ProfileRow(
                            icon: Icons.edit_outlined,
                            label: 'Edit Profile',
                            onTap: () => context.push(RoutePaths.editProfile),
                          ),
                          _ProfileRow(
                            icon: Icons.location_on_outlined,
                            label: 'Saved Addresses',
                            badge: profile.addresses.length.toString(),
                            onTap: () =>
                                context.push(RoutePaths.savedAddresses),
                          ),
                          _ProfileRow(
                            icon: Icons.star_border_rounded,
                            label: 'My Reviews',
                            badge: profile.stats.reviewCount.toString(),
                            onTap: () => context.push(RoutePaths.myReviews),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const AppSectionHeader(title: 'Settings'),
                      const SizedBox(height: 12),
                      _ProfileSectionCard(
                        rows: [
                          _ProfileRow(
                            icon: Icons.notifications_outlined,
                            label: 'Notifications',
                            badge: profile.enabledNotificationCount.toString(),
                            onTap: () =>
                                context.push(RoutePaths.notificationSettings),
                          ),
                          _ProfileRow(
                            icon: Icons.tune_rounded,
                            label: 'Request Defaults',
                            badge: profile.preferences.categories.isEmpty
                                ? null
                                : profile.preferences.categories.length
                                    .toString(),
                            onTap: () =>
                                context.push(RoutePaths.requestDefaults),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const AppSectionHeader(title: 'Support'),
                      const SizedBox(height: 12),
                      _ProfileSectionCard(
                        rows: [
                          _ProfileRow(
                            icon: Icons.help_outline_rounded,
                            label: 'Help & Support',
                            onTap: () => context.push(RoutePaths.helpSupport),
                          ),
                          _ProfileRow(
                            icon: Icons.description_outlined,
                            label: 'Terms & Conditions',
                            onTap: () =>
                                context.push(RoutePaths.termsConditions),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      const AppSectionHeader(title: 'Danger Zone'),
                      const SizedBox(height: 12),
                      _ProfileSectionCard(
                        rows: [
                          _ProfileRow(
                            icon: Icons.delete_forever_rounded,
                            label: 'Delete Account',
                            iconBackgroundColor: _dangerSoftColor,
                            iconColor: _dangerColor,
                            labelColor: _dangerColor,
                            onTap: () => showDeleteAccountSheet(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      OutlinedButton.icon(
                        onPressed: () async {
                          await ref
                              .read(authControllerProvider.notifier)
                              .logout();
                          if (context.mounted) {
                            context.go(RoutePaths.login);
                          }
                        },
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text('Log Out'),
                      ),
                      const SizedBox(height: 18),
                      Column(
                        children: [
                          Text(
                            'Grabbit v1.0.0',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Member since ${profile.memberSince}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.initial,
    required this.name,
    required this.email,
    required this.phone,
    required this.requests,
    required this.completed,
    required this.reviews,
  });

  final String initial;
  final String name;
  final String email;
  final String phone;
  final String requests;
  final String completed;
  final String reviews;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.primarySoft,
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(email, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 2),
                    Text(phone, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                    child: _ProfileStat(value: requests, label: 'Requests')),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppColors.outline,
                ),
                Expanded(
                    child: _ProfileStat(value: completed, label: 'Completed')),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: AppColors.outline,
                ),
                Expanded(child: _ProfileStat(value: reviews, label: 'Reviews')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.primaryDark),
        ),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  const _ProfileSectionCard({required this.rows});

  final List<_ProfileRow> rows;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (var i = 0; i < rows.length; i++) {
      children.add(rows[i]);
      if (i < rows.length - 1) {
        children.add(
          const Divider(
            height: 1,
            thickness: 1,
            color: AppColors.outline,
            indent: 64,
            endIndent: 14,
          ),
        );
      }
    }
    return AppSurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
      child: Column(children: children),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    this.badge,
    this.onTap,
    this.iconBackgroundColor,
    this.iconColor,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback? onTap;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              AppIconBadge(
                icon: icon,
                size: 40,
                backgroundColor: iconBackgroundColor ?? AppColors.primarySoft,
                foregroundColor: iconColor ?? AppColors.primaryDark,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: labelColor,
                      ),
                ),
              ),
              if (badge != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badge!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
