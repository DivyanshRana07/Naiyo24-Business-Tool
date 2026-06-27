import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_theme.dart';

/// Refrens-style purple logo widget.
///
/// Renders as inline text logo (no SVG dependency required for web).
class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
    this.fontSize = 24,
    this.showTagline = false,
  });

  final double fontSize;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon mark
            Container(
              width: fontSize * 1.2,
              height: fontSize * 1.2,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(fontSize * 0.25),
              ),
              child: Center(
                child: Text(
                  'N',
                  style: GoogleFonts.inter(
                    fontSize: fontSize * 0.65,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Wordmark
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Naiyo',
                    style: GoogleFonts.inter(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: '24',
                    style: GoogleFonts.inter(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showTagline) ...[
          const SizedBox(height: 4),
          Text(
            'Business Tool',
            style: GoogleFonts.inter(
              fontSize: fontSize * 0.5,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}
