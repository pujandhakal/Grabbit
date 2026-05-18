import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/app/theme/app_theme.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/widgets/app_primary_button.dart';
import 'package:grabbit/core/widgets/app_soft_background.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/core/widgets/brand_badge.dart';
import 'package:grabbit/features/auth/domain/entities/sign_up_payload.dart';
import 'package:grabbit/features/auth/presentation/controllers/auth_controller.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = false;
  bool _obscureText = true;
  bool _submitTriggered = false;
  late final ProviderSubscription<AsyncValue> _authSubscription;

  @override
  void initState() {
    super.initState();
    _authSubscription = ref.listenManual<AsyncValue>(
      authControllerProvider,
      (previous, next) {
        if (!_submitTriggered) {
          return;
        }

        next.whenOrNull(
          data: (_) {
            _submitTriggered = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created. You can now log in.'),
              ),
            );
            context.go(RoutePaths.login);
          },
          error: (error, _) {
            _submitTriggered = false;
            final message = error is AppException
                ? error.message
                : 'Unable to create your account.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _authSubscription.close();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || !_agreedToTerms) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Accept the terms to continue.')),
        );
      }
      return;
    }

    _submitTriggered = true;
    await ref.read(authControllerProvider.notifier).signUp(
          SignUpPayload(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;
    final theme = Theme.of(context);

    return Scaffold(
      body: AppSoftBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  children: [
                    const BrandBadge(size: 92),
                    const SizedBox(height: 18),
                    Text('Join Grabbit', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Create your account before posting requests or chatting with shops.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 22),
                    AppSurfaceCard(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () => context.go(RoutePaths.login),
                                  icon: const Icon(Icons.chevron_left_rounded),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Create Account',
                                  style: theme.textTheme.titleLarge,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('Full name',
                                style: theme.textTheme.titleSmall),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'e.g. Pujan Dhakal',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter your name.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            Text('Email address',
                                style: theme.textTheme.titleSmall),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'e.g. user@example.com',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Enter your email.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            Text('Password', style: theme.textTheme.titleSmall),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                hintText: 'At least 8 characters',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().length < 8) {
                                  return 'Use at least 8 characters.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            CheckboxListTile(
                              value: _agreedToTerms,
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: AppColors.primary,
                              onChanged: (value) {
                                setState(() {
                                  _agreedToTerms = value ?? false;
                                });
                              },
                              title: Text(
                                'I agree to the terms and privacy policy.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.text,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            AppPrimaryButton(
                              label: 'Create Account',
                              isLoading: isLoading,
                              onPressed: _submit,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
