import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/theme.dart';

/// "Continue with Google" button – UI only.
class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key, this.onPressed, this.label = 'Sign in with Google'});

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSpacing.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed ?? () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.googleButtonBg,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.googleButtonBorder, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.button),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/google_logo.svg',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.googleButtonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
