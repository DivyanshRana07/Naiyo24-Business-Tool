import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../../theme/theme.dart';
import '../../notifiers/auth_notifier.dart';
import '../../widgets/dashboard_app_bar.dart';
import '../../widgets/side_navigation.dart';
import '../../widgets/welcome_hero.dart';
import '../../cards/stat_card.dart';
import '../../cards/activity_card.dart';
import '../../cards/feature_block_card.dart';

/// Dashboard screen shown after successful login.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DashboardAppBar(email: authState.userEmail),
      drawer: MediaQuery.of(context).size.width < 900
          ? Drawer(
              child: SideNavigation(
                email: authState.userEmail,
                onLogout: () => _logout(ref, context),
                currentRoute: AppRoutes.dashboard,
              ),
            )
          : null,
      body: Row(
        children: [
          // Side navigation (desktop only)
          if (MediaQuery.of(context).size.width >= 900)
            SideNavigation(
              email: authState.userEmail,
              onLogout: () => _logout(ref, context),
              currentRoute: AppRoutes.dashboard,
            ),

          // Main content
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WelcomeHero(email: authState.userEmail),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    _StatsGrid(),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    _QuickActionsSection(),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    _GettingStartedGrid(),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    _RecentActivitySection(),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
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

// ─── Stats Grid ───────────────────────────────────────────────────────────────

class _StatsGrid extends StatelessWidget {
  static const List<Map<String, dynamic>> _statsData = [
    {
      'title': 'Total Revenue',
      'value': '₹2,48,500',
      'change': '+12.5%',
      'isPositive': true,
      'icon': Icons.currency_rupee_rounded,
      'color': AppColors.primary,
    },
    {
      'title': 'Pending Invoices',
      'value': '14',
      'change': '-3 from last month',
      'isPositive': true,
      'icon': Icons.receipt_rounded,
      'color': Color(0xFFF59E0B),
    },
    {
      'title': 'Active Clients',
      'value': '38',
      'change': '+5 new',
      'isPositive': true,
      'icon': Icons.people_rounded,
      'color': Color(0xFF22C55E),
    },
    {
      'title': 'Overdue',
      'value': '₹18,200',
      'change': '+2 invoices',
      'isPositive': false,
      'icon': Icons.warning_amber_rounded,
      'color': Color(0xFFEF4444),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        double cardWidth;
        if (width > 1200) {
          cardWidth = (width - (AppSpacing.lg * 3)) / 4;
        } else if (width > 600) {
          cardWidth = (width - AppSpacing.lg) / 2;
        } else {
          cardWidth = width;
        }

        return Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: _statsData.map((data) {
            return Container(
              width: cardWidth,
              constraints: const BoxConstraints(
                minWidth: 200,
                minHeight: 120,
              ),
              child: StatCard(
                title: data['title'] as String,
                value: data['value'] as String,
                change: data['change'] as String,
                isPositive: data['isPositive'] as bool,
                icon: data['icon'] as IconData,
                color: data['color'] as Color,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ─── Quick Actions ────────────────────────────────────────────────────────────

class _QuickActionsSection extends StatelessWidget {
  static const List<Map<String, dynamic>> _actions = [
    {'icon': Icons.receipt_long_rounded, 'label': 'New Invoice', 'color': AppColors.primary, 'route': AppRoutes.newInvoice},
    {'icon': Icons.description_outlined, 'label': 'New Quotation', 'color': Color(0xFF06B6D4), 'route': AppRoutes.newQuotation},
    {'icon': Icons.person_add_rounded, 'label': 'Add Client', 'color': Color(0xFF22C55E), 'route': AppRoutes.newClient},
    {'icon': Icons.inventory_2_outlined, 'label': 'Add Product', 'color': Color(0xFFF59E0B), 'route': AppRoutes.newProduct},
    {'icon': Icons.bar_chart_rounded, 'label': 'View Report', 'color': Color(0xFF8B5CF6), 'route': AppRoutes.reports},
    {'icon': Icons.send_rounded, 'label': 'Send Reminder', 'color': Color(0xFFEF4444), 'route': AppRoutes.sendReminder},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.h2,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: _actions
              .map((a) => ActionChip(
                    avatar: Icon(a['icon'] as IconData, size: 18, color: a['color'] as Color),
                    label: Text(
                      a['label'] as String,
                      style: AppTextStyles.labelLarge.copyWith(color: Colors.black87),
                    ),
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppBorderRadius.full),
                    ),
                    onPressed: () {
                      if (a['route'] != null) {
                        context.push(a['route'] as String);
                      }
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ─── Getting Started Grid ─────────────────────────────────────────────────────

class _GettingStartedGrid extends StatelessWidget {
  static const _blocks = [
    _BlockData(
      icon: Icons.receipt_long_rounded,
      iconColor: AppColors.primary,
      title: 'Invoices',
      description:
          'Create professional GST invoices, track payment status, send reminders to clients, and download PDFs instantly.',
      actionLabel: 'Create New Invoice',
      route: AppRoutes.newInvoice,
    ),
    _BlockData(
      icon: Icons.description_rounded,
      iconColor: Color(0xFF06B6D4),
      title: 'Quotations',
      description:
          'Send accurate estimates to clients and convert approved quotations into invoices with a single click.',
      actionLabel: 'Create New Quotation',
      route: AppRoutes.newQuotation,
    ),
    _BlockData(
      icon: Icons.account_balance_wallet_rounded,
      iconColor: Color(0xFFF59E0B),
      title: 'Expenses',
      description:
          'Record purchase orders, vendor bills, and day-to-day expenses to keep your books accurate and up to date.',
      actionLabel: 'Record New Purchase',
      route: AppRoutes.newExpense,
    ),
    _BlockData(
      icon: Icons.people_rounded,
      iconColor: Color(0xFF22C55E),
      title: 'Client Management',
      description:
          'Maintain a full client directory with contact details, billing history, and outstanding balance tracking.',
      actionLabel: 'Add New Client',
      route: AppRoutes.newClient,
    ),
    _BlockData(
      icon: Icons.leaderboard_rounded,
      iconColor: Color(0xFF8B5CF6),
      title: 'Lead Management',
      description:
          'Capture and nurture prospective clients through a simple pipeline. Convert leads to active clients seamlessly.',
      actionLabel: 'Add New Lead',
      route: AppRoutes.newLead,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Getting Started', style: AppTextStyles.h2),
        const SizedBox(height: AppSpacing.md),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 380,
            mainAxisSpacing: AppSpacing.lg,
            crossAxisSpacing: AppSpacing.lg,
            childAspectRatio: 0.78,
          ),
          itemCount: _blocks.length,
          itemBuilder: (context, i) {
            final b = _blocks[i];
            return FeatureBlockCard(
              icon: b.icon,
              iconColor: b.iconColor,
              title: b.title,
              description: b.description,
              actionLabel: b.actionLabel,
              onAction: () => context.go(b.route),
            );
          },
        ),
      ],
    );
  }
}

/// Immutable data holder for a single Getting Started block.
class _BlockData {
  const _BlockData({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.route,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String actionLabel;
  final String route;
}

// ─── Recent Activity ──────────────────────────────────────────────────────────

class _RecentActivitySection extends StatelessWidget {
  static const List<Map<String, dynamic>> _items = [
    {
      'title': 'Invoice #INV-0042 sent',
      'subtitle': 'Acme Corp · ₹12,500',
      'time': '2 hours ago',
      'icon': Icons.send_rounded,
      'color': AppColors.primary,
    },
    {
      'title': 'Payment received',
      'subtitle': 'TechSolutions Ltd · ₹45,000',
      'time': '5 hours ago',
      'icon': Icons.check_circle_rounded,
      'color': AppColors.success,
    },
    {
      'title': 'Invoice overdue',
      'subtitle': 'StartupXYZ · ₹8,200',
      'time': '1 day ago',
      'icon': Icons.warning_rounded,
      'color': AppColors.error,
    },
    {
      'title': 'New quotation created',
      'subtitle': 'GlobalRetail Inc · ₹32,000',
      'time': '2 days ago',
      'icon': Icons.description_rounded,
      'color': Color(0xFF06B6D4),
    },
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
              style: AppTextStyles.h2,
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View all',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        RepaintBoundary(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              border: Border.all(color: AppColors.border),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border),
              itemBuilder: (_, i) {
                final item = _items[i];
                return RepaintBoundary(
                  child: ActivityCard(
                    title: item['title'] as String,
                    subtitle: item['subtitle'] as String,
                    time: item['time'] as String,
                    icon: item['icon'] as IconData,
                    color: item['color'] as Color,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
