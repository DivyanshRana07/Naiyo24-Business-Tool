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

  Widget _buildResourceItem(IconData icon, String text, {Color? iconColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor ?? AppColors.primary),
        const SizedBox(width: AppSpacing.sm),
        Text(text, style: AppTextStyles.bodyMedium),
      ],
    );
  }

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
          secondaryTextColor: Colors.black,
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
          icon: const Icon(Icons.bolt_outlined, color: Colors.white),
          onPressed: () {},
          tooltip: 'Latest Updates',
        ),
        const SizedBox(width: AppSpacing.xs),
        PopupMenuButton<String>(
          offset: const Offset(0, 48),
          elevation: 4,
          tooltip: 'Resources',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          icon: const Icon(Icons.headset_mic_outlined, color: Colors.white),
          itemBuilder: (context) => [
            PopupMenuItem(
              enabled: false,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Text('Resources', style: AppTextStyles.h3),
            ),
            PopupMenuItem(
              value: 'book_demo',
              child: _buildResourceItem(Icons.calendar_today_outlined, 'Book a Demo'),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'help_articles',
              child: _buildResourceItem(Icons.menu_book_outlined, 'Read Help Articles'),
            ),
            PopupMenuItem(
              value: 'demo_videos',
              child: _buildResourceItem(Icons.play_circle_filled_rounded, 'View Demo Videos', iconColor: Colors.red),
            ),
            const PopupMenuDivider(),
            PopupMenuItem(
              value: 'report_issue',
              child: _buildResourceItem(Icons.bug_report_outlined, 'Report an Issue'),
            ),
            PopupMenuItem(
              value: 'request_feature',
              child: _buildResourceItem(Icons.open_in_new_rounded, 'Request a Feature'),
            ),
            PopupMenuItem(
              value: 'new_updates',
              child: _buildResourceItem(Icons.celebration_outlined, 'Explore New Updates'),
            ),
            PopupMenuItem(
              value: 'keyboard_shortcuts',
              child: _buildResourceItem(Icons.key_outlined, 'Keyboard Shortcuts'),
            ),
          ],
        ),
        const SizedBox(width: AppSpacing.xs),
        PopupMenuButton<String>(
          offset: const Offset(0, 48),
          elevation: 4,
          tooltip: 'Notifications',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          icon: const Badge(
            label: Text('3'),
            backgroundColor: Colors.white,
            textColor: Color(0xFF6D28D9),
            child: Icon(Icons.notifications_outlined, color: Colors.white),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              enabled: false,
              padding: EdgeInsets.zero,
              child: SizedBox(
                width: 360,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Notifications', style: AppTextStyles.h3),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Mark all as read', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                                  const SizedBox(width: AppSpacing.md),
                                  Text('View All', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.notifications_none_rounded, size: 48, color: AppColors.primaryMid),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text('No Notifications here', style: AppTextStyles.h3),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Nothing to worry. We will notify you regarding important activities here.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
