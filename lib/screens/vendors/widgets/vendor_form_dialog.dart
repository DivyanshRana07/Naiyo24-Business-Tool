import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/theme.dart';
import '../../../notifiers/vendor_notifier.dart';
import '../../../models/vendor_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_text_field.dart';

class VendorFormDialog extends ConsumerStatefulWidget {
  const VendorFormDialog({super.key, this.existingVendor, this.onSaved});
  
  final VendorModel? existingVendor;
  final Function(VendorModel)? onSaved;

  @override
  ConsumerState<VendorFormDialog> createState() => _VendorFormDialogState();
}

class _VendorFormDialogState extends ConsumerState<VendorFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _contactPersonController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final v = widget.existingVendor;
    _nameController = TextEditingController(text: v?.name ?? '');
    _contactPersonController = TextEditingController(text: v?.contactPerson ?? '');
    _emailController = TextEditingController(text: v?.email ?? '');
    _phoneController = TextEditingController(text: v?.phone ?? '');
    _addressController = TextEditingController(text: v?.address ?? '');
  }

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
    if (!_formKey.currentState!.validate()) return;

    final vendor = VendorModel(
      id: widget.existingVendor?.id ?? '',
      name: _nameController.text.trim(),
      contactPerson: _contactPersonController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );

    if (widget.existingVendor == null) {
      ref.read(vendorNotifierProvider.notifier).addVendor(vendor);
    } else {
      ref.read(vendorNotifierProvider.notifier).updateVendor(vendor);
    }
    
    if (widget.onSaved != null) {
      widget.onSaved!(vendor);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppBorderRadius.lg)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.existingVendor == null ? 'Add New Vendor' : 'Edit Vendor',
                    style: AppTextStyles.h2,
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              CustomTextField(
                controller: _nameController,
                labelText: 'Vendor / Company Name *',
                hintText: 'Enter vendor name',
                validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: _contactPersonController,
                labelText: 'Contact Person',
                hintText: 'Enter contact person name',
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _emailController,
                      labelText: 'Email Address',
                      hintText: 'Enter email',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: CustomTextField(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      hintText: 'Enter phone',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: _addressController,
                labelText: 'Billing Address',
                hintText: 'Enter complete billing address',
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Save Vendor'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
