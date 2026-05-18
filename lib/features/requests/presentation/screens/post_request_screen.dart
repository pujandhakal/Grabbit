import 'package:flutter/material.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_primary_button.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_sticky_page.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';

const _categories = [
  'Groceries',
  'Electronics',
  'Clothing',
  'Food & Beverages',
  'Health',
  'Sports',
  'Other',
];

class PostRequestScreen extends StatefulWidget {
  const PostRequestScreen({super.key});

  @override
  State<PostRequestScreen> createState() => _PostRequestScreenState();
}

class _PostRequestScreenState extends State<PostRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _detailsController = TextEditingController();
  final _quantityController = TextEditingController();
  String? _category;
  String _urgency = 'need_soon';

  @override
  void dispose() {
    _productController.dispose();
    _detailsController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Request captured. Connect to backend next.')),
    );
    Navigator.of(context).pop();
  }

  Widget _fieldLabel(String label, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          if (required)
            Text(
              ' *',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      body: AppStickyPage(
        bottomSafeArea: true,
        header: AppScreenHeader(
          title: 'Post What You Need',
          subtitle: 'Nearby shops will see your request',
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              // ── Header ──────────────────────────────────────
              // ── Product card ─────────────────────────────────
              const AppSectionHeader(title: 'Product'),
              const SizedBox(height: 12),
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Product Name', required: true),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _productController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Wireless Headphones',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Product name is required'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _fieldLabel('Description / Details'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _detailsController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: 'Preferably black color, under Rs. 3000',
                      ),
                    ),
                    const SizedBox(height: 16),
                    _fieldLabel('Category', required: true),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(
                        hintText: 'Select a category',
                      ),
                      items: _categories
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _category = v),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please select a category'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    _fieldLabel('Quantity'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., 2 pcs',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Photo card ────────────────────────────────────
              const AppSectionHeader(title: 'Photo'),
              const SizedBox(height: 12),
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel('Upload Photo (Optional)'),
                    const SizedBox(height: 8),
                    const _PhotoUploadArea(),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Urgency card ──────────────────────────────────
              const AppSectionHeader(title: 'Urgency'),
              const SizedBox(height: 12),
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('How soon do you need it?', style: tt.titleMedium),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _UrgencyCard(
                            value: 'need_soon',
                            emoji: '🔥',
                            title: 'Need Soon',
                            subtitle: 'Within 24 hours',
                            selected: _urgency == 'need_soon',
                            onTap: () => setState(() => _urgency = 'need_soon'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _UrgencyCard(
                            value: 'this_week',
                            emoji: '⏰',
                            title: 'This Week',
                            subtitle: '2-7 days',
                            selected: _urgency == 'this_week',
                            onTap: () => setState(() => _urgency = 'this_week'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _UrgencyCard(
                            value: 'flexible',
                            emoji: '😌',
                            title: 'Flexible',
                            subtitle: 'No rush',
                            selected: _urgency == 'flexible',
                            onTap: () => setState(() => _urgency = 'flexible'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Location card ─────────────────────────────────
              const AppSectionHeader(title: 'Location'),
              const SizedBox(height: 12),
              AppSurfaceCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: AppColors.textMuted,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Kathmandu, New Baneshwor',
                          style: tt.bodyLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(
                            Icons.my_location_rounded,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Using current location',
                            style: tt.bodySmall?.copyWith(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Submit ────────────────────────────────────────
              Text(
                'Fill required fields to continue',
                textAlign: TextAlign.center,
                style: tt.bodySmall,
              ),
              const SizedBox(height: 10),
              AppPrimaryButton(
                label: 'Post Request',
                icon: Icons.chevron_right_rounded,
                onPressed: _submit,
              ),
              const SizedBox(height: 10),
              Text(
                'Your request will be visible to nearby shops',
                textAlign: TextAlign.center,
                style: tt.bodySmall,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhotoUploadArea extends StatelessWidget {
  const _PhotoUploadArea();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.outline, width: 1.5),
        ),
        child: Column(
          children: [
            AppIconBadge(
              icon: Icons.cloud_upload_outlined,
              size: 52,
            ),
            const SizedBox(height: 12),
            Text('Click to upload or drag and drop', style: tt.titleSmall),
            const SizedBox(height: 4),
            Text('PNG, JPG up to 5MB', style: tt.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _UrgencyCard extends StatelessWidget {
  const _UrgencyCard({
    required this.value,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String value;
  final String emoji;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: tt.titleSmall?.copyWith(
                color: selected ? AppColors.primaryDark : AppColors.text,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: tt.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
