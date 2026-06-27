import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_theme.dart';

/// A horizontal divider with centred label text – e.g. "OR".
class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key, this.text = 'OR'});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.divider, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.md),
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textHint,
              letterSpacing: 1,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.divider, thickness: 1),
        ),
      ],
    );
  }
}
