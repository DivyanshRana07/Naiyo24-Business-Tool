import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../notifiers/activity_notifier.dart';
import '../../notifiers/auth_notifier.dart';
import '../../theme/theme.dart';
import '../../cards/activity_card.dart';
import '../../widgets/dashboard_app_bar.dart';
import '../../widgets/side_navigation.dart';
import '../../widgets/export_dialog.dart';
import '../../routes/app_routes.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  void _logout(WidgetRef ref, BuildContext context) {
    ref.read(authNotifierProvider.notifier).logout();
    context.go(AppRoutes.login);
  }

  void _handleExport(BuildContext context, List<dynamic> activities) {
    final csvContent = [
      'Activity,Details,Time',
      ...activities.map((a) => '"${a.title}","${a.subtitle}","${a.time}"')
    ].join('\n');

    final waContent = [
      '*Naiyo24 Recent Activity Export*',
      'Total Activities: ${activities.length}',
      ...activities.map((a) => '- ${a.title} | ${a.subtitle} | ${a.time}')
    ].join('\n');

    final pdfContent = [
      'Naiyo24 Business Tool - Recent Activity Log',
      '==========================================',
      'Activity\tDetails\tTime',
      ...activities.map((a) => '${a.title}\t${a.subtitle}\t${a.time}')
    ].join('\n');

    showDialog(
      context: context,
      builder: (_) => ExportOptionsDialog(
        title: 'Recent Activity',
        csvContent: csvContent,
        whatsappText: waContent,
        pdfContent: pdfContent,
        filenamePrefix: 'activity_log',
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final activities = ref.watch(activityNotifierProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DashboardAppBar(email: authState.userEmail),
      drawer: !isDesktop
          ? Drawer(
              child: SideNavigation(
                email: authState.userEmail,
                onLogout: () => _logout(ref, context),
                currentRoute: AppRoutes.reports,
              ),
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            SideNavigation(
              email: authState.userEmail,
              onLogout: () => _logout(ref, context),
              currentRoute: AppRoutes.reports,
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => context.go(AppRoutes.dashboard),
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                          ),
                          child: const Icon(Icons.arrow_back_rounded,
                              size: 20, color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      const Icon(Icons.history_rounded,
                          color: AppColors.primary, size: 28),
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'History',
                              style: AppTextStyles.h1,
                            ),
                            Text(
                              'All activities completed on the platform.',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Activity',
                        style: AppTextStyles.h2,
                      ),
                      OutlinedButton.icon(
                        onPressed: () => _handleExport(context, activities),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.md),
                          ),
                        ),
                        icon: const Icon(Icons.download_rounded,
                            size: 16, color: AppColors.textPrimary),
                        label: Text('Export',
                            style: AppTextStyles.labelMedium
                                .copyWith(color: AppColors.textPrimary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (activities.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Center(
                        child: Text('No recent activity found.'),
                      ),
                    )
                  else
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
                          itemCount: activities.length,
                          separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border),
                          itemBuilder: (_, i) {
                            final item = activities[i];
                            return RepaintBoundary(
                              child: ActivityCard(
                                title: item.title,
                                subtitle: item.subtitle,
                                time: item.time,
                                icon: item.icon,
                                color: item.color,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
