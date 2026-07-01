import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../routes/app_routes.dart';
import '../../theme/theme.dart';
import '../../models/quotation_model.dart';
import '../../notifiers/auth_notifier.dart';
import '../../notifiers/quotation_notifier.dart';
import '../../widgets/dashboard_app_bar.dart';
import '../../widgets/side_navigation.dart';
import '../../widgets/export_dialog.dart';
import '../../widgets/send_options_dialog.dart';

class QuotationsScreen extends ConsumerStatefulWidget {
  const QuotationsScreen({super.key});

  @override
  ConsumerState<QuotationsScreen> createState() => _QuotationsScreenState();
}

class _QuotationsScreenState extends ConsumerState<QuotationsScreen> {
  String _searchQuery = '';

  void _logout(BuildContext context) {
    ref.read(authNotifierProvider.notifier).logout();
    context.go(AppRoutes.login);
  }

  Color _getStatusColor(QuotationStatus status) {
    switch (status) {
      case QuotationStatus.accepted:
        return AppColors.success;
      case QuotationStatus.rejected:
        return AppColors.error;
      case QuotationStatus.sent:
        return const Color(0xFF06B6D4);
      case QuotationStatus.viewed:
        return const Color(0xFF8B5CF6); // Purple
      case QuotationStatus.expired:
        return const Color(0xFFF59E0B); // Orange/Amber
      case QuotationStatus.draft:
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusLabel(QuotationStatus status) {
    switch (status) {
      case QuotationStatus.accepted:
        return 'Accepted';
      case QuotationStatus.rejected:
        return 'Rejected';
      case QuotationStatus.sent:
        return 'Sent';
      case QuotationStatus.viewed:
        return 'Viewed';
      case QuotationStatus.expired:
        return 'Expired';
      case QuotationStatus.draft:
      default:
        return 'Draft';
    }
  }

  void _showSendOptionsDialog(BuildContext context, QuotationModel quotation) {
    final formatCurrency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final formatDate = DateFormat('dd MMM yyyy');
    
    final waContent = [
      '*Naiyo24 Quotation*',
      'Quotation No: ${quotation.quotationNo}',
      'Client: ${quotation.customerName}',
      'Amount: ${formatCurrency.format(quotation.grandTotal)}',
    ].join('\n');

    final pdfContent = [
      'Naiyo24 Business Tool - Quotation',
      '========================================',
      'Quotation No: ${quotation.quotationNo}',
      'Client: ${quotation.customerName}',
      'Date: ${formatDate.format(quotation.quotationDate)}',
      'Amount: ${formatCurrency.format(quotation.grandTotal)}',
    ].join('\n');

    showDialog(
      context: context,
      builder: (_) => SendOptionsDialog(
        title: 'Quotation',
        whatsappText: waContent,
        pdfContent: pdfContent,
        filenamePrefix: 'quotation_${quotation.quotationNo}',
        onClose: () {},
      ),
    );
  }

  void _showStatusUpdateDialog(BuildContext context, QuotationModel quotation) {
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text('Update Status', style: AppTextStyles.h2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.lg)),
          backgroundColor: AppColors.surface,
          children: QuotationStatus.values.map((status) {
            final isSelected = quotation.status == status;
            return SimpleDialogOption(
              onPressed: () {
                final updated = quotation.copyWith(status: status);
                ref.read(quotationNotifierProvider.notifier).updateQuotation(updated);
                Navigator.of(ctx).pop();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      _getStatusLabel(status),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _handleExport(BuildContext context, List<QuotationModel> quotations) {
    final formatCurrency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final formatDate = DateFormat('dd MMM yyyy');

    final csvContent = [
      'Quotation No,Client,Date,Amount,Status',
      ...quotations.map((q) => '${q.quotationNo},"${q.customerName}",${formatDate.format(q.quotationDate)},"${formatCurrency.format(q.grandTotal)}",${_getStatusLabel(q.status)}')
    ].join('\n');

    final waContent = [
      '*Naiyo24 Quotation Export*',
      'Total Quotations: ${quotations.length}',
      ...quotations.map((q) => '- ${q.quotationNo} | ${q.customerName} | ${formatCurrency.format(q.grandTotal)} (${_getStatusLabel(q.status)})')
    ].join('\n');

    final pdfContent = [
      'Naiyo24 Business Tool - Quotations Report',
      '========================================',
      'Quotation No\tClient\tDate\tAmount\tStatus',
      ...quotations.map((q) => '${q.quotationNo}\t${q.customerName}\t${formatDate.format(q.quotationDate)}\t${formatCurrency.format(q.grandTotal)}\t${_getStatusLabel(q.status)}')
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
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final allQuotations = ref.watch(quotationNotifierProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    final quotations = allQuotations.where((q) {
      final query = _searchQuery.toLowerCase();
      return q.customerName.toLowerCase().contains(query) ||
             q.quotationNo.toLowerCase().contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DashboardAppBar(email: authState.userEmail),
      drawer: !isDesktop
          ? Drawer(
              child: SideNavigation(
                email: authState.userEmail,
                onLogout: () => _logout(context),
                currentRoute: AppRoutes.quotations,
              ),
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            SideNavigation(
              email: authState.userEmail,
              onLogout: () => _logout(context),
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
                            onPressed: () => _handleExport(context, quotations),
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
                            onPressed: () => context.push(AppRoutes.newQuotation),
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
                  _buildQuotationsTable(context, quotations),
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
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search by client name or quotation number...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                prefixIcon: const Icon(Icons.search_rounded, size: 22, color: AppColors.textSecondary),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          Container(
            height: 32,
            width: 1,
            color: AppColors.border,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.filter_list_rounded, size: 20),
              label: Text('Filter', style: AppTextStyles.labelLarge),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotationsTable(BuildContext context, List<QuotationModel> quotations) {
    final isDesktop = MediaQuery.of(context).size.width >= 700;
    final formatCurrency = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final formatDate = DateFormat('dd MMM yyyy');

    if (!isDesktop) {
      if (quotations.isEmpty) {
        return _buildEmptyState();
      }
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: quotations.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (_, i) {
          final q = quotations[i];
          final statusLabel = _getStatusLabel(q.status);
          final statusColor = _getStatusColor(q.status);
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
                    Text(q.quotationNo, style: AppTextStyles.labelLarge),
                    _buildStatusBadge(statusLabel, statusColor),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(q.customerName, style: AppTextStyles.h3),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatDate.format(q.quotationDate), style: AppTextStyles.bodyMedium),
                    Text(formatCurrency.format(q.grandTotal), style: AppTextStyles.labelLarge),
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

    if (quotations.isEmpty) {
      return _buildEmptyState();
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
          ...quotations.map((q) {
            final statusLabel = _getStatusLabel(q.status);
            final statusColor = _getStatusColor(q.status);
            return TableRow(
              children: [
                _buildCell(q.quotationNo, isBold: true),
                _buildCell(q.customerName),
                _buildCell(formatDate.format(q.quotationDate)),
                _buildCell(formatCurrency.format(q.grandTotal)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildStatusBadge(statusLabel, statusColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: () => _showStatusUpdateDialog(context, q),
                        tooltip: 'Change Status',
                      ),
                      IconButton(
                        icon: const Icon(Icons.send_rounded, size: 18),
                        onPressed: () => _showSendOptionsDialog(context, q),
                        tooltip: 'Send Quotation',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                        onPressed: () {
                          ref.read(quotationNotifierProvider.notifier).deleteQuotation(q.id);
                        },
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
  
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.border, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          const Icon(Icons.description_outlined,
              size: 48, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.md),
          Text(
            _searchQuery.isNotEmpty 
                ? 'No quotations match "$_searchQuery".'
                : 'No quotations found.\nClick "New Quotation" to create one.',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
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
