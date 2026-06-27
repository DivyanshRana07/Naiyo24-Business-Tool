import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_theme.dart';

/// "Continue with Google" button – UI only.
class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key, this.onPressed, this.label = 'Sign in with Google'});

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizing.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed ?? () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.googleBg,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google coloured "G" icon drawn with rich text
            _GoogleIcon(),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inline Google "G" icon using coloured text segments.
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'G',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4285F4), // Google blue
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
