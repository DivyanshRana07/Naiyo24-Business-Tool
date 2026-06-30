import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../routes/app_routes.dart';
import '../../notifiers/auth_notifier.dart';
import '../../theme/theme.dart';
import '../../widgets/auth_header.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/divider_with_text.dart';
import '../../widgets/floating_chat_button.dart';
import '../../widgets/google_button.dart';
import '../../widgets/password_field.dart';

/// Signup (Registration) screen.
///
/// UI only – does not persist any user data.
/// On "Create Account" shows a SnackBar and redirects to [LoginScreen].
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _agreeToTerms = false;

  // Country dropdown data
  String? _selectedCountry;
  String _selectedPhoneCode = '+91';

  static const List<Map<String, String>> _countries = [
    {'name': 'India', 'code': '+91', 'flag': '🇮🇳'},
    {'name': 'United States', 'code': '+1', 'flag': '🇺🇸'},
    {'name': 'United Kingdom', 'code': '+44', 'flag': '🇬🇧'},
    {'name': 'Canada', 'code': '+1', 'flag': '🇨🇦'},
    {'name': 'Australia', 'code': '+61', 'flag': '🇦🇺'},
    {'name': 'Germany', 'code': '+49', 'flag': '🇩🇪'},
    {'name': 'France', 'code': '+33', 'flag': '🇫🇷'},
    {'name': 'Japan', 'code': '+81', 'flag': '🇯🇵'},
    {'name': 'Singapore', 'code': '+65', 'flag': '🇸🇬'},
    {'name': 'UAE', 'code': '+971', 'flag': '🇦🇪'},
    {'name': 'Brazil', 'code': '+55', 'flag': '🇧🇷'},
    {'name': 'South Africa', 'code': '+27', 'flag': '🇿🇦'},
  ];

  static const List<Map<String, String>> _phoneCodes = [
    {'label': '🇮🇳 +91', 'value': '+91'},
    {'label': '🇺🇸 +1', 'value': '+1'},
    {'label': '🇬🇧 +44', 'value': '+44'},
    {'label': '🇨🇦 +1', 'value': '+1'},
    {'label': '🇦🇺 +61', 'value': '+61'},
    {'label': '🇩🇪 +49', 'value': '+49'},
    {'label': '🇫🇷 +33', 'value': '+33'},
    {'label': '🇯🇵 +81', 'value': '+81'},
    {'label': '🇸🇬 +65', 'value': '+65'},
    {'label': '🇦🇪 +971', 'value': '+971'},
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms & Conditions'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo Signup Successful 🎉'),
        backgroundColor: AppColors.success,
      ),
    );

    // Redirect to onboarding directly
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    
    ref.read(authNotifierProvider.notifier).forceLogin(_emailController.text);
    context.go(AppRoutes.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
            children: [
              AuthHeader(
                showLogin: true,
                onLoginTap: () => context.go(AppRoutes.login),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: _SignupBody(
                          formKey: _formKey,
                          fullNameController: _fullNameController,
                          emailController: _emailController,
                          phoneController: _phoneController,
                          passwordController: _passwordController,
                          isLoading: _isLoading,
                          agreeToTerms: _agreeToTerms,
                          selectedCountry: _selectedCountry,
                          selectedPhoneCode: _selectedPhoneCode,
                          countries: _countries,
                          phoneCodes: _phoneCodes,
                          onCountryChanged: (v) =>
                              setState(() => _selectedCountry = v),
                          onPhoneCodeChanged: (v) =>
                              setState(() => _selectedPhoneCode = v ?? '+91'),
                          onTermsChanged: (v) =>
                              setState(() => _agreeToTerms = v ?? false),
                          onSignup: _handleSignup,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const FloatingChatButton(),
        ],
      ),
    );
  }
}

class _SignupBody extends StatelessWidget {
  const _SignupBody({
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.isLoading,
    required this.agreeToTerms,
    required this.selectedCountry,
    required this.selectedPhoneCode,
    required this.countries,
    required this.phoneCodes,
    required this.onCountryChanged,
    required this.onPhoneCodeChanged,
    required this.onTermsChanged,
    required this.onSignup,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool isLoading;
  final bool agreeToTerms;
  final String? selectedCountry;
  final String selectedPhoneCode;
  final List<Map<String, String>> countries;
  final List<Map<String, String>> phoneCodes;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onPhoneCodeChanged;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onSignup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xxl,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Create your account',
            style: AppTextStyles.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Join thousands of businesses on Naiyo24',
            style: AppTextStyles.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppSpacing.signupCardMaxWidth),
              child: _SignupCard(
                formKey: formKey,
                fullNameController: fullNameController,
                emailController: emailController,
                phoneController: phoneController,
                passwordController: passwordController,
                isLoading: isLoading,
                agreeToTerms: agreeToTerms,
                selectedCountry: selectedCountry,
                selectedPhoneCode: selectedPhoneCode,
                countries: countries,
                phoneCodes: phoneCodes,
                onCountryChanged: onCountryChanged,
                onPhoneCodeChanged: onPhoneCodeChanged,
                onTermsChanged: onTermsChanged,
                onSignup: onSignup,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            '© 2024 Naiyo24 · All rights reserved',
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SignupCard extends StatelessWidget {
  const _SignupCard({
    required this.formKey,
    required this.fullNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.isLoading,
    required this.agreeToTerms,
    required this.selectedCountry,
    required this.selectedPhoneCode,
    required this.countries,
    required this.phoneCodes,
    required this.onCountryChanged,
    required this.onPhoneCodeChanged,
    required this.onTermsChanged,
    required this.onSignup,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool isLoading;
  final bool agreeToTerms;
  final String? selectedCountry;
  final String selectedPhoneCode;
  final List<Map<String, String>> countries;
  final List<Map<String, String>> phoneCodes;
  final ValueChanged<String?> onCountryChanged;
  final ValueChanged<String?> onPhoneCodeChanged;
  final ValueChanged<bool?> onTermsChanged;
  final VoidCallback onSignup;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
            const GoogleButton(label: 'Sign up with Google'),
            const SizedBox(height: AppSpacing.md),
            const DividerWithText(),
            const SizedBox(height: AppSpacing.md),

            _CountryDropdown(
              value: selectedCountry,
              countries: countries,
              onChanged: onCountryChanged,
            ),
            const SizedBox(height: AppSpacing.md),

            CustomTextField(
              controller: fullNameController,
              hintText: 'John Doe',
              labelText: 'Full Name',
              prefixIcon: const Icon(
                Icons.person_outline_rounded,
                size: 20,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Name is required';
                if (v.trim().length < 2) return 'Enter a valid name';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            CustomTextField(
              controller: emailController,
              hintText: 'john@example.com',
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.email_outlined,
                size: 20,
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email is required';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            _PhoneField(
              phoneController: phoneController,
              selectedCode: selectedPhoneCode,
              phoneCodes: phoneCodes,
              onCodeChanged: onPhoneCodeChanged,
            ),
            const SizedBox(height: AppSpacing.md),

            PasswordField(
              controller: passwordController,
              hintText: 'Create a strong password',
              labelText: 'Password',
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password is required';
                if (v.length < 6) return 'Min 6 characters';
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            _TermsCheckbox(
              value: agreeToTerms,
              onChanged: onTermsChanged,
            ),
            const SizedBox(height: AppSpacing.lg),

            CustomButton(
              label: 'Create Account',
              isLoading: isLoading,
              onPressed: onSignup,
            ),
            const SizedBox(height: AppSpacing.lg),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: AppTextStyles.bodyMedium,
                ),
                GestureDetector(
                  onTap: () => context.go(AppRoutes.login),
                  child: Text(
                    'Login Here',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CountryDropdown extends StatelessWidget {
  const _CountryDropdown({
    required this.value,
    required this.countries,
    required this.onChanged,
  });

  final String? value;
  final List<Map<String, String>> countries;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      hint: Text(
        'Select Country',
        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
      ),
      decoration: const InputDecoration(
        labelText: 'Country',
        prefixIcon: Icon(
          Icons.public_outlined,
          size: 20,
        ),
      ),
      isExpanded: true,
      validator: (v) => v == null ? 'Please select a country' : null,
      onChanged: onChanged,
      items: countries
          .map(
            (c) => DropdownMenuItem<String>(
              value: c['name'],
              child: Text(
                '${c['flag']}  ${c['name']}',
                style: AppTextStyles.bodyMedium,
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.phoneController,
    required this.selectedCode,
    required this.phoneCodes,
    required this.onCodeChanged,
  });

  final TextEditingController phoneController;
  final String selectedCode;
  final List<Map<String, String>> phoneCodes;
  final ValueChanged<String?> onCodeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: DropdownButtonFormField<String>(
            initialValue: selectedCode,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Code',
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 14,
              ),
            ),
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
            onChanged: onCodeChanged,
            items: phoneCodes
                .map(
                  (c) => DropdownMenuItem<String>(
                    value: c['value'],
                    child: Text(
                      c['label']!,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: CustomTextField(
            controller: phoneController,
            hintText: '9876543210',
            labelText: 'Phone Number',
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(
              Icons.phone_outlined,
              size: 20,
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Phone is required';
              if (v.trim().length < 7) return 'Enter a valid phone number';
              return null;
            },
          ),
        ),
      ],
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyMedium,
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
