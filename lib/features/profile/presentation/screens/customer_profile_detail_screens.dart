import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/config/request_categories.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:grabbit/features/profile/data/repositories/customer_profile_repository.dart';
import 'package:grabbit/features/profile/domain/entities/customer_profile.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  var _initialized = false;
  var _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final profile =
          await ref.read(customerProfileRepositoryProvider).updateProfile(
                name: _nameController.text.trim(),
                email: _emailController.text.trim(),
                phone: _phoneController.text.trim(),
              );
      ref.read(customerProfileCacheProvider.notifier).state = profile;
      await ref
          .read(authControllerProvider.notifier)
          .updateCurrentUser(profile.user);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated.')),
      );
      context.pop();
    } catch (error) {
      if (!mounted) return;
      _showError(context, error, fallback: 'Unable to update profile.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(customerProfileProvider);
    return _ProfileDetailScaffold(
      title: 'Edit Profile',
      child: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            const _ErrorState(message: 'Unable to load profile.'),
        data: (profile) {
          if (!_initialized) {
            _nameController.text = profile.user.name;
            _emailController.text = profile.user.email;
            _phoneController.text = profile.user.phone;
            _initialized = true;
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              AppSurfaceCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full name',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Enter your name.'
                                : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail_outline_rounded),
                        ),
                        validator: (value) {
                          final input = value?.trim() ?? '';
                          if (input.isEmpty) return 'Enter your email.';
                          if (!input.contains('@')) {
                            return 'Enter a valid email.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: const Text('Save Profile'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SavedAddressesScreen extends ConsumerWidget {
  const SavedAddressesScreen({super.key});

  Future<void> _openAddressDialog(
    BuildContext context,
    WidgetRef ref, {
    CustomerAddress? address,
  }) async {
    final result = await showDialog<CustomerAddress>(
      context: context,
      builder: (context) => _AddressDialog(address: address),
    );
    if (result == null) return;

    try {
      late final CustomerProfile profile;
      if (address == null) {
        profile = await ref
            .read(customerProfileRepositoryProvider)
            .addAddress(result);
      } else {
        profile = await ref
            .read(customerProfileRepositoryProvider)
            .updateAddress(result);
      }
      ref.read(customerProfileCacheProvider.notifier).state = profile;
    } catch (error) {
      if (context.mounted) {
        _showError(context, error, fallback: 'Unable to save address.');
      }
    }
  }

  Future<void> _deleteAddress(
    BuildContext context,
    WidgetRef ref,
    CustomerAddress address,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete address?'),
        content: Text('Remove ${address.label} from your saved addresses.'),
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
      final profile = await ref
          .read(customerProfileRepositoryProvider)
          .deleteAddress(address.id);
      ref.read(customerProfileCacheProvider.notifier).state = profile;
    } catch (error) {
      if (context.mounted) {
        _showError(context, error, fallback: 'Unable to delete address.');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(customerProfileProvider);
    return _ProfileDetailScaffold(
      title: 'Saved Addresses',
      trailing: IconButton(
        onPressed: () => _openAddressDialog(context, ref),
        icon: const Icon(Icons.add_rounded),
        tooltip: 'Add address',
      ),
      child: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            const _ErrorState(message: 'Unable to load addresses.'),
        data: (profile) {
          if (profile.addresses.isEmpty) {
            return _EmptyState(
              icon: Icons.location_off_outlined,
              title: 'No saved addresses',
              message: 'Add delivery addresses to make future requests faster.',
              actionLabel: 'Add Address',
              onAction: () => _openAddressDialog(context, ref),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              for (final address in profile.addresses) ...[
                AppSurfaceCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppIconBadge(
                        icon: address.isDefault
                            ? Icons.home_rounded
                            : Icons.location_on_outlined,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    address.label,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                if (address.isDefault)
                                  const _Pill(label: 'Default'),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(address.addressText),
                            if (address.landmark.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                address.landmark,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                TextButton.icon(
                                  onPressed: () => _openAddressDialog(
                                    context,
                                    ref,
                                    address: address,
                                  ),
                                  icon: const Icon(Icons.edit_outlined),
                                  label: const Text('Edit'),
                                ),
                                TextButton.icon(
                                  onPressed: () =>
                                      _deleteAddress(context, ref, address),
                                  icon: const Icon(Icons.delete_outline),
                                  label: const Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          );
        },
      ),
    );
  }
}

class MyReviewsScreen extends ConsumerWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(customerReviewsProvider);
    return _ProfileDetailScaffold(
      title: 'My Reviews',
      child: reviewsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            const _ErrorState(message: 'Unable to load reviews.'),
        data: (reviews) {
          if (reviews.isEmpty) {
            return const _EmptyState(
              icon: Icons.star_border_rounded,
              title: 'No reviews yet',
              message: 'Your shop ratings will appear here after purchases.',
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              for (final review in reviews) ...[
                AppSurfaceCard(
                  child: InkWell(
                    onTap: review.shopId.isEmpty
                        ? null
                        : () => context.push(
                              RoutePaths.storeDetailsPath(review.shopId),
                            ),
                    borderRadius: BorderRadius.circular(22),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primarySoft,
                            child: Text(
                              review.shopInitials,
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.shopName,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  review.requestTitle,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    for (var i = 1; i <= 5; i++)
                                      Icon(
                                        i <= review.rating
                                            ? Icons.star_rounded
                                            : Icons.star_border_rounded,
                                        color: AppColors.accent,
                                        size: 18,
                                      ),
                                    const SizedBox(width: 8),
                                    Text(
                                      review.timeAgo,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                if (review.body.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(review.body),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          );
        },
      ),
    );
  }
}

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends ConsumerState<NotificationSettingsScreen> {
  CustomerNotificationSettings? _settings;
  CustomerPreferences? _preferences;
  var _saving = false;

  Future<void> _save(CustomerNotificationSettings next) async {
    final preferences = _preferences;
    if (preferences == null) return;
    setState(() {
      _settings = next;
      _saving = true;
    });
    try {
      final profile =
          await ref.read(customerProfileRepositoryProvider).updateSettings(
                notificationSettings: next,
                preferences: preferences,
              );
      ref.read(customerProfileCacheProvider.notifier).state = profile;
    } catch (error) {
      if (mounted) {
        _showError(context, error, fallback: 'Unable to save settings.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(customerProfileProvider);
    return _ProfileDetailScaffold(
      title: 'Notifications',
      child: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            const _ErrorState(message: 'Unable to load settings.'),
        data: (profile) {
          _settings ??= profile.notificationSettings;
          _preferences ??= profile.preferences;
          final settings = _settings!;
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              AppSurfaceCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _SwitchRow(
                      title: 'Request responses',
                      subtitle: 'When shops respond to your requests',
                      value: settings.requestResponses,
                      onChanged: (value) => _save(
                        CustomerNotificationSettings(
                          requestResponses: value,
                          chatMessages: settings.chatMessages,
                          purchaseUpdates: settings.purchaseUpdates,
                          promotions: settings.promotions,
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 72),
                    _SwitchRow(
                      title: 'Chat messages',
                      subtitle: 'New messages from shops',
                      value: settings.chatMessages,
                      onChanged: (value) => _save(
                        CustomerNotificationSettings(
                          requestResponses: settings.requestResponses,
                          chatMessages: value,
                          purchaseUpdates: settings.purchaseUpdates,
                          promotions: settings.promotions,
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 72),
                    _SwitchRow(
                      title: 'Purchase updates',
                      subtitle: 'Purchase and review reminders',
                      value: settings.purchaseUpdates,
                      onChanged: (value) => _save(
                        CustomerNotificationSettings(
                          requestResponses: settings.requestResponses,
                          chatMessages: settings.chatMessages,
                          purchaseUpdates: value,
                          promotions: settings.promotions,
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 72),
                    _SwitchRow(
                      title: 'Promotions',
                      subtitle: 'Deals and product suggestions',
                      value: settings.promotions,
                      onChanged: (value) => _save(
                        CustomerNotificationSettings(
                          requestResponses: settings.requestResponses,
                          chatMessages: settings.chatMessages,
                          purchaseUpdates: settings.purchaseUpdates,
                          promotions: value,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_saving) ...[
                const SizedBox(height: 18),
                const Center(child: CircularProgressIndicator()),
              ],
            ],
          );
        },
      ),
    );
  }
}

class RequestDefaultsScreen extends ConsumerStatefulWidget {
  const RequestDefaultsScreen({super.key});

  @override
  ConsumerState<RequestDefaultsScreen> createState() =>
      _RequestDefaultsScreenState();
}

class _RequestDefaultsScreenState extends ConsumerState<RequestDefaultsScreen> {
  final _budgetMinController = TextEditingController();
  final _budgetMaxController = TextEditingController();
  final Set<String> _categories = {};
  var _radius = 5;
  var _initialized = false;
  var _saving = false;

  @override
  void dispose() {
    _budgetMinController.dispose();
    _budgetMaxController.dispose();
    super.dispose();
  }

  Future<void> _save(
    CustomerNotificationSettings settings,
  ) async {
    setState(() => _saving = true);
    try {
      final profile =
          await ref.read(customerProfileRepositoryProvider).updateSettings(
                notificationSettings: settings,
                preferences: CustomerPreferences(
                  categories: _categories.toList(),
                  budgetMin: int.tryParse(_budgetMinController.text.trim()),
                  budgetMax: int.tryParse(_budgetMaxController.text.trim()),
                  searchRadiusKm: _radius,
                ),
              );
      ref.read(customerProfileCacheProvider.notifier).state = profile;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request defaults saved.')),
        );
      }
    } catch (error) {
      if (mounted) {
        _showError(
          context,
          error,
          fallback: 'Unable to save request defaults.',
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(customerProfileProvider);
    return _ProfileDetailScaffold(
      title: 'Request Defaults',
      child: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) =>
            const _ErrorState(message: 'Unable to load request defaults.'),
        data: (profile) {
          if (!_initialized) {
            _categories.addAll(profile.preferences.categories);
            _budgetMinController.text =
                profile.preferences.budgetMin?.toString() ?? '';
            _budgetMaxController.text =
                profile.preferences.budgetMax?.toString() ?? '';
            _radius = profile.preferences.searchRadiusKm;
            _initialized = true;
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              const AppSectionHeader(title: 'Preferred Categories'),
              const SizedBox(height: 10),
              AppSurfaceCard(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final category in RequestCategories.all)
                      FilterChip(
                        label: Text(category),
                        selected: _categories.contains(category),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _categories.add(category);
                            } else {
                              _categories.remove(category);
                            }
                          });
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              const AppSectionHeader(title: 'Budget Range'),
              const SizedBox(height: 10),
              AppSurfaceCard(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _budgetMinController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Min',
                          prefixText: 'Rs. ',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _budgetMaxController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Max',
                          prefixText: 'Rs. ',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Radius',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text('Show shops within $_radius km'),
                    Slider(
                      min: 1,
                      max: 20,
                      divisions: 19,
                      value: _radius.toDouble(),
                      label: '$_radius km',
                      onChanged: (value) =>
                          setState(() => _radius = value.round()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed:
                    _saving ? null : () => _save(profile.notificationSettings),
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined),
                label: const Text('Save Request Defaults'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProfileDetailScaffold(
      title: 'Help & Support',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: const [
          _InfoBlock(
            title: 'Posting requests',
            body:
                'Create a request with a clear title, category, budget, and location so nearby shops can respond quickly.',
          ),
          _InfoBlock(
            title: 'Chatting with shops',
            body:
                'Open a shop response and tap the message button to continue the conversation in chat.',
          ),
          _InfoBlock(
            title: 'Purchases and ratings',
            body:
                'After buying from a shop, mark the request as purchased and leave a rating to help other customers.',
          ),
          _InfoBlock(
            title: 'Contact support',
            body: 'Email support@grabbit.local for account or order help.',
          ),
        ],
      ),
    );
  }
}

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _ProfileDetailScaffold(
      title: 'Terms',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: const [
          _InfoBlock(
            title: 'Using Grabbit',
            body:
                'Grabbit connects customers and local shops. Customers are responsible for confirming item quality, price, and delivery details before purchase.',
          ),
          _InfoBlock(
            title: 'Shop responses',
            body:
                'Prices and availability are provided by shops and can change. Confirm final details directly with the shop.',
          ),
          _InfoBlock(
            title: 'Account data',
            body:
                'Profile data is used to operate your account, requests, chats, request defaults, and saved addresses.',
          ),
          _InfoBlock(
            title: 'Safety',
            body:
                'Do not share sensitive payment or password information in chat. Report suspicious activity to support.',
          ),
        ],
      ),
    );
  }
}

class _AddressDialog extends StatefulWidget {
  const _AddressDialog({this.address});

  final CustomerAddress? address;

  @override
  State<_AddressDialog> createState() => _AddressDialogState();
}

class _AddressDialogState extends State<_AddressDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _labelController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _landmarkController;
  late final TextEditingController _phoneController;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    _labelController = TextEditingController(text: address?.label ?? 'Home');
    _addressController =
        TextEditingController(text: address?.addressText ?? '');
    _cityController = TextEditingController(text: address?.city ?? 'Kathmandu');
    _landmarkController = TextEditingController(text: address?.landmark ?? '');
    _phoneController = TextEditingController(text: address?.phone ?? '');
    _isDefault = address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _labelController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _landmarkController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      CustomerAddress(
        id: widget.address?.id ?? '',
        label: _labelController.text.trim(),
        addressText: _addressController.text.trim(),
        city: _cityController.text.trim(),
        landmark: _landmarkController.text.trim(),
        phone: _phoneController.text.trim(),
        isDefault: _isDefault,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _labelController,
                decoration: const InputDecoration(labelText: 'Label'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter a label.'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter an address.'
                    : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _landmarkController,
                decoration: const InputDecoration(labelText: 'Landmark'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _isDefault,
                onChanged: (value) =>
                    setState(() => _isDefault = value ?? false),
                title: const Text('Set as default'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _ProfileDetailScaffold extends StatelessWidget {
  const _ProfileDetailScaffold({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppStickyPage(
        bottomSafeArea: true,
        header: AppScreenHeader(
          title: title,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.chevron_left_rounded),
          ),
          trailing: trailing,
        ),
        child: child,
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      subtitle: Text(subtitle),
      secondary:
          const AppIconBadge(icon: Icons.notifications_outlined, size: 40),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppSurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(body, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIconBadge(icon: icon, size: 58),
            const SizedBox(height: 14),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 18),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

void _showError(
  BuildContext context,
  Object error, {
  required String fallback,
}) {
  final message = error is AppException ? error.message : fallback;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
