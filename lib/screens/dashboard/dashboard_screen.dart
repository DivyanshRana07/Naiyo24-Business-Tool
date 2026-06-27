import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/routes/app_router.dart';
import '../../core/theme/app_theme.dart';
import '../../notifiers/auth_notifier.dart';
import '../../widgets/logo_widget.dart';

/// Dashboard screen shown after successful login.
///
/// Displays a simple overview and allows the user to logout.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _DashboardAppBar(email: authState.userEmail),
      drawer: MediaQuery.of(context).size.width < 900
          ? _DashboardDrawer(
              email: authState.userEmail,
              onLogout: () => _logout(ref, context),
            )
          : null,
      body: Row(
        children: [
          // Side navigation (desktop only)
          if (MediaQuery.of(context).size.width >= 900)
            _SideNavigation(
              email: authState.userEmail,
              onLogout: () => _logout(ref, context),
            ),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppPadding.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _WelcomeBanner(email: authState.userEmail),
                  const SizedBox(height: AppPadding.lg),
                  _StatsGrid(),
                  const SizedBox(height: AppPadding.lg),
                  _QuickActionsSection(),
                  const SizedBox(height: AppPadding.lg),
                  _RecentActivitySection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout(WidgetRef ref, BuildContext context) {
    ref.read(authNotifierProvider.notifier).logout();
    context.go(AppRoutes.login);
  }
}

// ─── AppBar ───────────────────────────────────────────────────────────────────

class _DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DashboardAppBar({this.email});
  final String? email;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.border,
      titleSpacing: 0,
      leading: MediaQuery.of(context).size.width < 900
          ? Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.menu_rounded),
                onPressed: () => Scaffold.of(ctx).openDrawer(),
              ),
            )
          : null,
      title: Padding(
        padding: const EdgeInsets.only(left: AppPadding.md),
        child: const LogoWidget(fontSize: 20),
      ),
      actions: [
        // Notification bell
        IconButton(
          icon: Badge(
            label: const Text('3'),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.notifications_outlined),
          ),
          onPressed: () {},
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppPadding.sm),
        // Avatar
        Padding(
          padding: const EdgeInsets.only(right: AppPadding.md),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              (email?.isNotEmpty == true)
                  ? email![0].toUpperCase()
                  : 'D',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Side Navigation ──────────────────────────────────────────────────────────

class _SideNavigation extends StatefulWidget {
  const _SideNavigation({this.email, required this.onLogout});
  final String? email;
  final VoidCallback onLogout;

  @override
  State<_SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<_SideNavigation> {
  int _selectedIndex = 0;

  static final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Dashboard'),
    _NavItem(icon: Icons.receipt_long_rounded, label: 'Invoices'),
    _NavItem(icon: Icons.description_rounded, label: 'Quotations'),
    _NavItem(icon: Icons.shopping_bag_rounded, label: 'Purchase Orders'),
    _NavItem(icon: Icons.people_rounded, label: 'Clients'),
    _NavItem(icon: Icons.inventory_2_rounded, label: 'Products'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'Reports'),
    _NavItem(icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppPadding.md),
              children: [
                // User info
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppPadding.md,
                    vertical: AppPadding.sm,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppPadding.md),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLighter,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            (widget.email?.isNotEmpty == true)
                                ? widget.email![0].toUpperCase()
                                : 'D',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Demo User',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                widget.email ?? '',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppPadding.sm),

                // Nav items
                ..._navItems.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  final selected = idx == _selectedIndex;
                  return _NavTile(
                    item: item,
                    selected: selected,
                    onTap: () => setState(() => _selectedIndex = idx),
                  );
                }),
              ],
            ),
          ),

          // Logout
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error, size: 20),
            title: Text(
              'Logout',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.error,
              ),
            ),
            onTap: widget.onLogout,
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppPadding.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: selected ? AppColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          item.icon,
          size: 20,
          color: selected ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(
          item.label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? AppColors.primary : AppColors.textSecondary,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }
}

// ─── Drawer (mobile) ──────────────────────────────────────────────────────────

class _DashboardDrawer extends StatelessWidget {
  const _DashboardDrawer({this.email, required this.onLogout});
  final String? email;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: _SideNavigation(email: email, onLogout: onLogout),
    );
  }
}

// ─── Welcome Banner ───────────────────────────────────────────────────────────

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({this.email});
  final String? email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, ${email?.split('@').first ?? 'Demo'} 👋',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Here\'s what\'s happening with your business today.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: AppPadding.md),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('New Invoice'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppPadding.md,
                      vertical: AppPadding.sm,
                    ),
                    textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.trending_up_rounded,
            color: Colors.white24,
            size: 80,
          ),
        ],
      ),
    );
  }
}

// ─── Stats Grid ───────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  static final List<_StatCard> _stats = [
    _StatCard(
      title: 'Total Revenue',
      value: '₹2,48,500',
      change: '+12.5%',
      isPositive: true,
      icon: Icons.currency_rupee_rounded,
      color: AppColors.primary,
    ),
    _StatCard(
      title: 'Pending Invoices',
      value: '14',
      change: '-3 from last month',
      isPositive: true,
      icon: Icons.receipt_rounded,
      color: Color(0xFFF59E0B),
    ),
    _StatCard(
      title: 'Active Clients',
      value: '38',
      change: '+5 new',
      isPositive: true,
      icon: Icons.people_rounded,
      color: Color(0xFF22C55E),
    ),
    _StatCard(
      title: 'Overdue',
      value: '₹18,200',
      change: '+2 invoices',
      isPositive: false,
      icon: Icons.warning_amber_rounded,
      color: Color(0xFFEF4444),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800
            ? 4
            : constraints.maxWidth > 500
                ? 2
                : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppPadding.md,
            crossAxisSpacing: AppPadding.md,
            childAspectRatio: 1.6,
          ),
          itemCount: _stats.length,
          itemBuilder: (_, i) => _StatCardWidget(stat: _stats[i]),
        );
      },
    );
  }
}

class _StatCard {
  const _StatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final IconData icon;
  final Color color;
}

class _StatCardWidget extends StatelessWidget {
  const _StatCardWidget({required this.stat});
  final _StatCard stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppPadding.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stat.title,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: stat.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(stat.icon, size: 18, color: stat.color),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stat.value,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                stat.change,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: stat.isPositive ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Quick Actions ────────────────────────────────────────────────────────────

class _QuickActionsSection extends StatelessWidget {
  static final List<_QuickAction> _actions = [
    _QuickAction(icon: Icons.receipt_long_rounded, label: 'New Invoice', color: AppColors.primary),
    _QuickAction(icon: Icons.description_outlined, label: 'New Quotation', color: Color(0xFF06B6D4)),
    _QuickAction(icon: Icons.person_add_rounded, label: 'Add Client', color: Color(0xFF22C55E)),
    _QuickAction(icon: Icons.inventory_2_outlined, label: 'Add Product', color: Color(0xFFF59E0B)),
    _QuickAction(icon: Icons.bar_chart_rounded, label: 'View Report', color: Color(0xFF8B5CF6)),
    _QuickAction(icon: Icons.send_rounded, label: 'Send Reminder', color: Color(0xFFEF4444)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppPadding.md),
        Wrap(
          spacing: AppPadding.md,
          runSpacing: AppPadding.md,
          children: _actions
              .map((a) => _QuickActionChip(action: a))
              .toList(),
        ),
      ],
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
  });
  final IconData icon;
  final String label;
  final Color color;
}

class _QuickActionChip extends StatelessWidget {
  const _QuickActionChip({required this.action});
  final _QuickAction action;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(action.icon, size: 18, color: action.color),
      label: Text(
        action.label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      backgroundColor: AppColors.surface,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      onPressed: () {},
    );
  }
}

// ─── Recent Activity ──────────────────────────────────────────────────────────

class _RecentActivitySection extends StatelessWidget {
  static final List<_ActivityItem> _items = [
    _ActivityItem(
      title: 'Invoice #INV-0042 sent',
      subtitle: 'Acme Corp · ₹12,500',
      time: '2 hours ago',
      icon: Icons.send_rounded,
      color: AppColors.primary,
    ),
    _ActivityItem(
      title: 'Payment received',
      subtitle: 'TechSolutions Ltd · ₹45,000',
      time: '5 hours ago',
      icon: Icons.check_circle_rounded,
      color: AppColors.success,
    ),
    _ActivityItem(
      title: 'Invoice overdue',
      subtitle: 'StartupXYZ · ₹8,200',
      time: '1 day ago',
      icon: Icons.warning_rounded,
      color: AppColors.error,
    ),
    _ActivityItem(
      title: 'New quotation created',
      subtitle: 'GlobalRetail Inc · ₹32,000',
      time: '2 days ago',
      icon: Icons.description_rounded,
      color: Color(0xFF06B6D4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: AppPadding.sm),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.border),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) => _ActivityTile(item: _items[i]),
          ),
        ),
      ],
    );
  }
}

class _ActivityItem {
  const _ActivityItem({
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
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item});
  final _ActivityItem item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: item.color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(item.icon, size: 18, color: item.color),
      ),
      title: Text(
        item.title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Text(
        item.time,
        style: GoogleFonts.inter(
          fontSize: 12,
          color: AppColors.textHint,
        ),
      ),
    );
  }
}
