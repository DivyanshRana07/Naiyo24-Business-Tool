import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/theme.dart';
import '../../routes/app_routes.dart';
import '../../notifiers/auth_notifier.dart';
import '../../providers/sidebar_provider.dart';
import 'logo_widget.dart';

class DashboardAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key, this.email});
  final String? email;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Colors.transparent,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: Colors.white),
        onPressed: () {
          if (MediaQuery.of(context).size.width < 900) {
            Scaffold.of(context).openDrawer();
          } else {
            ref.read(sidebarExpandedProvider.notifier).toggle();
          }
        },
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6D28D9), Color(0xFF7C3AED)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      ),
      title: const Padding(
        padding: EdgeInsets.only(left: AppSpacing.xs),
        child: LogoWidget(
          fontSize: 20,
          textColor: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline_rounded, color: Colors.white),
          onPressed: () {},
          tooltip: 'Support',
        ),
        const SizedBox(width: AppSpacing.xs),
        IconButton(
          icon: const Badge(
            label: Text('3'),
            backgroundColor: Colors.white,
            textColor: Color(0xFF6D28D9),
            child: Icon(Icons.notifications_outlined, color: Colors.white),
          ),
          onPressed: () {},
          tooltip: 'Notifications',
        ),
        const SizedBox(width: AppSpacing.md),
        PopupMenuButton<String>(
          offset: const Offset(0, 48),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.md),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white.withValues(alpha: 0.25),
                child: Text(
                  (email?.isNotEmpty == true) ? email![0].toUpperCase() : 'D',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          onSelected: (value) {
            if (value == 'logout') {
              ref.read(authNotifierProvider.notifier).logout();
              context.go(AppRoutes.login);
            } else if (value == 'settings') {
              context.go(AppRoutes.settings);
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  const Icon(Icons.person_outline_rounded, size: 20, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text('My Profile', style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  const Icon(Icons.settings_outlined, size: 20, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text('Settings', style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
            const PopupMenuDivider(height: 1),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  const Icon(Icons.logout_rounded, size: 20, color: AppColors.error),
                  const SizedBox(width: 8),
                  Text(
                    'Logout',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
