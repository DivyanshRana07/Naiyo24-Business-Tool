import 'package:flutter/material.dart';

import '../theme/theme.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        color: _isHovered ? AppColors.surfaceHover : Colors.transparent,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: Icon(widget.icon, size: 20, color: widget.color),
          ),
          title: Text(
            widget.title,
            style: AppTextStyles.labelLarge,
          ),
          subtitle: Text(
            widget.subtitle,
            style: AppTextStyles.bodyMedium,
          ),
          trailing: Text(
            widget.time,
            style: AppTextStyles.caption,
          ),
        ),
      ),
    );
  }
}
