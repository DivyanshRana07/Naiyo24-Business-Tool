import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/service_model.dart';
import '../../../notifiers/service_notifier.dart';
import '../../../theme/theme.dart';

/// Modal dialog for creating or editing a [ServiceModel].
class ServiceFormDialog extends ConsumerStatefulWidget {
  const ServiceFormDialog({super.key, this.existing});

  final ServiceModel? existing;

  @override
  ConsumerState<ServiceFormDialog> createState() => _ServiceFormDialogState();
}

class _ServiceFormDialogState extends ConsumerState<ServiceFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _codeCtrl;
  late TextEditingController _priceCtrl;

  String _category = 'Delivery';
  double _gstPercent = 18;
  ServiceStatus _status = ServiceStatus.active;

  bool get _isEditing => widget.existing != null;

  static const List<String> _categories = [
    'Delivery', 'Consulting', 'Laboratory', 'Installation',
    'Repair', 'Subscription', 'Maintenance', 'Other',
  ];

  static const List<double> _gstRates = [0, 5, 12, 18, 28];

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _codeCtrl = TextEditingController(text: e?.code ?? '');
    _priceCtrl =
        TextEditingController(text: e?.sellingPrice.toString() ?? '');
    _category = e?.category ?? 'Delivery';
    _gstPercent = e?.gstPercent ?? 18;
    _status = e?.status ?? ServiceStatus.active;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _priceCtrl.dispose();
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
        constraints: const BoxConstraints(maxWidth: 480),
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
                          color: const Color(0xFFE0F2FE),
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.sm),
                        ),
                        child: const Icon(Icons.miscellaneous_services_rounded,
                            color: Color(0xFF0284C7), size: 20),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        _isEditing ? 'Edit Service' : 'Add New Service',
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

                  // ── Service Name ────────────────────────────────────────────
                  _label('Service Name *'),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Home Delivery',
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Code ────────────────────────────────────────────────────
                  _label('Service Code *'),
                  TextFormField(
                    controller: _codeCtrl,
                    decoration:
                        const InputDecoration(hintText: 'e.g. S001'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Category dropdown ───────────────────────────────────────
                  _label('Category *'),
                  DropdownButtonFormField<String>(
                    initialValue: _category,
                    isExpanded: true,
                    decoration: const InputDecoration(),
                    items: _categories
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _category = v!),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Price & GST ─────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('Price (₹) *'),
                            TextFormField(
                              controller: _priceCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                  hintText: '0.00'),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Required';
                                }
                                if (double.tryParse(v) == null) {
                                  return 'Invalid number';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _label('GST %'),
                            DropdownButtonFormField<double>(
                              initialValue: _gstPercent,
                              isExpanded: true,
                              decoration: const InputDecoration(),
                              items: _gstRates
                                  .map((g) => DropdownMenuItem(
                                      value: g,
                                      child: Text(
                                          '${g.toStringAsFixed(0)}%')))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _gstPercent = v!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // ── Status ──────────────────────────────────────────────────
                  _label('Status'),
                  DropdownButtonFormField<ServiceStatus>(
                    initialValue: _status,
                    isExpanded: true,
                    decoration: const InputDecoration(),
                    items: const [
                      DropdownMenuItem(
                          value: ServiceStatus.active,
                          child: Text('Active')),
                      DropdownMenuItem(
                          value: ServiceStatus.inactive,
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
                            backgroundColor: const Color(0xFF0284C7),
                            minimumSize:
                                const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppBorderRadius.md)),
                          ),
                          onPressed: _save,
                          child: Text(
                            _isEditing ? 'Save Changes' : 'Save Service',
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
    final notifier = ref.read(serviceNotifierProvider.notifier);
    final service = ServiceModel(
      id: widget.existing?.id ??
          's-${DateTime.now().millisecondsSinceEpoch}',
      code: _codeCtrl.text.trim().toUpperCase(),
      name: _nameCtrl.text.trim(),
      category: _category,
      sellingPrice: double.tryParse(_priceCtrl.text) ?? 0,
      gstPercent: _gstPercent,
      status: _status,
    );
    if (_isEditing) {
      notifier.updateService(service);
    } else {
      notifier.addService(service);
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? '${service.name} updated successfully.'
              : '${service.name} added to catalog.',
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
