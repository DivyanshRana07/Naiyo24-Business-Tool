import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/customer_model.dart';
import '../../../notifiers/customer_notifier.dart';
import '../../../theme/theme.dart';

/// Modal dialog for creating or editing a [CustomerModel].
/// All dropdown fields (status) use DropdownButtonFormField.
class CustomerFormDialog extends ConsumerStatefulWidget {
  const CustomerFormDialog({super.key, this.existing});

  final CustomerModel? existing;

  @override
  ConsumerState<CustomerFormDialog> createState() =>
      _CustomerFormDialogState();
}

class _CustomerFormDialogState extends ConsumerState<CustomerFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _codeCtrl;
  late TextEditingController _mobileCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _gstCtrl;
  late TextEditingController _creditLimitCtrl;
  late TextEditingController _openingBalanceCtrl;

  CustomerStatus _status = CustomerStatus.active;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _codeCtrl = TextEditingController(text: e?.code ?? '');
    _mobileCtrl = TextEditingController(text: e?.mobile ?? '');
    _emailCtrl = TextEditingController(text: e?.email ?? '');
    _addressCtrl = TextEditingController(text: e?.address ?? '');
    _gstCtrl = TextEditingController(text: e?.gstNumber ?? '');
    _creditLimitCtrl =
        TextEditingController(text: e?.creditLimit.toString() ?? '0');
    _openingBalanceCtrl =
        TextEditingController(text: e?.openingBalance.toString() ?? '0');
    _status = e?.status ?? CustomerStatus.active;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _mobileCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _gstCtrl.dispose();
    _creditLimitCtrl.dispose();
    _openingBalanceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.xl),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Header ─────────────────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.sm),
                        ),
                        child: const Icon(Icons.person_add_rounded,
                            color: Color(0xFF16A34A), size: 20),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        _isEditing ? 'Edit Client' : 'Add New Client',
                        style: AppTextStyles.h2,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        style: IconButton.styleFrom(
                            foregroundColor: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: AppSpacing.lg),

                  // ── Name ────────────────────────────────────────────────────
                  _label('Customer Name *'),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                        hintText: 'e.g. Rahul Medical Store'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Code & Mobile ───────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Customer Code *'),
                            TextFormField(
                              controller: _codeCtrl,
                              decoration: const InputDecoration(
                                  hintText: 'e.g. C001'),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Required'
                                      : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Mobile *'),
                            TextFormField(
                              controller: _mobileCtrl,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                  hintText: '10-digit number'),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Required'
                                      : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Email ───────────────────────────────────────────────────
                  _label('Email (optional)'),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: 'customer@example.com'),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Address ─────────────────────────────────────────────────
                  _label('Address (optional)'),
                  TextFormField(
                    controller: _addressCtrl,
                    maxLines: 2,
                    decoration: const InputDecoration(
                        hintText: 'Street, City, State - PIN'),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── GST No. ─────────────────────────────────────────────────
                  _label('GST Number (optional)'),
                  TextFormField(
                    controller: _gstCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                        hintText: '15-digit GSTIN e.g. 29ABCDE1234F1Z5'),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Credit Limit & Opening Balance ──────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Credit Limit (₹)'),
                            TextFormField(
                              controller: _creditLimitCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                  hintText: '0'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Opening Balance (₹)'),
                            TextFormField(
                              controller: _openingBalanceCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                  hintText: '0'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Status dropdown ─────────────────────────────────────────
                  _label('Status'),
                  DropdownButtonFormField<CustomerStatus>(
                    initialValue: _status,
                    isExpanded: true,
                    decoration: const InputDecoration(),
                    items: const [
                      DropdownMenuItem(
                          value: CustomerStatus.active,
                          child: Text('Active')),
                      DropdownMenuItem(
                          value: CustomerStatus.inactive,
                          child: Text('Inactive')),
                    ],
                    onChanged: (v) => setState(() => _status = v!),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // ── Actions ─────────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            minimumSize:
                                const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.md)),
                          ),
                          onPressed: _save,
                          child: Text(
                            _isEditing ? 'Save Changes' : 'Save Customer',
                            style: AppTextStyles.labelLarge
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(customerNotifierProvider.notifier);
    final customer = CustomerModel(
      id: widget.existing?.id ??
          'c-${DateTime.now().millisecondsSinceEpoch}',
      code: _codeCtrl.text.trim().toUpperCase(),
      name: _nameCtrl.text.trim(),
      mobile: _mobileCtrl.text.trim(),
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      address: _addressCtrl.text.trim().isEmpty
          ? null
          : _addressCtrl.text.trim(),
      gstNumber:
          _gstCtrl.text.trim().isEmpty ? null : _gstCtrl.text.trim(),
      creditLimit: double.tryParse(_creditLimitCtrl.text) ?? 0,
      openingBalance: double.tryParse(_openingBalanceCtrl.text) ?? 0,
      status: _status,
    );
    if (_isEditing) {
      notifier.updateCustomer(customer);
    } else {
      notifier.addCustomer(customer);
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? '${customer.name} updated successfully.'
              : '${customer.name} added to directory.',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
      );
}
