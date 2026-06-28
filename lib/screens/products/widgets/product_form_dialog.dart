import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/product_model.dart';
import '../../../notifiers/product_notifier.dart';
import '../../../theme/theme.dart';

/// Modal dialog for creating or editing a [ProductModel].
/// All category/unit/status fields use DropdownButtonFormField (searchable).
class ProductFormDialog extends ConsumerStatefulWidget {
  const ProductFormDialog({super.key, this.existing});

  /// If non-null, the dialog pre-fills all fields for editing.
  final ProductModel? existing;

  @override
  ConsumerState<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends ConsumerState<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _codeCtrl;
  late TextEditingController _purchasePriceCtrl;
  late TextEditingController _sellingPriceCtrl;
  late TextEditingController _stockCtrl;
  late TextEditingController _gstCtrl;

  String _category = 'Medicine';
  String _unit = 'Strip';
  ProductStatus _status = ProductStatus.active;

  bool get _isEditing => widget.existing != null;

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
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _codeCtrl = TextEditingController(text: e?.code ?? '');
    _purchasePriceCtrl =
        TextEditingController(text: e?.purchasePrice.toString() ?? '');
    _sellingPriceCtrl =
        TextEditingController(text: e?.sellingPrice.toString() ?? '');
    _stockCtrl = TextEditingController(text: e?.stockQty.toString() ?? '');
    _gstCtrl =
        TextEditingController(text: e?.gstPercent.toStringAsFixed(0) ?? '12');
    _category = e?.category ?? 'Medicine';
    _unit = e?.unit ?? 'Strip';
    _status = e?.status ?? ProductStatus.active;
  }

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
                          color: AppColors.primaryLight,
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.sm),
                        ),
                        child: const Icon(Icons.inventory_2_rounded,
                            color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        _isEditing ? 'Edit Product' : 'Add New Product',
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

                  // ── Product Name ────────────────────────────────────────────
                  _label('Product Name *'),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Paracetamol 650mg',
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Code ────────────────────────────────────────────────────
                  _label('Product Code / SKU *'),
                  TextFormField(
                    controller: _codeCtrl,
                    decoration:
                        const InputDecoration(hintText: 'e.g. P001'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Category & Unit (side by side) ──────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Category *'),
                            DropdownButtonFormField<String>(
                              initialValue: _category,
                              isExpanded: true,
                              decoration: const InputDecoration(),
                              items: _categories
                                  .map((c) => DropdownMenuItem(
                                      value: c, child: Text(c)))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _category = v!),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Unit *'),
                            DropdownButtonFormField<String>(
                              initialValue: _unit,
                              isExpanded: true,
                              decoration: const InputDecoration(),
                              items: _units
                                  .map((u) => DropdownMenuItem(
                                      value: u, child: Text(u)))
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

                  // ── Prices ──────────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Purchase Price (₹) *'),
                            TextFormField(
                              controller: _purchasePriceCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Selling Price (₹) *'),
                            TextFormField(
                              controller: _sellingPriceCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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

                  // ── Stock & GST ─────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Opening Stock'),
                            TextFormField(
                              controller: _stockCtrl,
                              keyboardType: TextInputType.number,
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
                            _label('GST % *'),
                            DropdownButtonFormField<double>(
                              initialValue: double.tryParse(_gstCtrl.text) ?? 12,
                              isExpanded: true,
                              decoration: const InputDecoration(),
                              items: _gstRates
                                  .map((g) => DropdownMenuItem(
                                      value: g,
                                      child: Text('${g.toStringAsFixed(0)}%')))
                                  .toList(),
                              onChanged: (v) => _gstCtrl.text =
                                  v!.toStringAsFixed(0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Status ──────────────────────────────────────────────────
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
                            backgroundColor: AppColors.primary,
                            minimumSize:
                                const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.md)),
                          ),
                          onPressed: _save,
                          child: Text(
                            _isEditing ? 'Save Changes' : 'Save Product',
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
    final notifier = ref.read(productNotifierProvider.notifier);
    final product = ProductModel(
      id: widget.existing?.id ??
          'p-${DateTime.now().millisecondsSinceEpoch}',
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
    if (_isEditing) {
      notifier.updateProduct(product);
    } else {
      notifier.addProduct(product);
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? '${product.name} updated successfully.'
              : '${product.name} added to inventory.',
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String? _validatePrice(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    if (double.tryParse(v) == null) return 'Enter a valid number';
    return null;
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary)),
      );
}
