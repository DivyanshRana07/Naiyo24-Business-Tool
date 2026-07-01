import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_routes.dart';
import '../../theme/theme.dart';
import '../../notifiers/auth_notifier.dart';
import '../../widgets/dashboard_app_bar.dart';
import '../../widgets/side_navigation.dart';
import '../../widgets/export_dialog.dart';

class QuotationsScreen extends ConsumerWidget {
  const QuotationsScreen({super.key});

  static const List<Map<String, dynamic>> _quotationsData = [
    {
      'id': 'QTN-2026-001',
      'client': 'Acme Corp',
      'date': '28 Jun 2026',
      'amount': '₹15,000',
      'status': 'Accepted',
      'statusColor': AppColors.success,
    },
    {
      'id': 'QTN-2026-002',
      'client': 'TechSolutions Ltd',
      'date': '25 Jun 2026',
      'amount': '₹50,000',
      'status': 'Accepted',
      'statusColor': AppColors.success,
    },
    {
      'id': 'QTN-2026-003',
      'client': 'StartupXYZ',
      'date': '20 Jun 2026',
      'amount': '₹9,500',
      'status': 'Declined',
      'statusColor': AppColors.error,
    },
    {
      'id': 'QTN-2026-004',
      'client': 'GlobalRetail Inc',
      'date': '18 Jun 2026',
      'amount': '₹35,000',
      'status': 'Sent',
      'statusColor': Color(0xFF06B6D4),
    },
    {
      'id': 'QTN-2026-005',
      'client': 'BetaCorp',
      'date': '15 Jun 2026',
      'amount': '₹20,000',
      'status': 'Draft',
      'statusColor': AppColors.textSecondary,
    },
  ];

  void _logout(WidgetRef ref, BuildContext context) {
    ref.read(authNotifierProvider.notifier).logout();
    context.go(AppRoutes.login);
  }

  void _handleExport(BuildContext context) {
    final csvContent = [
      'Quotation No,Client,Date,Amount,Status',
      ..._quotationsData.map((q) => '${q['id']},"${q['client']}",${q['date']},"${q['amount']}",${q['status']}')
    ].join('\n');

    final waContent = [
      '*Naiyo24 Quotation Export*',
      'Total Quotations: ${_quotationsData.length}',
      ..._quotationsData.map((q) => '- ${q['id']} | ${q['client']} | ${q['amount']} (${q['status']})')
    ].join('\n');

    final pdfContent = [
      'Naiyo24 Business Tool - Quotations Report',
      '========================================',
      'Quotation No\tClient\tDate\tAmount\tStatus',
      ..._quotationsData.map((q) => '${q['id']}\t${q['client']}\t${q['date']}\t${q['amount']}\t${q['status']}')
    ].join('\n');

    showDialog(
      context: context,
      builder: (_) => ExportOptionsDialog(
        title: 'Quotations',
        csvContent: csvContent,
        whatsappText: waContent,
        pdfContent: pdfContent,
        filenamePrefix: 'quotations',
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DashboardAppBar(email: authState.userEmail),
      drawer: !isDesktop
          ? Drawer(
              child: SideNavigation(
                email: authState.userEmail,
                onLogout: () => _logout(ref, context),
                currentRoute: AppRoutes.quotations,
              ),
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            SideNavigation(
              email: authState.userEmail,
              onLogout: () => _logout(ref, context),
              currentRoute: AppRoutes.quotations,
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
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
                          const Icon(Icons.description_rounded,
                              color: AppColors.primary, size: 28),
                          const SizedBox(width: AppSpacing.sm),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Quotations', style: AppTextStyles.h1),
                                const SizedBox(height: AppSpacing.xs),
                                Text('Send estimates to clients and convert them to invoices.', style: AppTextStyles.bodyMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () => _handleExport(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.border),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(AppBorderRadius.md),
                              ),
                            ),
                            icon: const Icon(Icons.download_rounded,
                                size: 18, color: AppColors.textPrimary),
                            label: Text('Export',
                                style: AppTextStyles.labelLarge
                                    .copyWith(color: AppColors.textPrimary)),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('New Quotation'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textOnPrimary,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  
                  // Filter bar
                  _buildFilterBar(),
                  const SizedBox(height: AppSpacing.lg),

                  // Quotations list / table
                  _buildQuotationsTable(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by client name or quotation number...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20),
                contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded, size: 18),
            label: const Text('Filter'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.button),
              ),
              side: const BorderSide(color: AppColors.border),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationsTable(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 700;

    if (!isDesktop) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _quotationsData.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, i) {
          final data = _quotationsData[i];
          return Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data['id'] as String, style: AppTextStyles.labelLarge),
                    _buildStatusBadge(data['status'] as String, data['statusColor'] as Color),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(data['client'] as String, style: AppTextStyles.h3),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data['date'] as String, style: AppTextStyles.bodyMedium),
                    Text(data['amount'] as String, style: AppTextStyles.labelLarge),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Edit')),
                    const SizedBox(width: AppSpacing.sm),
                    TextButton(onPressed: () {}, child: const Text('Convert to Invoice')),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1.2),
          3: FlexColumnWidth(1.2),
          4: FlexColumnWidth(1.2),
          5: FlexColumnWidth(1.8),
        },
        children: [
          // Table Header
          TableRow(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppBorderRadius.xl),
                topRight: Radius.circular(AppBorderRadius.xl),
              ),
            ),
            children: [
              _buildHeaderCell('QUOTATION ID'),
              _buildHeaderCell('CLIENT'),
              _buildHeaderCell('DATE'),
              _buildHeaderCell('AMOUNT'),
              _buildHeaderCell('STATUS'),
              _buildHeaderCell('ACTIONS', alignRight: true),
            ],
          ),
          // Table Rows
          ..._quotationsData.map((data) {
            return TableRow(
              children: [
                _buildCell(data['id'] as String, isBold: true),
                _buildCell(data['client'] as String),
                _buildCell(data['date'] as String),
                _buildCell(data['amount'] as String),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildStatusBadge(data['status'] as String, data['statusColor'] as Color),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: () {},
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        icon: const Icon(Icons.transform_rounded, size: 18),
                        onPressed: () {},
                        tooltip: 'Convert to Invoice',
                      ),
                      IconButton(
                        icon: const Icon(Icons.send_rounded, size: 18),
                        onPressed: () {},
                        tooltip: 'Send Quotation',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                        onPressed: () {},
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {bool alignRight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
      child: Text(
        text,
        style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary),
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
      ),
    );
  }

  Widget _buildCell(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
      child: Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
