import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../notifiers/purchase_order_notifier.dart';
import '../../notifiers/auth_notifier.dart';
import '../../models/purchase_order_model.dart';
import '../../theme/theme.dart';
import '../../routes/app_routes.dart';
import '../../widgets/dashboard_app_bar.dart';
import '../../widgets/side_navigation.dart';

class PurchaseOrdersScreen extends ConsumerStatefulWidget {
  const PurchaseOrdersScreen({super.key});

  @override
  ConsumerState<PurchaseOrdersScreen> createState() => _PurchaseOrdersScreenState();
}

class _PurchaseOrdersScreenState extends ConsumerState<PurchaseOrdersScreen> {
  POStatus? _filterStatus;

  void _logout(BuildContext context) {
    ref.read(authNotifierProvider.notifier).logout();
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final pos = ref.watch(purchaseOrderNotifierProvider);
    final filteredPos = _filterStatus == null
        ? pos
        : pos.where((p) => p.status == _filterStatus).toList();
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    final totalUnpayed = pos
        .where((p) => p.status == POStatus.unpayed)
        .fold(0.0, (sum, p) => sum + p.totalAmount);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DashboardAppBar(email: authState.userEmail),
      drawer: !isDesktop
          ? Drawer(
              child: SideNavigation(
                email: authState.userEmail,
                onLogout: () => _logout(context),
                currentRoute: AppRoutes.purchaseOrders,
              ),
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            SideNavigation(
              email: authState.userEmail,
              onLogout: () => _logout(context),
              currentRoute: AppRoutes.purchaseOrders,
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Purchase Orders', style: AppTextStyles.h1),
                          const SizedBox(height: 4),
                          Text('Manage and track all your purchase orders.', style: AppTextStyles.bodyMedium),
                        ],
                      ),
                      FilledButton.icon(
                        onPressed: () => context.push(AppRoutes.newPurchaseOrder),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Create PO'),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Filter chips
                  Row(
                    children: [
                      Text('Filter by Status: ', style: AppTextStyles.bodyMedium),
                      const SizedBox(width: AppSpacing.sm),
                      _filterChip('All', _filterStatus == null, () => setState(() => _filterStatus = null)),
                      const SizedBox(width: AppSpacing.sm),
                      _filterChip('Unpaid', _filterStatus == POStatus.unpayed, () => setState(() => _filterStatus = POStatus.unpayed)),
                      const SizedBox(width: AppSpacing.sm),
                      _filterChip('Paid', _filterStatus == POStatus.payed, () => setState(() => _filterStatus = POStatus.payed)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Table
                  if (pos.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.4)),
                            const SizedBox(height: AppSpacing.lg),
                            Text('No purchase orders found.', style: AppTextStyles.h3),
                            const SizedBox(height: AppSpacing.sm),
                            Text('Create a new purchase order to track expenses.', style: AppTextStyles.bodyMedium),
                          ],
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                        border: Border.all(color: AppColors.border),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(AppColors.background),
                        dividerThickness: 1,
                        dataRowMaxHeight: 64,
                        dataRowMinHeight: 64,
                        columns: [
                          DataColumn(label: Text('PO Number', style: AppTextStyles.labelLarge)),
                          DataColumn(label: Text('Date', style: AppTextStyles.labelLarge)),
                          DataColumn(label: Text('Vendor', style: AppTextStyles.labelLarge)),
                          DataColumn(label: Text('Total Amount', style: AppTextStyles.labelLarge)),
                          DataColumn(label: Text('Status', style: AppTextStyles.labelLarge)),
                        ],
                        rows: filteredPos.map((po) {
                          final isPayed = po.status == POStatus.payed;
                          return DataRow(
                            cells: [
                              DataCell(Text(po.poNumber, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600))),
                              DataCell(Text(DateFormat('MMM dd, yyyy').format(po.date), style: AppTextStyles.bodyMedium)),
                              DataCell(Text(po.vendorName, style: AppTextStyles.bodyMedium)),
                              DataCell(Text('₹${po.totalAmount.toStringAsFixed(2)}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600))),
                              DataCell(
                                Tooltip(
                                  message: 'Tap to toggle status',
                                  child: InkWell(
                                    onTap: () => ref.read(purchaseOrderNotifierProvider.notifier).toggleStatus(po.id),
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isPayed
                                            ? AppColors.success.withValues(alpha: 0.1)
                                            : AppColors.error.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(100),
                                        border: Border.all(
                                          color: isPayed ? AppColors.success : AppColors.error,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isPayed ? Icons.check_circle_rounded : Icons.warning_rounded,
                                            size: 14,
                                            color: isPayed ? AppColors.success : AppColors.error,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            isPayed ? 'Paid' : 'Unpaid',
                                            style: AppTextStyles.labelLarge.copyWith(
                                              color: isPayed ? AppColors.success : AppColors.error,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),

                  const SizedBox(height: AppSpacing.xxl),

                  // Total Unpaid Summary Banner
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6D28D9), Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppBorderRadius.xl),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6D28D9).withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Unpaid Balance',
                              style: AppTextStyles.labelLarge.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${totalUnpayed.toStringAsFixed(2)}',
                              style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 32),
                            ),
                          ],
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
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withValues(alpha: 0.1),
      labelStyle: AppTextStyles.labelLarge.copyWith(
        color: selected ? AppColors.primary : AppColors.textSecondary,
        fontSize: 13,
      ),
      side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
      backgroundColor: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
    );
  }
}
