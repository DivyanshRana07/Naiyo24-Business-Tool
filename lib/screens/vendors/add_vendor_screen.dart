import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../notifiers/auth_notifier.dart';
import '../../notifiers/vendor_notifier.dart';
import '../../models/vendor_model.dart';
import '../../routes/app_routes.dart';
import '../../theme/theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/dashboard_app_bar.dart';
import '../../widgets/side_navigation.dart';

class AddVendorScreen extends ConsumerStatefulWidget {
  const AddVendorScreen({super.key});

  @override
  ConsumerState<AddVendorScreen> createState() => _AddVendorScreenState();
}

class _AddVendorScreenState extends ConsumerState<AddVendorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _contactPersonController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final vendor = VendorModel(
        id: '',
        name: _nameController.text.trim(),
        contactPerson: _contactPersonController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
      );

      ref.read(vendorNotifierProvider.notifier).addVendor(vendor);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vendor "${vendor.name}" added successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }

  Future<bool> _onWillPop() async {
    if (_nameController.text.isNotEmpty ||
        _contactPersonController.text.isNotEmpty ||
        _emailController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty ||
        _addressController.text.isNotEmpty) {
      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep Editing'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
      return shouldPop ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final authState = ref.watch(authNotifierProvider);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: DashboardAppBar(email: authState.userEmail),
        drawer: !isDesktop
            ? Drawer(
                child: SideNavigation(
                  email: authState.userEmail,
                  onLogout: () => ref.read(authNotifierProvider.notifier).logout(),
                  currentRoute: AppRoutes.vendors,
                ),
              )
            : null,
        body: Row(
          children: [
            if (isDesktop)
              SideNavigation(
                email: authState.userEmail,
                onLogout: () => ref.read(authNotifierProvider.notifier).logout(),
                currentRoute: AppRoutes.vendors,
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () => context.pop(),
                                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceVariant,
                                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                                  ),
                                  child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppColors.textSecondary),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              const Icon(Icons.store_outlined, color: AppColors.primary, size: 28),
                              const SizedBox(width: AppSpacing.sm),
                              Text('Add New Vendor', style: AppTextStyles.h1),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Padding(
                            padding: const EdgeInsets.only(left: 48),
                            child: Text(
                              'Enter vendor details to track your expenses.',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Vendor Information', style: AppTextStyles.h2),
                                const SizedBox(height: AppSpacing.lg),
                                CustomTextField(
                                  controller: _nameController,
                                  labelText: 'Vendor / Company Name *',
                                  hintText: 'Enter vendor name',
                                  validator: (v) => v == null || v.isEmpty ? 'This field is required' : null,
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                CustomTextField(
                                  controller: _contactPersonController,
                                  labelText: 'Contact Person',
                                  hintText: 'Enter contact person name',
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        controller: _emailController,
                                        labelText: 'Email Address',
                                        hintText: 'Enter email',
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.md),
                                    Expanded(
                                      child: CustomTextField(
                                        controller: _phoneController,
                                        labelText: 'Phone Number',
                                        hintText: 'Enter phone',
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                CustomTextField(
                                  controller: _addressController,
                                  labelText: 'Billing Address',
                                  hintText: 'Enter complete billing address',
                                  maxLines: 3,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => context.pop(),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.md),
                                ),
                                child: Text('Cancel', style: AppTextStyles.labelLarge),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              CustomButton(
                                label: 'Save Vendor',
                                onPressed: _save,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
