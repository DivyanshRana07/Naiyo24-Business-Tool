import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_theme.dart';

/// Top navigation header used across auth screens.
///
/// Shows [LogoWidget] on the left and action buttons on the right.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    this.showRegister = false,
    this.showLogin = false,
    this.onRegisterTap,
    this.onLoginTap,
    this.onSupportTap,
  });

  final bool showRegister;
  final bool showLogin;
  final VoidCallback? onRegisterTap;
  final VoidCallback? onLoginTap;
  final VoidCallback? onSupportTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppPadding.lg,
        vertical: AppPadding.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          // ── Logo ──────────────────────────────────────────────────
          _LogoMark(),
          const Spacer(),

          // ── Action buttons ────────────────────────────────────────
          _SupportButton(onTap: onSupportTap),
          const SizedBox(width: AppPadding.sm),
          if (showRegister)
            _RegisterButton(onTap: onRegisterTap),
          if (showLogin)
            _LoginButton(onTap: onLoginTap),
        ],
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: const Center(
            child: Text(
              'N',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Naiyo',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
              TextSpan(
                text: '24',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SupportButton extends StatelessWidget {
  const _SupportButton({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap ?? () {},
      icon: const Icon(Icons.headset_mic_outlined, size: 18),
      label: Text(
        'Support',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textSecondary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.md,
          vertical: AppPadding.sm,
        ),
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap ?? () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.md,
          vertical: AppPadding.sm,
        ),
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      child: Text(
        'Register',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap ?? () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.md,
          vertical: AppPadding.sm,
        ),
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      child: Text(
        'Login',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
