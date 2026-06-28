import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/theme.dart';
import '../../routes/app_routes.dart';
import '../../providers/sidebar_provider.dart';

class SideNavigation extends ConsumerStatefulWidget {
  const SideNavigation({
    super.key,
    this.email,
    required this.onLogout,
    required this.currentRoute,
  });

  final String? email;
  final VoidCallback onLogout;
  final String currentRoute;

  @override
  ConsumerState<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends ConsumerState<SideNavigation> {
  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard', route: AppRoutes.dashboard),
    _NavItem(icon: Icons.receipt_long_rounded, label: 'Invoices', route: AppRoutes.invoices),
    _NavItem(icon: Icons.description_rounded, label: 'Quotations', route: AppRoutes.quotations),
    _NavItem(icon: Icons.shopping_bag_rounded, label: 'Purchase Orders', route: AppRoutes.purchases),
    _NavItem(icon: Icons.people_rounded, label: 'Clients', route: AppRoutes.clients),
    _NavItem(icon: Icons.inventory_2_rounded, label: 'Products', route: AppRoutes.products),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'Reports', route: AppRoutes.reports),
    _NavItem(icon: Icons.settings_rounded, label: 'Settings', route: AppRoutes.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final isExpanded = ref.watch(sidebarExpandedProvider);

    return MouseRegion(
      onEnter: (_) => ref.read(sidebarExpandedProvider.notifier).setExpanded(true),
      onExit: (_) => ref.read(sidebarExpandedProvider.notifier).setExpanded(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: isExpanded ? 260 : 70,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(right: BorderSide(color: AppColors.border, width: 1)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                children: [
                  // User Profile Box
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Row(
                        mainAxisAlignment: isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              (widget.email?.isNotEmpty == true) ? widget.email![0].toUpperCase() : 'D',
                              style: const TextStyle(
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (isExpanded) ...[
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Demo User',
                                    style: AppTextStyles.labelLarge,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    widget.email ?? '',
                                    style: AppTextStyles.caption,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ..._navItems.map((item) {
                    final selected = widget.currentRoute == item.route;
                    return _NavTile(
                      item: item,
                      selected: selected,
                      isExpanded: isExpanded,
                      onTap: () {
                        if (!selected) {
                          context.go(item.route);
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),
            _NavTile(
              item: const _NavItem(icon: Icons.logout_rounded, label: 'Logout', route: ''),
              selected: false,
              isExpanded: isExpanded,
              isErrorColor: true,
              onTap: widget.onLogout,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label, required this.route});
  final IconData icon;
  final String label;
  final String route;
}

class _NavTile extends StatefulWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.isExpanded,
    required this.onTap,
    this.isErrorColor = false,
  });

  final _NavItem item;
  final bool selected;
  final bool isExpanded;
  final VoidCallback onTap;
  final bool isErrorColor;

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.isErrorColor ? AppColors.error : AppColors.primary;
    
    Color bgColor = Colors.transparent;
    Color iconColor = AppColors.textSecondary;
    Color textColor = AppColors.textSecondary;

    if (widget.selected) {
      bgColor = activeColor.withValues(alpha: 0.12);
      iconColor = activeColor;
      textColor = activeColor;
    }

    if (_isHovered) {
      bgColor = widget.isErrorColor ? AppColors.error : const Color(0xFF7C3AED);
      iconColor = Colors.white;
      textColor = Colors.white;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: widget.selected
              ? Border(left: BorderSide(color: activeColor, width: 4))
              : null,
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            child: Row(
              mainAxisAlignment: widget.isExpanded ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Icon(
                  widget.item.icon,
                  size: 20,
                  color: iconColor,
                ),
                if (widget.isExpanded) ...[
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      widget.item.label,
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w500,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
