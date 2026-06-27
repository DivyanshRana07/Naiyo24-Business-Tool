import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../notifiers/auth_notifier.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/divider_with_text.dart';
import '../../widgets/floating_chat_button.dart';
import '../../widgets/google_button.dart';
import '../../widgets/password_field.dart';

/// Login Screen – replicates the Refrens authentication page.
///
/// All business logic (validation + login) is delegated to [AuthNotifier].
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validates the form and attempts login via [AuthNotifier].
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate a short async delay (UX feedback)
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final success = ref.read(authNotifierProvider.notifier).login(
          _emailController.text,
          _passwordController.text,
        );

    setState(() => _isLoading = false);

    if (success) {
      context.go(AppRoutes.dashboard);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid demo credentials'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              // ── Top Navigation Bar ──────────────────────────────────
              AuthHeader(
                showRegister: true,
                onRegisterTap: () => context.go(AppRoutes.signup),
              ),

              // ── Main Content ────────────────────────────────────────
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: _LoginBody(
                            formKey: _formKey,
                            emailController: _emailController,
                            passwordController: _passwordController,
                            isLoading: _isLoading,
                            onLogin: _handleLogin,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          // ── Floating Chat Button ────────────────────────────────────
          const FloatingChatButton(),
        ],
      ),
    );
  }
}

/// The scrollable body content of the login screen.
class _LoginBody extends StatelessWidget {
  const _LoginBody({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width > 768 ? AppPadding.xl : AppPadding.md,
        vertical: AppPadding.xl,
      ),
      child: Column(
        children: [
          // Hero text
          _HeroSection(),
          const SizedBox(height: AppPadding.xl),

          // Login card
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizing.loginCardWidth,
              ),
              child: _LoginCard(
                formKey: formKey,
                emailController: emailController,
                passwordController: passwordController,
                isLoading: isLoading,
                onLogin: onLogin,
              ),
            ),
          ),

          const SizedBox(height: AppPadding.xxl),
          _FooterText(),
        ],
      ),
    );
  }
}

/// Hero section above the login card.
class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome back 👋',
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Sign in to your account to continue',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// The white card containing all login form elements.
class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Heading ──────────────────────────────────────────────
            Text(
              'Sign in',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                children: [
                  const TextSpan(text: 'Demo credentials: '),
                  TextSpan(
                    text: 'demo@refrens.com',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' / '),
                  TextSpan(
                    text: 'demo123',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppPadding.lg),

            // ── Google Button ────────────────────────────────────────
            const GoogleButton(),
            const SizedBox(height: AppPadding.md),

            // ── OR Divider ───────────────────────────────────────────
            const DividerWithText(),
            const SizedBox(height: AppPadding.md),

            // ── Email Field ──────────────────────────────────────────
            CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              prefixIcon: const Icon(
                Icons.email_outlined,
                size: 20,
                color: AppColors.textSecondary,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: AppPadding.md),

            // ── Password Field ───────────────────────────────────────
            PasswordField(
              controller: passwordController,
              hintText: 'Enter your password',
              labelText: 'Password',
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => onLogin(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: AppPadding.sm),

            // ── Forgot Password ──────────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppPadding.lg),

            // ── Login Button ─────────────────────────────────────────
            CustomButton(
              label: 'Sign in',
              isLoading: isLoading,
              onPressed: onLogin,
            ),
            const SizedBox(height: AppPadding.lg),

            // ── Bottom text ──────────────────────────────────────────
            _SignupPrompt(),
          ],
        ),
      ),
    );
  }
}

/// "Don't have an account? Register" text below the card.
class _SignupPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () => context.go(AppRoutes.signup),
          child: Text(
            'Register',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Footer tagline at the bottom of the page.
class _FooterText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '© 2024 Naiyo24 · All rights reserved',
      style: GoogleFonts.inter(
        fontSize: 12,
        color: AppColors.textHint,
      ),
      textAlign: TextAlign.center,
    );
  }
}
