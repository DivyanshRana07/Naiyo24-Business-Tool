import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class WelcomeHero extends StatelessWidget {
  const WelcomeHero({super.key, this.email});
  final String? email;

  @override
  Widget build(BuildContext context) {
    final displayName = email != null && email!.contains('@')
        ? email!.split('@').first
        : 'Demo User';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6D28D9), Color(0xFF4C1D95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6D28D9).withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome back, $displayName! 👋',
                  style: AppTextStyles.h1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Here\'s what\'s happening with your business today. Track your invoices, quotations, and active clients in one place.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          if (MediaQuery.of(context).size.width > 700) ...[
            const SizedBox(width: AppSpacing.xl),
            const Icon(
              Icons.dashboard_customize_rounded,
              color: Colors.white24,
              size: 80,
            ),
          ],
        ],
      ),
    );
  }
}
