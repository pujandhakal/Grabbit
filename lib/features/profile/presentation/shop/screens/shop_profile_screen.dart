import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_status_chip.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:grabbit/features/profile/data/repositories/shop_profile_repository.dart';
import 'package:grabbit/features/profile/presentation/widgets/delete_account_sheet.dart';
import 'package:grabbit/features/requests/presentation/controllers/request_providers.dart';
import 'package:latlong2/latlong.dart';

const _dangerColor = Color(0xFFE5484D);
const _dangerSoftColor = Color(0xFFFFECEE);

abstract final class _ShopProfileAssets {
  static const productExplainer = 'assets/images/shop_product_explainer.svg';
}

const _categories = [
  'Groceries',
  'Electronics',
  'Clothing',
  'Food & Beverages',
  'Health',
  'Sports',
  'Other',
];

const _specialtyOptions = [
  'Electronics',
  'Accessories',
  'Repairs',
  'Fashion',
  'Footwear',
  'Groceries',
  'Home Delivery',
  'Fast Response',
];

const _openStatusOptions = ['Open Now', 'Closed', 'Opening Soon'];

final _kathmanduCenter = LatLng(27.7172, 85.3240);

class ShopProfileScreen extends ConsumerStatefulWidget {
  const ShopProfileScreen({super.key});

  @override
  ConsumerState<ShopProfileScreen> createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends ConsumerState<ShopProfileScreen> {
  final _businessNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _closingTimeController = TextEditingController();
  final _responseTimeController = TextEditingController();
  final Set<String> _selectedCategories = {};
  final Set<String> _selectedSpecialties = {};
  String _openStatus = 'Open Now';
  bool _initialized = false;
  bool _saving = false;
  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    _businessNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _descriptionController.dispose();
    _closingTimeController.dispose();
    _responseTimeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
    });

    try {
      await ref.read(shopProfileRepositoryProvider).saveProfile(
            businessName: _businessNameController.text.trim().isEmpty
                ? 'My Shop'
                : _businessNameController.text.trim(),
            categories: _selectedCategories.toList(),
            addressText: _addressController.text.trim(),
            phone: _phoneController.text.trim(),
            description: _descriptionController.text.trim(),
            specialties: _selectedSpecialties.toList(),
            openStatus: _openStatus,
            closingTime: _closingTimeController.text.trim(),
            typicalResponseTime: _responseTimeController.text.trim(),
            landmark: _landmarkController.text.trim(),
            latitude: _latitude,
            longitude: _longitude,
          );
      ref.invalidate(shopProfileProvider);
      ref.invalidate(shopRequestsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Store details saved.')),
      );
    } catch (error) {
      if (!mounted) return;
      final message = error is AppException
          ? error.message
          : 'Unable to save store details.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  Future<void> _editText({
    required String title,
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
  }) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _TextFieldSheet(
        title: title,
        initialValue: controller.text,
        hint: hint,
        keyboardType: keyboardType,
      ),
    );
    if (result != null) {
      setState(() {
        controller.text = result;
      });
      await _save();
    }
  }

  Future<void> _editLongText({
    required String title,
    required TextEditingController controller,
    String? hint,
  }) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _LongTextSheet(
        title: title,
        initialValue: controller.text,
        hint: hint,
      ),
    );
    if (result != null) {
      setState(() {
        controller.text = result;
      });
      await _save();
    }
  }

  Future<void> _editChoice({
    required String title,
    required List<String> options,
    required String current,
    required ValueChanged<String> onPicked,
  }) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _ChoiceSheet(
        title: title,
        options: options,
        initialValue: current,
      ),
    );
    if (result != null) {
      setState(() => onPicked(result));
      await _save();
    }
  }

  Future<void> _editMultiSelect({
    required String title,
    required List<String> options,
    required Set<String> current,
    required ValueChanged<Set<String>> onSaved,
  }) async {
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _ChipMultiSelectSheet(
        title: title,
        options: options,
        initialSelected: current,
      ),
    );
    if (result != null) {
      setState(() => onSaved(result));
      await _save();
    }
  }

  Future<void> _editMapPin() async {
    final result = await showModalBottomSheet<(double, double)>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => _MapPickerSheet(
        initialLat: _latitude,
        initialLng: _longitude,
      ),
    );
    if (result != null) {
      setState(() {
        _latitude = result.$1;
        _longitude = result.$2;
      });
      await _save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(shopProfileProvider);

    final isVerified = profile.valueOrNull?.isVerified ?? false;

    return AppStickyPage(
      bottomSafeArea: true,
      header: AppScreenHeader(
        title: isVerified ? 'Store Profile' : 'Verify Your Store',
        subtitle: isVerified
            ? 'Manage the public details customers see after View Store.'
            : 'Complete public details customers see after View Store.',
      ),
      child: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Unable to load shop profile.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        data: (profile) {
          if (!_initialized) {
            _businessNameController.text = profile.businessName;
            _phoneController.text = profile.phone;
            _addressController.text = profile.addressText;
            _landmarkController.text = profile.landmark;
            _descriptionController.text = profile.description;
            _closingTimeController.text = profile.closingTime;
            _responseTimeController.text = profile.typicalResponseTime;
            _openStatus =
                profile.openStatus.isEmpty ? 'Open Now' : profile.openStatus;
            _selectedCategories
              ..clear()
              ..addAll(profile.categories);
            _selectedSpecialties
              ..clear()
              ..addAll(profile.specialties);
            _latitude = profile.latitude;
            _longitude = profile.longitude;
            _initialized = true;
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _StatusCard(isVerified: profile.isVerified),
              const SizedBox(height: 20),
              const _SectionTitle('Business'),
              const SizedBox(height: 8),
              _SettingsGroup(
                rows: [
                  _SettingsRow(
                    icon: Icons.storefront_rounded,
                    label: 'Business name',
                    value: _valueOr(_businessNameController.text),
                    onTap: () => _editText(
                      title: 'Business name',
                      controller: _businessNameController,
                      hint: 'e.g. Kathmandu Electronics',
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.phone_rounded,
                    label: 'Phone',
                    value: _valueOr(_phoneController.text),
                    onTap: () => _editText(
                      title: 'Phone',
                      controller: _phoneController,
                      hint: 'e.g. 9800000000',
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.description_outlined,
                    label: 'Description',
                    value: _valueOr(
                      _descriptionController.text,
                      truncate: 60,
                    ),
                    onTap: () => _editLongText(
                      title: 'Store description',
                      controller: _descriptionController,
                      hint: 'Describe what customers can expect.',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const _SectionTitle('Location'),
              const SizedBox(height: 8),
              _SettingsGroup(
                rows: [
                  _SettingsRow(
                    icon: Icons.location_on_outlined,
                    label: 'Address',
                    value: _valueOr(_addressController.text),
                    onTap: () => _editText(
                      title: 'Address',
                      controller: _addressController,
                      hint: 'e.g. New Baneshwor, Kathmandu',
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.flag_outlined,
                    label: 'Landmark',
                    value: _valueOr(_landmarkController.text),
                    onTap: () => _editText(
                      title: 'Landmark',
                      controller: _landmarkController,
                      hint: 'e.g. Near Civil Hospital',
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.map_outlined,
                    label: 'Pin on map',
                    value: _latitude != null && _longitude != null
                        ? 'Lat ${_latitude!.toStringAsFixed(5)}, '
                            'Lng ${_longitude!.toStringAsFixed(5)}'
                        : 'Not set',
                    onTap: _editMapPin,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const _SectionTitle('Hours & response'),
              const SizedBox(height: 8),
              _SettingsGroup(
                rows: [
                  _SettingsRow(
                    icon: Icons.circle_rounded,
                    iconColor: AppColors.primaryDark,
                    label: 'Open status',
                    value: _openStatus,
                    onTap: () => _editChoice(
                      title: 'Open status',
                      options: _openStatusOptions,
                      current: _openStatus,
                      onPicked: (v) => _openStatus = v,
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.schedule_rounded,
                    label: 'Closing time',
                    value: _valueOr(_closingTimeController.text),
                    onTap: () => _editText(
                      title: 'Closing time',
                      controller: _closingTimeController,
                      hint: 'e.g. Closes 9:00 PM',
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.bolt_rounded,
                    label: 'Typical response time',
                    value: _valueOr(_responseTimeController.text),
                    onTap: () => _editText(
                      title: 'Typical response time',
                      controller: _responseTimeController,
                      hint: 'e.g. 15 minutes',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const _SectionTitle('Catalog'),
              const SizedBox(height: 8),
              _SettingsGroup(
                rows: [
                  _SettingsRow(
                    icon: Icons.category_outlined,
                    label: 'Matching categories',
                    value: _summarizeSet(_selectedCategories),
                    onTap: () => _editMultiSelect(
                      title: 'Matching categories',
                      options: _categories,
                      current: _selectedCategories,
                      onSaved: (next) {
                        _selectedCategories
                          ..clear()
                          ..addAll(next);
                      },
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.auto_awesome_outlined,
                    label: 'Specialties',
                    value: _summarizeSet(_selectedSpecialties),
                    onTap: () => _editMultiSelect(
                      title: 'Specialties shown to customers',
                      options: _specialtyOptions,
                      current: _selectedSpecialties,
                      onSaved: (next) {
                        _selectedSpecialties
                          ..clear()
                          ..addAll(next);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const _SectionTitle('Danger Zone'),
              const SizedBox(height: 8),
              _SettingsGroup(
                rows: [
                  _SettingsRow(
                    icon: Icons.delete_forever_rounded,
                    label: 'Delete Account',
                    value: 'Permanently remove this shop account',
                    iconColor: _dangerColor,
                    iconBackgroundColor: _dangerSoftColor,
                    labelColor: _dangerColor,
                    onTap: () => showDeleteAccountSheet(context),
                  ),
                ],
              ),
              if (_saving) ...[
                const SizedBox(height: 24),
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 12),
              ] else
                const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  if (context.mounted) {
                    context.go(RoutePaths.login);
                  }
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Log Out'),
              ),
            ],
          );
        },
      ),
    );
  }
}

String _valueOr(String input, {int? truncate}) {
  final trimmed = input.trim();
  if (trimmed.isEmpty) return 'Not set';
  if (truncate != null && trimmed.length > truncate) {
    return '${trimmed.substring(0, truncate)}…';
  }
  return trimmed;
}

String _summarizeSet(Set<String> values) {
  if (values.isEmpty) return 'None selected';
  if (values.length <= 2) return values.join(', ');
  return '${values.length} selected';
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.isVerified});

  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isVerified ? 'Store verified' : 'Store profile incomplete',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  isVerified
                      ? 'Customers can now view your store details.'
                      : 'Fill every public field to verify your store.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 92,
            height: 74,
            child: SvgPicture.asset(
              _ShopProfileAssets.productExplainer,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 10),
          AppStatusChip(
            label: isVerified ? 'Verified' : 'Incomplete',
            tone: isVerified ? AppStatusTone.primary : AppStatusTone.accent,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              const Divider(height: 1, indent: 64, color: AppColors.outline),
            rows[i],
          ],
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.iconColor,
    this.iconBackgroundColor,
    this.labelColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Color? labelColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPlaceholder = value == 'Not set' || value == 'None selected';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: iconBackgroundColor ?? AppColors.primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor ?? AppColors.primaryDark,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: labelColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          isPlaceholder ? AppColors.textMuted : AppColors.text,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

class _EditSheet extends StatelessWidget {
  const _EditSheet({
    required this.title,
    required this.child,
    this.onSave,
    this.height,
  });

  final String title;
  final Widget child;
  final VoidCallback? onSave;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 4),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.outline,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
          child: Row(
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              Expanded(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: onSave,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: AppColors.outline),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: child,
          ),
        ),
      ],
    );

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: viewInsets.bottom),
        child:
            height != null ? SizedBox(height: height, child: content) : content,
      ),
    );
  }
}

class _TextFieldSheet extends StatefulWidget {
  const _TextFieldSheet({
    required this.title,
    required this.initialValue,
    this.hint,
    this.keyboardType,
  });

  final String title;
  final String initialValue;
  final String? hint;
  final TextInputType? keyboardType;

  @override
  State<_TextFieldSheet> createState() => _TextFieldSheetState();
}

class _TextFieldSheetState extends State<_TextFieldSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _EditSheet(
      title: widget.title,
      onSave: () => Navigator.of(context).pop(_controller.text.trim()),
      child: TextField(
        controller: _controller,
        keyboardType: widget.keyboardType,
        autofocus: true,
        decoration: InputDecoration(hintText: widget.hint),
      ),
    );
  }
}

class _LongTextSheet extends StatefulWidget {
  const _LongTextSheet({
    required this.title,
    required this.initialValue,
    this.hint,
  });

  final String title;
  final String initialValue;
  final String? hint;

  @override
  State<_LongTextSheet> createState() => _LongTextSheetState();
}

class _LongTextSheetState extends State<_LongTextSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return _EditSheet(
      title: widget.title,
      height: screenHeight * 0.7,
      onSave: () => Navigator.of(context).pop(_controller.text.trim()),
      child: TextField(
        controller: _controller,
        autofocus: true,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: widget.hint,
          alignLabelWithHint: true,
        ),
      ),
    );
  }
}

class _ChoiceSheet extends StatefulWidget {
  const _ChoiceSheet({
    required this.title,
    required this.options,
    required this.initialValue,
  });

  final String title;
  final List<String> options;
  final String initialValue;

  @override
  State<_ChoiceSheet> createState() => _ChoiceSheetState();
}

class _ChoiceSheetState extends State<_ChoiceSheet> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return _EditSheet(
      title: widget.title,
      onSave: () => Navigator.of(context).pop(_value),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final option in widget.options)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(option),
              trailing: Icon(
                option == _value
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color:
                    option == _value ? AppColors.primary : AppColors.textMuted,
              ),
              onTap: () => setState(() {
                _value = option;
              }),
            ),
        ],
      ),
    );
  }
}

class _ChipMultiSelectSheet extends StatefulWidget {
  const _ChipMultiSelectSheet({
    required this.title,
    required this.options,
    required this.initialSelected,
  });

  final String title;
  final List<String> options;
  final Set<String> initialSelected;

  @override
  State<_ChipMultiSelectSheet> createState() => _ChipMultiSelectSheetState();
}

class _ChipMultiSelectSheetState extends State<_ChipMultiSelectSheet> {
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = {...widget.initialSelected};
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return _EditSheet(
      title: widget.title,
      height: screenHeight * 0.55,
      onSave: () => Navigator.of(context).pop(_selected),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in widget.options)
              FilterChip(
                label: Text(option),
                selected: _selected.contains(option),
                selectedColor: AppColors.primarySoft,
                onSelected: (value) {
                  setState(() {
                    if (value) {
                      _selected.add(option);
                    } else {
                      _selected.remove(option);
                    }
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _MapPickerSheet extends StatefulWidget {
  const _MapPickerSheet({this.initialLat, this.initialLng});

  final double? initialLat;
  final double? initialLng;

  @override
  State<_MapPickerSheet> createState() => _MapPickerSheetState();
}

class _MapPickerSheetState extends State<_MapPickerSheet> {
  late final MapController _mapController;
  double? _lat;
  double? _lng;
  bool _locating = false;
  String? _status;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _lat = widget.initialLat;
    _lng = widget.initialLng;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _setStatus(String? message) {
    if (!mounted) return;
    setState(() {
      _status = message;
    });
  }

  Future<void> _useMyLocation() async {
    setState(() {
      _locating = true;
      _status = null;
    });
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) {
        _setStatus(
          'Location services are off. Turn on GPS in your device settings, then try again.',
        );
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        _setStatus(
            'Location permission was denied. Tap the button again to ask once more.');
        return;
      }
      if (permission == LocationPermission.deniedForever) {
        _setStatus(
          'Permission permanently denied. Open app settings → Permissions → Location to allow it.',
        );
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      if (!mounted) return;
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
        _status = null;
      });
      _mapController.move(LatLng(pos.latitude, pos.longitude), 17);
    } catch (e) {
      debugPrint('Geolocator error: $e');
      _setStatus('Could not get current location: $e');
    } finally {
      if (mounted) {
        setState(() {
          _locating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final hasPin = _lat != null && _lng != null;
    return _EditSheet(
      title: 'Pin on map',
      height: screenHeight * 0.85,
      onSave: hasPin ? () => Navigator.of(context).pop((_lat!, _lng!)) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tap on the map to drop a pin where customers can find your shop.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter:
                      hasPin ? LatLng(_lat!, _lng!) : _kathmanduCenter,
                  initialZoom: 15,
                  onTap: (tapPosition, latLng) {
                    setState(() {
                      _lat = latLng.latitude;
                      _lng = latLng.longitude;
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.grabbit.app',
                  ),
                  if (hasPin)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(_lat!, _lng!),
                          width: 44,
                          height: 44,
                          alignment: Alignment.topCenter,
                          child: const Icon(
                            Icons.location_on,
                            color: AppColors.accent,
                            size: 44,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _locating ? null : _useMyLocation,
            icon: _locating
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location),
            label: Text(
              _locating ? 'Locating…' : 'Use my current location',
            ),
          ),
          if (_status != null) ...[
            const SizedBox(height: 8),
            Text(
              _status!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.accent,
                  ),
            ),
          ],
          const SizedBox(height: 8),
          Text(
            hasPin
                ? 'Pin: ${_lat!.toStringAsFixed(5)}, ${_lng!.toStringAsFixed(5)}'
                : 'No pin yet — tap the map or use GPS.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
