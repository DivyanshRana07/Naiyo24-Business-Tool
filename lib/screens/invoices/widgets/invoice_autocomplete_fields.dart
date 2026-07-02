import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/invoice_line_item.dart';
import '../../../models/customer_model.dart';
import '../../../models/product_model.dart';
import '../../../models/service_model.dart';
import '../../../notifiers/customer_notifier.dart';
import '../../../notifiers/product_notifier.dart';
import '../../../notifiers/service_notifier.dart';
import '../../../theme/theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Customer Autocomplete Dropdown
// ─────────────────────────────────────────────────────────────────────────────

/// Searchable autocomplete dropdown that lets the user pick an existing
/// [CustomerModel] by name, mobile, or code.
class CustomerAutocomplete extends ConsumerWidget {
  const CustomerAutocomplete({
    super.key,
    required this.onSelected,
    this.selectedCustomer,
  });

  final void Function(CustomerModel) onSelected;
  final CustomerModel? selectedCustomer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCustomers = ref.watch(customerNotifierProvider);

    return Autocomplete<CustomerModel>(
      initialValue: selectedCustomer != null
          ? TextEditingValue(text: selectedCustomer!.name)
          : TextEditingValue.empty,
      displayStringForOption: (c) => c.name,
      optionsBuilder: (TextEditingValue val) {
        if (val.text.isEmpty) return allCustomers;
        return ref
            .read(customerNotifierProvider.notifier)
            .search(val.text);
      },
      optionsViewBuilder: (context, onSelected, options) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;
        final boxWidth = isMobile ? screenWidth - 48 : 400.0;
        return Align(
          alignment: Alignment.topLeft,
          child: UnconstrainedBox(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: boxWidth,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                color: AppColors.surface,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (ctx, i) {
                      final c = options.elementAt(i);
                      return InkWell(
                        onTap: () => onSelected(c),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.1),
                            child: Text(
                              c.name[0].toUpperCase(),
                              style: AppTextStyles.caption.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(c.name,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600)),
                                Text(c.mobile,
                                    style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Text(c.code,
                              style: AppTextStyles.caption
                                  .copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ),
          ),
        );
      },
      fieldViewBuilder:
          (context, controller, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: const InputDecoration(
            hintText: 'Search customer by name or mobile...',
            prefixIcon: Icon(Icons.person_search_rounded,
                color: AppColors.textSecondary, size: 20),
            suffixIcon: Icon(Icons.arrow_drop_down,
                color: AppColors.textSecondary),
          ),
          validator: (_) => selectedCustomer == null
              ? 'Please select a customer'
              : null,
        );
      },
      onSelected: (c) {
        Future.delayed(Duration.zero, () => onSelected(c));
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Item Search Autocomplete (Products + Services unified)
// ─────────────────────────────────────────────────────────────────────────────

/// Unified item result – wraps either a product or a service.
class _ItemResult {
  const _ItemResult.product(this.product) : service = null;
  const _ItemResult.service(this.service) : product = null;

  final ProductModel? product;
  final ServiceModel? service;

  String get name => product?.name ?? service!.name;
  String get code => product?.code ?? service!.code;
  double get price => product?.sellingPrice ?? service!.sellingPrice;
  double get gst => product?.gstPercent ?? service!.gstPercent;
  LineItemType get type =>
      product != null ? LineItemType.product : LineItemType.service;
  String get id => product?.id ?? service!.id;
  String get typeLabel => product != null ? 'Product' : 'Service';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is _ItemResult &&
          other.product?.id == product?.id &&
          other.service?.id == service?.id);

  @override
  int get hashCode => (product?.id ?? service!.id).hashCode;
}

/// Searchable autocomplete that searches both Products and Services
/// simultaneously. When an item is selected, [onSelected] is called with
/// a pre-filled [InvoiceLineItem] ready to be added to the invoice.
class ItemSearchAutocomplete extends ConsumerStatefulWidget {
  const ItemSearchAutocomplete({
    super.key,
    required this.onSelected,
  });

  final void Function(InvoiceLineItem) onSelected;

  @override
  ConsumerState<ItemSearchAutocomplete> createState() =>
      _ItemSearchAutocompleteState();
}

class _ItemSearchAutocompleteState
    extends ConsumerState<ItemSearchAutocomplete> {
  TextEditingController? _fieldController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch providers to keep them alive and avoid auto-dispose thrashing
    ref.watch(productNotifierProvider);
    ref.watch(serviceNotifierProvider);

    return Autocomplete<_ItemResult>(
      displayStringForOption: (r) => r.name,
      optionsBuilder: (val) {
        final q = val.text;
        if (q.isEmpty) return const [];
        final products = ref
            .read(productNotifierProvider.notifier)
            .search(q)
            .map((p) => _ItemResult.product(p));
        final services = ref
            .read(serviceNotifierProvider.notifier)
            .search(q)
            .map((s) => _ItemResult.service(s));
        return [...products, ...services];
      },
      optionsViewBuilder: (context, onSelected, options) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;
        final boxWidth = isMobile ? screenWidth - 48 : 480.0;
        return Align(
          alignment: Alignment.topLeft,
          child: UnconstrainedBox(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: boxWidth,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                color: AppColors.surface,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 240),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (ctx, i) {
                      final r = options.elementAt(i);
                      final isProduct = r.type == LineItemType.product;
                      return InkWell(
                        onTap: () => onSelected(r),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isProduct
                                  ? AppColors.primary
                                      .withValues(alpha: 0.08)
                                  : const Color(0xFF0284C7)
                                      .withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(
                                  AppBorderRadius.xs),
                            ),
                            child: Text(
                              r.typeLabel,
                              style: AppTextStyles.caption.copyWith(
                                color: isProduct
                                    ? AppColors.primary
                                    : const Color(0xFF0284C7),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.name,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: FontWeight.w600)),
                                Text(r.code,
                                    style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Text(
                            '₹${r.price.toStringAsFixed(2)}',
                            style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          ),
          ),
        );
      },
      fieldViewBuilder:
          (context, controller, focusNode, onFieldSubmitted) {
        _fieldController = controller;
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          onFieldSubmitted: (String value) => onFieldSubmitted(),
          decoration: const InputDecoration(
            hintText: 'Search product or service by name / code...',
            prefixIcon: Icon(Icons.search_rounded,
                color: AppColors.textSecondary, size: 20),
          ),
        );
      },
      onSelected: (r) {
        // Build a pre-filled line item from the selected result
        final item = InvoiceLineItem(
          id: '${r.id}-${DateTime.now().millisecondsSinceEpoch}',
          itemType: r.type,
          itemId: r.id,
          code: r.code,
          name: r.name,
          qty: 1,
          rate: r.price,
          gstPercent: r.gst,
        );
        Future.delayed(Duration.zero, () {
          widget.onSelected(item);
          _fieldController?.clear();
        });
      },
    );
  }
}
