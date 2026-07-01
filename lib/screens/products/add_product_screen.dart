import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/product_model.dart';
import '../../notifiers/auth_notifier.dart';
import '../../notifiers/product_notifier.dart';
import '../../routes/app_routes.dart';
import '../../theme/theme.dart';
import '../../widgets/dashboard_app_bar.dart';
import '../../widgets/side_navigation.dart';

/// Full-page "Add New Product" screen.
/// Replicates the [ProductFormDialog] form as a routable Scaffold,
/// reachable via [AppRoutes.newProduct] from anywhere (e.g. Create Invoice).
class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl          = TextEditingController();
  final _codeCtrl          = TextEditingController();
  final _purchasePriceCtrl = TextEditingController();
  final _sellingPriceCtrl  = TextEditingController();
  final _stockCtrl         = TextEditingController();
  final _gstCtrl           = TextEditingController(text: '12');

  String _category        = 'Medicine';
  String _unit            = 'Strip';
  ProductStatus _status   = ProductStatus.active;
  bool _isSaving          = false;

  static const List<String> _categories = [
    'Medicine', 'Grocery', 'Electronics', 'Clothing',
    'Food & Beverage', 'Cosmetics', 'Stationery', 'Other',
  ];

  static const List<String> _units = [
    'Strip', 'Capsule', 'Tablet', 'Bottle', 'Kg', 'Gram',
    'Litre', 'Ml', 'Piece', 'Box', 'Packet', 'Other',
  ];

  static const List<double> _gstRates = [0, 5, 12, 18, 28];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _purchasePriceCtrl.dispose();
    _sellingPriceCtrl.dispose();
    _stockCtrl.dispose();
    _gstCtrl.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final hasInput = _nameCtrl.text.isNotEmpty ||
        _codeCtrl.text.isNotEmpty ||
        _purchasePriceCtrl.text.isNotEmpty ||
        _sellingPriceCtrl.text.isNotEmpty ||
        _stockCtrl.text.isNotEmpty ||
        (_gstCtrl.text.isNotEmpty && _gstCtrl.text != '12');

    if (!hasInput) return true;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Discard Changes?', style: AppTextStyles.h2),
        content: Text('You have unsaved changes. Are you sure you want to discard them?', style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('Discard', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
    return confirm ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isMedium  = MediaQuery.of(context).size.width >= 900;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.background,
      appBar: DashboardAppBar(email: authState.userEmail, showBackButton: true),
      drawer: !isMedium
          ? Drawer(
              child: SideNavigation(
                email: authState.userEmail,
                onLogout: () =>
                    ref.read(authNotifierProvider.notifier).logout(),
                currentRoute: AppRoutes.products,
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
              currentRoute: AppRoutes.products,
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
                                      color: AppColors.primaryLight,
                                      borderRadius: BorderRadius.circular(
                                          AppBorderRadius.sm),
                                    ),
                                    child: const Icon(
                                        Icons.inventory_2_rounded,
                                        color: AppColors.primary,
                                        size: 20),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text('Product Details',
                                      style: AppTextStyles.h2),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              const Divider(color: AppColors.border),
                              const SizedBox(height: AppSpacing.lg),

                              // ── Product Name ─────────────────────────────
                              _label('Product Name *'),
                              TextFormField(
                                controller: _nameCtrl,
                                decoration: const InputDecoration(
                                    hintText: 'e.g. Paracetamol 650mg'),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // ── Code ─────────────────────────────────────
                              _label('Product Code / SKU *'),
                              TextFormField(
                                controller: _codeCtrl,
                                decoration: const InputDecoration(
                                    hintText: 'e.g. P001'),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // ── Category & Unit ──────────────────────────
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Category *'),
                                        DropdownButtonFormField<String>(
                                          initialValue: _category,
                                          isExpanded: true,
                                          decoration:
                                              const InputDecoration(),
                                          items: _categories
                                              .map((c) => DropdownMenuItem(
                                                  value: c,
                                                  child: Text(c)))
                                              .toList(),
                                          onChanged: (v) => setState(
                                              () => _category = v!),
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
                                        _label('Unit *'),
                                        DropdownButtonFormField<String>(
                                          initialValue: _unit,
                                          isExpanded: true,
                                          decoration:
                                              const InputDecoration(),
                                          items: _units
                                              .map((u) => DropdownMenuItem(
                                                  value: u,
                                                  child: Text(u)))
                                              .toList(),
                                          onChanged: (v) =>
                                              setState(() => _unit = v!),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // ── Prices ───────────────────────────────────
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Purchase Price (₹) *'),
                                        TextFormField(
                                          controller: _purchasePriceCtrl,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                              decimal: true),
                                          decoration: const InputDecoration(
                                              hintText: '0.00'),
                                          validator: _validatePrice,
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
                                        _label('Selling Price (₹) *'),
                                        TextFormField(
                                          controller: _sellingPriceCtrl,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                              decimal: true),
                                          decoration: const InputDecoration(
                                              hintText: '0.00'),
                                          validator: _validatePrice,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // ── Stock & GST ──────────────────────────────
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label('Opening Stock'),
                                        TextFormField(
                                          controller: _stockCtrl,
                                          keyboardType:
                                              TextInputType.number,
                                          decoration: const InputDecoration(
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
                                        _label('GST % *'),
                                        DropdownButtonFormField<double>(
                                          initialValue:
                                              double.tryParse(
                                                      _gstCtrl.text) ??
                                                  12,
                                          isExpanded: true,
                                          decoration:
                                              const InputDecoration(),
                                          items: _gstRates
                                              .map((g) => DropdownMenuItem(
                                                    value: g,
                                                    child: Text(
                                                        '${g.toStringAsFixed(0)}%'),
                                                  ))
                                              .toList(),
                                          onChanged: (v) => _gstCtrl
                                              .text = v!.toStringAsFixed(0),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.md),

                              // ── Status ───────────────────────────────────
                              _label('Status'),
                              DropdownButtonFormField<ProductStatus>(
                                initialValue: _status,
                                isExpanded: true,
                                decoration: const InputDecoration(),
                                items: const [
                                  DropdownMenuItem(
                                      value: ProductStatus.active,
                                      child: Text('Active')),
                                  DropdownMenuItem(
                                      value: ProductStatus.inactive,
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
                                      onPressed: () {
                                         if (context.canPop()) {
                                           context.pop();
                                         } else {
                                           context.go(AppRoutes.products);
                                         }
                                       },
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
                                        backgroundColor: AppColors.primary,
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
                                              Icons.inventory_2_rounded,
                                              size: 18,
                                              color: Colors.white),
                                      label: Text(
                                        _isSaving
                                            ? 'Saving...'
                                            : 'Save Product',
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
    ),);
  }

  // ── Save ────────────────────────────────────────────────────────────────────

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final product = ProductModel(
      id: 'p-${DateTime.now().millisecondsSinceEpoch}',
      code: _codeCtrl.text.trim().toUpperCase(),
      name: _nameCtrl.text.trim(),
      category: _category,
      unit: _unit,
      purchasePrice: double.tryParse(_purchasePriceCtrl.text) ?? 0,
      sellingPrice: double.tryParse(_sellingPriceCtrl.text) ?? 0,
      stockQty: int.tryParse(_stockCtrl.text) ?? 0,
      gstPercent: double.tryParse(_gstCtrl.text) ?? 0,
      status: _status,
    );

    ref.read(productNotifierProvider.notifier).addProduct(product);

    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to inventory.'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Go back to wherever the user came from (e.g. Create Invoice)
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.products);
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  String? _validatePrice(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (double.tryParse(v) == null) return 'Enter a valid number';
    return null;
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.products);
            }
          },
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
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: const Icon(Icons.inventory_2_rounded,
              color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text('Add New Product', style: AppTextStyles.h1),
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
