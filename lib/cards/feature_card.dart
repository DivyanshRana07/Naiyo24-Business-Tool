import 'package:flutter/material.dart';

import '../theme/theme.dart';

class FeatureCard extends StatefulWidget {
  const FeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryActionLabel,
    this.secondaryActionLabel,
    this.onPrimaryTap,
    this.onSecondaryTap,
    required this.color,
  });

  final String title;
  final String description;
  final IconData icon;
  final String primaryActionLabel;
  final String? secondaryActionLabel;
  final VoidCallback? onPrimaryTap;
  final VoidCallback? onSecondaryTap;
  final Color color;

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppBorderRadius.xl),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _isHovered ? 0.08 : 0.03),
              blurRadius: _isHovered ? 24 : 12,
              offset: Offset(0, _isHovered ? 12 : 4),
            ),
          ],
        ),
        transform: Matrix4.translationValues(0.0, _isHovered ? -6.0 : 0.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, size: 32, color: widget.color),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              widget.title,
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: Text(
                widget.description,
                style: AppTextStyles.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onPrimaryTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.button),
                      ),
                    ),
                    child: Text(
                      widget.primaryActionLabel,
                      style: AppTextStyles.labelLarge.copyWith(color: AppColors.textOnPrimary),
                    ),
                  ),
                ),
                if (widget.secondaryActionLabel != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  TextButton(
                    onPressed: widget.onSecondaryTap,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppBorderRadius.button),
                      ),
                    ),
                    child: Text(
                      widget.secondaryActionLabel!,
                      style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
