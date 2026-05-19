import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:grabbit/app/router/route_paths.dart';
import 'package:grabbit/core/errors/app_exception.dart';
import 'package:grabbit/core/widgets/app_primary_button.dart';
import 'package:grabbit/core/widgets/app_soft_background.dart';
import 'package:grabbit/core/widgets/app_surface_card.dart';
import 'package:grabbit/core/widgets/brand_badge.dart';
import 'package:grabbit/features/auth/domain/entities/login_payload.dart';
import 'package:grabbit/features/auth/presentation/controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final user = await ref.read(authControllerProvider.notifier).login(
            LoginPayload(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
      if (!mounted) {
        return;
      }
      context.go(RoutePaths.homeForRole(user.role));
    } catch (error) {
      if (!mounted) {
        return;
      }
      final message = error is AppException
          ? error.message
          : 'Unable to log in. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  children: [
                    const BrandBadge(size: 92),
                    const SizedBox(height: 18),
                    Text('Grabbit', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Connect with nearby shops, post requests, and track responses in one calm, friendly space.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 26),
                    Expanded(
                      child: SingleChildScrollView(
                        clipBehavior: Clip.none,
                        padding: const EdgeInsets.fromLTRB(0, 6, 0, 24),
                        child: Column(
                          children: [
                            AppSurfaceCard(
                              padding: const EdgeInsets.all(24),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Welcome back',
                                      style: theme.textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Log in to continue with your requests and deals.',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 22),
                                    Text(
                                      'Email address',
                                      style: theme.textTheme.titleSmall,
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        hintText: 'name@example.com',
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Enter your email address.';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 18),
                                    Text(
                                      'Password',
                                      style: theme.textTheme.titleSmall,
                                    ),
                                    const SizedBox(height: 8),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: _obscureText,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your password',
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
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Enter your password.';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 22),
                                    AppPrimaryButton(
                                      label: 'Log In',
                                      isLoading: isLoading,
                                      onPressed: _submit,
                                    ),
                                    const SizedBox(height: 16),
                                    Center(
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                            "Don't have an account?",
                                            style: theme.textTheme.bodyMedium,
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                context.go(RoutePaths.signUp),
                                            child: const Text('Sign Up'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Row(
                              children: [
                                Expanded(child: Divider()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('OR continue with'),
                                ),
                                Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Row(
                              children: [
                                Expanded(
                                  child: _SocialButton(
                                    label: 'Google',
                                    assetPath: 'assets/logos/google_logo.svg',
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _SocialButton(
                                    label: 'Facebook',
                                    assetPath: 'assets/logos/facebook_logo.svg',
                                  ),
                                ),
                              ],
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

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.assetPath,
  });

  final String label;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        label: label,
        child: AppSurfaceCard(
          padding: EdgeInsets.zero,
          radius: 24,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(assetPath, width: 22, height: 22),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
