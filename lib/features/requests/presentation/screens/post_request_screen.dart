import 'package:flutter/material.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/widgets/app_primary_button.dart';
import 'package:grabbit/core/widgets/app_section_header.dart';
import 'package:grabbit/core/widgets/app_soft_background.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';

class PostRequestScreen extends StatefulWidget {
  const PostRequestScreen({super.key});

  @override
  State<PostRequestScreen> createState() => _PostRequestScreenState();
}

class _PostRequestScreenState extends State<PostRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _detailsController = TextEditingController();
  final _budgetController = TextEditingController();
  String _urgency = 'Today';

  @override
  void dispose() {
    _productController.dispose();
    _detailsController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Request draft captured. Connect it to the backend next.'),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Request'),
      ),
      body: AppSoftBackground(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                const AppSectionHeader(title: 'What are you looking for?'),
                const SizedBox(height: 14),
                AppSurfaceCard(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _productController,
                        decoration: const InputDecoration(
                          labelText: 'Product name',
                          hintText: 'e.g. Sony wireless headphones',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter a product name.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _detailsController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Details',
                          hintText:
                              'Describe preferred brand, condition, or quantity.',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const AppSectionHeader(title: 'Budget & urgency'),
                const SizedBox(height: 14),
                AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _budgetController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Budget',
                          hintText: 'e.g. NPR 4,000',
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Urgency',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 10),
                      SegmentedButton<String>(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? AppColors.primarySoft
                                : Colors.white,
                          ),
                          foregroundColor: WidgetStateProperty.resolveWith(
                            (states) => states.contains(WidgetState.selected)
                                ? AppColors.primaryDark
                                : AppColors.textMuted,
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                        segments: const [
                          ButtonSegment(value: 'Today', label: Text('Today')),
                          ButtonSegment(
                              value: 'This Week', label: Text('This Week')),
                          ButtonSegment(
                              value: 'Flexible', label: Text('Flexible')),
                        ],
                        selected: {_urgency},
                        onSelectionChanged: (selection) {
                          setState(() {
                            _urgency = selection.first;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                AppPrimaryButton(
                  label: 'Save Request Draft',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
