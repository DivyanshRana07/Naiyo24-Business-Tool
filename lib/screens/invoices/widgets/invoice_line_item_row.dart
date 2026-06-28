import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/invoice_line_item.dart';
import '../../../theme/theme.dart';

/// An editable row in the invoice line items table.
/// Shows item name, type badge, qty, rate, discount%, gst%, total,
/// and a delete button.
class LineItemRow extends StatefulWidget {
  const LineItemRow({
    super.key,
    required this.item,
    required this.onChanged,
    required this.onDelete,
    required this.index,
  });

  final InvoiceLineItem item;
  final void Function(InvoiceLineItem updated) onChanged;
  final VoidCallback onDelete;
  final int index;

  @override
  State<LineItemRow> createState() => _LineItemRowState();
}

class _LineItemRowState extends State<LineItemRow> {
  late TextEditingController _qtyCtrl;
  late TextEditingController _rateCtrl;
  late TextEditingController _discCtrl;

  @override
  void initState() {
    super.initState();
    _qtyCtrl = TextEditingController(
        text: widget.item.qty.toStringAsFixed(
            widget.item.qty % 1 == 0 ? 0 : 2));
    _rateCtrl = TextEditingController(
        text: widget.item.rate.toStringAsFixed(2));
    _discCtrl = TextEditingController(
        text: widget.item.discountPercent.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _rateCtrl.dispose();
    _discCtrl.dispose();
    super.dispose();
  }

  void _emit() {
    final qty = double.tryParse(_qtyCtrl.text) ?? widget.item.qty;
    final rate = double.tryParse(_rateCtrl.text) ?? widget.item.rate;
    final disc = double.tryParse(_discCtrl.text) ?? widget.item.discountPercent;
    widget.onChanged(widget.item.copyWith(
      qty: qty,
      rate: rate,
      discountPercent: disc,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isProduct =
        widget.item.itemType == LineItemType.product;
    final total = widget.item.totalAmount;

    return Container(
      decoration: BoxDecoration(
        color: widget.index.isEven
            ? AppColors.surface
            : AppColors.background,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        child: Row(
          children: [
            // ── Type Badge ─────────────────────────────────────────────────
            SizedBox(
              width: 62,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: isProduct
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : const Color(0xFF0284C7).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppBorderRadius.xs),
                ),
                child: Text(
                  isProduct ? 'Product' : 'Service',
                  style: AppTextStyles.caption.copyWith(
                    color: isProduct
                        ? AppColors.primary
                        : const Color(0xFF0284C7),
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // ── Item Name + Code ───────────────────────────────────────────
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.name,
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis),
                  Text(widget.item.code,
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // ── Qty ────────────────────────────────────────────────────────
            SizedBox(
              width: 64,
              child: _NumField(
                controller: _qtyCtrl,
                onChanged: (_) => _emit(),
                label: 'Qty',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // ── Rate ───────────────────────────────────────────────────────
            SizedBox(
              width: 88,
              child: _NumField(
                controller: _rateCtrl,
                onChanged: (_) => _emit(),
                label: 'Rate ₹',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // ── Disc% ──────────────────────────────────────────────────────
            SizedBox(
              width: 60,
              child: _NumField(
                controller: _discCtrl,
                onChanged: (_) => _emit(),
                label: 'Disc%',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // ── GST% (read-only) ───────────────────────────────────────────
            SizedBox(
              width: 52,
              child: Text(
                '${widget.item.gstPercent.toStringAsFixed(0)}%',
                style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // ── Total ──────────────────────────────────────────────────────
            SizedBox(
              width: 88,
              child: Text(
                '₹${total.toStringAsFixed(2)}',
                style: AppTextStyles.bodyMedium
                    .copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // ── Delete ─────────────────────────────────────────────────────
            IconButton(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.delete_rounded,
                  color: AppColors.error, size: 18),
              tooltip: 'Remove item',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Inline numeric field ─────────────────────────────────────────────────────

class _NumField extends StatelessWidget {
  const _NumField({
    required this.controller,
    required this.onChanged,
    required this.label,
  });

  final TextEditingController controller;
  final void Function(String) onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      textAlign: TextAlign.center,
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
      ],
      style: AppTextStyles.bodyMedium
          .copyWith(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: AppTextStyles.caption
            .copyWith(color: AppColors.textHint),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        filled: true,
        fillColor: AppColors.surface,
      ),
    );
  }
}

// ─── Line items table header row ──────────────────────────────────────────────

class LineItemsHeader extends StatelessWidget {
  const LineItemsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 62),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            flex: 3,
            child: _hdr('ITEM NAME'),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(width: 64, child: _hdr('QTY', center: true)),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(width: 88, child: _hdr('RATE (₹)', center: true)),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(width: 60, child: _hdr('DISC%', center: true)),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(width: 52, child: _hdr('GST%', center: true)),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
              width: 88, child: _hdr('AMOUNT (₹)', center: true)),
          const SizedBox(width: AppSpacing.sm),
          const SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _hdr(String t, {bool center = false}) => Text(
        t,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 0.3,
        ),
        textAlign: center ? TextAlign.center : TextAlign.left,
      );
}

// ─── Invoice totals summary card ─────────────────────────────────────────────

class InvoiceTotalsCard extends StatelessWidget {
  const InvoiceTotalsCard({
    super.key,
    required this.subTotal,
    required this.totalDiscount,
    required this.totalGst,
    required this.roundOff,
    required this.grandTotal,
    required this.paidAmount,
    required this.paymentMethod,
    required this.onPaidAmountChanged,
    required this.onPaymentMethodChanged,
  });

  final double subTotal;
  final double totalDiscount;
  final double totalGst;
  final double roundOff;
  final double grandTotal;
  final double paidAmount;
  final String paymentMethod;
  final void Function(double) onPaidAmountChanged;
  final void Function(String) onPaymentMethodChanged;

  static const _paymentMethods = [
    'Cash', 'UPI', 'Bank Transfer', 'Cheque', 'Credit', 'Other'
  ];

  @override
  Widget build(BuildContext context) {
    final due = (grandTotal - paidAmount).clamp(0.0, double.infinity);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _row('Sub Total', '₹${subTotal.toStringAsFixed(2)}'),
          if (totalDiscount > 0)
            _row(
              'Discount',
              '- ₹${totalDiscount.toStringAsFixed(2)}',
              valueColor: AppColors.success,
            ),
          _row('GST', '₹${totalGst.toStringAsFixed(2)}'),
          if (roundOff != 0)
            _row(
              'Round Off',
              '${roundOff >= 0 ? '+' : ''}₹${roundOff.toStringAsFixed(2)}',
            ),
          const Divider(color: AppColors.border, height: AppSpacing.lg),
          _row(
            'Grand Total',
            '₹${grandTotal.toStringAsFixed(2)}',
            isBold: true,
            valueColor: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Payment Method dropdown ───────────────────────────────────
          DropdownButtonFormField<String>(
            initialValue: paymentMethod,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Payment Method',
              prefixIcon: Icon(Icons.payment_rounded, size: 18),
            ),
            items: _paymentMethods
                .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                .toList(),
            onChanged: (v) => onPaymentMethodChanged(v!),
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Paid Amount ───────────────────────────────────────────────
          TextFormField(
            initialValue: paidAmount > 0
                ? paidAmount.toStringAsFixed(2)
                : '',
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Paid Amount (₹)',
              prefixIcon:
                  Icon(Icons.currency_rupee_rounded, size: 18),
              hintText: '0.00',
            ),
            onChanged: (v) =>
                onPaidAmountChanged(double.tryParse(v) ?? 0),
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Due Amount ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: due > 0
                  ? AppColors.error.withValues(alpha: 0.06)
                  : AppColors.success.withValues(alpha: 0.06),
              borderRadius:
                  BorderRadius.circular(AppBorderRadius.md),
              border: Border.all(
                  color: due > 0 ? AppColors.error : AppColors.success,
                  width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Due Amount',
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontWeight: FontWeight.w600)),
                Text(
                  '₹${due.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: due > 0 ? AppColors.error : AppColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value,
      {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary)),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
