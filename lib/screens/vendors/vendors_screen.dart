import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../notifiers/vendor_notifier.dart';
import '../../notifiers/auth_notifier.dart';
import '../../theme/theme.dart';
import '../../routes/app_routes.dart';
import '../../widgets/dashboard_app_bar.dart';
import '../../widgets/side_navigation.dart';
import 'widgets/vendor_form_dialog.dart';

class VendorsScreen extends ConsumerWidget {
  const VendorsScreen({super.key});

  void _logout(WidgetRef ref, BuildContext context) {
    ref.read(authNotifierProvider.notifier).logout();
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final vendors = ref.watch(vendorNotifierProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DashboardAppBar(email: authState.userEmail),
      drawer: !isDesktop
          ? Drawer(
              child: SideNavigation(
                email: authState.userEmail,
                onLogout: () => _logout(ref, context),
                currentRoute: AppRoutes.vendors,
              ),
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            SideNavigation(
              email: authState.userEmail,
              onLogout: () => _logout(ref, context),
              currentRoute: AppRoutes.vendors,
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Manage Vendors', style: AppTextStyles.h1),
                          const SizedBox(height: 4),
                          Text('Manage your vendor list for purchase orders and expenses.', style: AppTextStyles.bodyMedium),
                        ],
                      ),
                      FilledButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => const VendorFormDialog(),
                          );
                        },
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Add New Vendor'),
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
                  const SizedBox(height: AppSpacing.xxl),
                  if (vendors.isEmpty)
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
                            Icon(Icons.store_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.4)),
                            const SizedBox(height: AppSpacing.lg),
                            Text('No vendors added yet.', style: AppTextStyles.h3),
                            const SizedBox(height: AppSpacing.sm),
                            Text('Add your first vendor to start creating purchase orders.', style: AppTextStyles.bodyMedium),
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
                          DataColumn(label: Text('Vendor Name', style: AppTextStyles.labelLarge)),
                          DataColumn(label: Text('Contact Person', style: AppTextStyles.labelLarge)),
                          DataColumn(label: Text('Email', style: AppTextStyles.labelLarge)),
                          DataColumn(label: Text('Phone', style: AppTextStyles.labelLarge)),
                          DataColumn(label: Text('Actions', style: AppTextStyles.labelLarge)),
                        ],
                        rows: vendors.map((vendor) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                      child: Text(
                                        vendor.name.isNotEmpty ? vendor.name[0].toUpperCase() : 'V',
                                        style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Text(vendor.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              DataCell(Text(vendor.contactPerson.isEmpty ? '-' : vendor.contactPerson, style: AppTextStyles.bodyMedium)),
                              DataCell(Text(vendor.email.isEmpty ? '-' : vendor.email, style: AppTextStyles.bodyMedium)),
                              DataCell(Text(vendor.phone.isEmpty ? '-' : vendor.phone, style: AppTextStyles.bodyMedium)),
                              DataCell(
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) => VendorFormDialog(existingVendor: vendor),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                                      onPressed: () {
                                        ref.read(vendorNotifierProvider.notifier).deleteVendor(vendor.id);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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
