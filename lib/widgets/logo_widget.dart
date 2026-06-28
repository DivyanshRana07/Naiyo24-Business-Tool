import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/theme.dart';

/// Refrens-style purple logo widget.
///
/// Renders as inline text logo (no SVG dependency required for web).
class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
    this.fontSize = 24,
    this.showTagline = false,
    this.textColor,
    this.secondaryTextColor,
  });

  final double fontSize;
  final bool showTagline;
  final Color? textColor;
  final Color? secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    final wordmarkColor = secondaryTextColor ?? (textColor ?? AppColors.textPrimary);
    final primaryPartColor = textColor ?? AppColors.primary;
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
                gradient: textColor != null
                    ? null
                    : AppGradients.primaryButton,
                color: textColor != null ? Colors.white.withValues(alpha: 0.2) : null,
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
                      color: primaryPartColor,
                    ),
                  ),
                  TextSpan(
                    text: '24',
                    style: GoogleFonts.inter(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w800,
                      color: wordmarkColor,
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
              color: textColor ?? AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}
