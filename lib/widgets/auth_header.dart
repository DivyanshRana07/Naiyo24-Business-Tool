import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/theme.dart';

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
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        gradient: AppGradients.navbar,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // ── Logo ──────────────────────────────────────────────────
            _LogoMark(),
            const Spacer(),

            // ── Action buttons ────────────────────────────────────────
            _SupportButton(onTap: onSupportTap),
            const SizedBox(width: AppSpacing.sm),
            if (showRegister)
              _RegisterButton(onTap: onRegisterTap),
            if (showLogin)
              _LoginButton(onTap: onLoginTap),
          ],
        ),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: const Center(
            child: Text(
              'N',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
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
                  color: AppColors.textOnPrimary,
                ),
              ),
              TextSpan(
                text: '24',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textOnPrimary,
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
      icon: const Icon(Icons.headset_mic_outlined, size: 18, color: AppColors.textOnPrimary),
      label: Text(
        'Support',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textOnPrimary,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textOnPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
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
        foregroundColor: AppColors.textOnPrimary,
        side: const BorderSide(color: AppColors.textOnPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
      ),
      child: Text(
        'Register',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnPrimary,
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
        foregroundColor: AppColors.textOnPrimary,
        side: const BorderSide(color: AppColors.textOnPrimary, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        minimumSize: Size.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
      ),
      child: Text(
        'Login',
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnPrimary,
        ),
      ),
    );
  }
}
