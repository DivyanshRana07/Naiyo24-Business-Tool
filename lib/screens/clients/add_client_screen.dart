import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/customer_model.dart';
import '../../notifiers/auth_notifier.dart';
import '../../notifiers/customer_notifier.dart';
import '../../routes/app_routes.dart';
import '../../theme/theme.dart';
import '../../widgets/dashboard_app_bar.dart';
import '../../widgets/side_navigation.dart';

/// Full-page "Add New Client" screen.
/// Replicates the [CustomerFormDialog] form but as a routable Scaffold,
/// so it can be reached via [AppRoutes.newClient] from anywhere (e.g. the
/// Create Invoice screen).
class AddClientScreen extends ConsumerStatefulWidget {
  const AddClientScreen({super.key});

  @override
  ConsumerState<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends ConsumerState<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl           = TextEditingController();
  final _codeCtrl           = TextEditingController();
  final _mobileCtrl         = TextEditingController();
  final _emailCtrl          = TextEditingController();
  final _addressCtrl        = TextEditingController();
  final _gstCtrl            = TextEditingController();
  final _creditLimitCtrl    = TextEditingController(text: '0');
  final _openingBalanceCtrl = TextEditingController(text: '0');

  CustomerStatus _status = CustomerStatus.active;
  bool _isSaving = false;

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
    final authState = ref.watch(authNotifierProvider);
    final isMedium  = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DashboardAppBar(email: authState.userEmail),
      drawer: !isMedium
          ? Drawer(
              child: SideNavigation(
                email: authState.userEmail,
                onLogout: () =>
                    ref.read(authNotifierProvider.notifier).logout(),
                currentRoute: AppRoutes.clients,
              ),
            )
          : null,
      body: Row(
        children: [
          if (isMedium)
            SideNavigation(
              email: authState.userEmail,
              onLogout: () =>
                  ref.read(authNotifierProvider.notifier).logout(),
              currentRoute: AppRoutes.clients,
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Page header ──────────────────────────────────────────
                    _header(context),
                    const SizedBox(height: AppSpacing.xl),

                    // ── Form card ────────────────────────────────────────────
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 640),
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.xl),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius:
                                BorderRadius.circular(AppBorderRadius.xl),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Card header
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(
                                          AppBorderRadius.sm),
                                    ),
                                    child: const Icon(
                                        Icons.person_add_rounded,
                                        color: Color(0xFF16A34A),
                                        size: 20),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text('Client Details',
                                      style: AppTextStyles.h2),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              const Divider(color: AppColors.border),
                              const SizedBox(height: AppSpacing.lg),

                              // ── Name ──────────────────────────────────────
                              _label('Customer Name *'),
                              TextFormField(
                                controller: _nameCtrl,
                                decoration: const InputDecoration(
                                    hintText: 'e.g. Rahul Medical Store'),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // ── Code & Mobile ────────────────────────────
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Mobile *'),
                                        TextFormField(
                                          controller: _mobileCtrl,
                                          keyboardType:
                                              TextInputType.phone,
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

                              // ── Email ────────────────────────────────────
                              _label('Email (optional)'),
                              TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    hintText: 'customer@example.com'),
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // ── Address ──────────────────────────────────
                              _label('Address (optional)'),
                              TextFormField(
                                controller: _addressCtrl,
                                maxLines: 2,
                                decoration: const InputDecoration(
                                    hintText:
                                        'Street, City, State - PIN'),
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // ── GST ──────────────────────────────────────
                              _label('GST Number (optional)'),
                              TextFormField(
                                controller: _gstCtrl,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: const InputDecoration(
                                    hintText:
                                        '15-digit GSTIN e.g. 29ABCDE1234F1Z5'),
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // ── Credit Limit & Opening Balance ───────────
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Credit Limit (₹)'),
                                        TextFormField(
                                          controller: _creditLimitCtrl,
                                          keyboardType:
                                              const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                          decoration:
                                              const InputDecoration(
                                                  hintText: '0'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Opening Balance (₹)'),
                                        TextFormField(
                                          controller:
                                              _openingBalanceCtrl,
                                          keyboardType:
                                              const TextInputType
                                                  .numberWithOptions(
                                                  decimal: true),
                                          decoration:
                                              const InputDecoration(
                                                  hintText: '0'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // ── Status ───────────────────────────────────
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
                                onChanged: (v) =>
                                    setState(() => _status = v!),
                              ),
                              const SizedBox(height: AppSpacing.xl),

                              // ── Actions ──────────────────────────────────
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => context.pop(),
                                      style: OutlinedButton.styleFrom(
                                        minimumSize:
                                            const Size(double.infinity, 48),
                                        side: const BorderSide(
                                            color: AppColors.border),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(
                                                  AppBorderRadius.md),
                                        ),
                                      ),
                                      child: const Text('Cancel'),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.md),
                                  Expanded(
                                    child: FilledButton.icon(
                                      onPressed:
                                          _isSaving ? null : _save,
                                      style: FilledButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF16A34A),
                                        minimumSize:
                                            const Size(double.infinity, 48),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(
                                                  AppBorderRadius.md),
                                        ),
                                      ),
                                      icon: _isSaving
                                          ? const SizedBox(
                                              width: 16,
                                              height: 16,
                                              child:
                                                  CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.person_add_rounded,
                                              size: 18,
                                              color: Colors.white),
                                      label: Text(
                                        _isSaving
                                            ? 'Saving...'
                                            : 'Save Client',
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

  // ── Save ────────────────────────────────────────────────────────────────────

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final customer = CustomerModel(
      id: 'c-${DateTime.now().millisecondsSinceEpoch}',
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

    ref.read(customerNotifierProvider.notifier).addCustomer(customer);

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${customer.name} added to directory.'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Go back to wherever the user came from (e.g. Create Invoice)
    context.pop();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  Widget _header(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
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
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: const Icon(Icons.person_add_rounded,
              color: Color(0xFF16A34A), size: 24),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text('Add New Client', style: AppTextStyles.h1),
      ],
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      );
}
