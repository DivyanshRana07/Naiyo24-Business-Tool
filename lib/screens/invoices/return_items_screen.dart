import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/invoice_line_item.dart';
import '../../models/invoice_model.dart';
import '../../notifiers/auth_notifier.dart';
import '../../notifiers/invoice_notifier.dart';
import '../../notifiers/product_notifier.dart';

import '../../theme/theme.dart';
import '../../widgets/dashboard_app_bar.dart';

/// Screen to process a return / credit note against a specific invoice.
class ReturnItemsScreen extends ConsumerStatefulWidget {
  const ReturnItemsScreen({super.key, required this.invoiceId});

  final String invoiceId;

  @override
  ConsumerState<ReturnItemsScreen> createState() => _ReturnItemsScreenState();
}

class _ReturnItemsScreenState extends ConsumerState<ReturnItemsScreen> {
  late InvoiceModel _invoice;
  bool _isLoaded = false;
  final Map<String, double> _returnQtys = {}; // itemId -> return qty
  final _reasonCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final inv = ref.read(invoiceNotifierProvider.notifier).findById(widget.invoiceId);
      if (inv != null) {
        setState(() {
          _invoice = inv;
          _isLoaded = true;
          for (final item in inv.lineItems) {
            _returnQtys[item.id] = 0.0;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  double get _totalRefundAmount {
    if (!_isLoaded) return 0;
    double total = 0;
    for (final item in _invoice.lineItems) {
      final retQty = _returnQtys[item.id] ?? 0;
      if (retQty > 0) {
        // Calculate item amount for the returned qty
        final discAmt = (item.rate * retQty) * (item.discountPercent / 100);
        final baseAmt = (item.rate * retQty) - discAmt;
        final gstAmt = baseAmt * (item.gstPercent / 100);
        total += baseAmt + gstAmt;
      }
    }
    return total;
  }

  bool get _hasReturns => _returnQtys.values.any((q) => q > 0);

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: DashboardAppBar(email: ref.read(authNotifierProvider).userEmail),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DashboardAppBar(email: ref.read(authNotifierProvider).userEmail),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: AppSpacing.xl),
                _buildInfoCard(),
                const SizedBox(height: AppSpacing.xl),
                _buildItemsTable(),
                const SizedBox(height: AppSpacing.xl),
                _buildFooterActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
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
            child: const Icon(Icons.arrow_back_rounded,
                size: 20, color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const Icon(Icons.assignment_return_rounded,
            color: AppColors.warning, size: 28),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Process Return', style: AppTextStyles.h1),
            Text('For ${_invoice.invoiceNo}',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textSecondary)),
                Text(_invoice.customerName,
                    style: AppTextStyles.h2),
              ],
            ),
          ),
          Expanded(
            child: TextField(
              controller: _reasonCtrl,
              decoration: InputDecoration(
                labelText: 'Reason for Return (Optional)',
                hintText: 'e.g., Damaged, Expired...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTable() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            color: AppColors.surfaceVariant,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Text('ITEM NAME',
                        style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary))),
                Expanded(
                    flex: 1,
                    child: Text('BILLED QTY',
                        style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary),
                        textAlign: TextAlign.center)),
                Expanded(
                    flex: 1,
                    child: Text('RETURN QTY',
                        style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.warning),
                        textAlign: TextAlign.center)),
              ],
            ),
          ),
          ..._invoice.lineItems.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg, vertical: AppSpacing.md),
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.border, width: 0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(item.name,
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontWeight: FontWeight.w600)),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      item.qty.toStringAsFixed(item.qty % 1 == 0 ? 0 : 2),
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      initialValue: '0',
                      textAlign: TextAlign.center,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppBorderRadius.sm),
                        ),
                      ),
                      onChanged: (v) {
                        final parsed = double.tryParse(v) ?? 0;
                        setState(() {
                          _returnQtys[item.id] = parsed.clamp(0, item.qty);
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFooterActions() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Refund Amount',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary)),
              Text('₹${_totalRefundAmount.toStringAsFixed(2)}',
                  style: AppTextStyles.h2.copyWith(color: AppColors.error)),
            ],
          ),
          FilledButton.icon(
            onPressed: _hasReturns ? _processReturn : null,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.warning,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl, vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.md)),
            ),
            icon: const Icon(Icons.assignment_return_rounded,
                size: 20, color: Colors.white),
            label: Text('Process Return',
                style: AppTextStyles.labelLarge
                    .copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _processReturn() {
    // 1. Rebuild line items with reduced quantities
    final List<InvoiceLineItem> updatedItems = [];
    for (final item in _invoice.lineItems) {
      final retQty = _returnQtys[item.id] ?? 0;
      if (retQty < item.qty) {
        updatedItems.add(item.copyWith(qty: item.qty - retQty));
      }
      
      // 2. Restore stock for products returned
      if (retQty > 0 && item.itemType == LineItemType.product) {
        ref
            .read(productNotifierProvider.notifier)
            .restoreStock(item.itemId, retQty.toInt());
      }
    }

    // 3. Update the invoice
    // Keep notes about the return
    final reason = _reasonCtrl.text.trim();
    final note = 'Return processed. Refund: ₹${_totalRefundAmount.toStringAsFixed(2)}'
        '${reason.isNotEmpty ? " Reason: $reason" : ""}';
    final existingNotes = _invoice.notes ?? '';
    final updatedNotes = existingNotes.isEmpty ? note : '$existingNotes\n$note';

    final updatedInvoice = _invoice.copyWith(
      lineItems: updatedItems,
      notes: updatedNotes,
    );

    ref.read(invoiceNotifierProvider.notifier).updateInvoice(updatedInvoice);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Return processed for ${_invoice.invoiceNo}. Stock restored.'),
        backgroundColor: AppColors.success,
      ),
    );

    context.pop();
  }
}
