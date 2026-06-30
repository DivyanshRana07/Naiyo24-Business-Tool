import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class UseCaseDropdown extends StatefulWidget {
  const UseCaseDropdown({super.key});

  @override
  State<UseCaseDropdown> createState() => _UseCaseDropdownState();
}

class _UseCaseDropdownState extends State<UseCaseDropdown> {
  bool _isExpanded = false;
  final Set<String> _selectedItems = {};

  static const Map<String, List<String>> _categories = {
    'ACCOUNTING': [
      'End-to-end accounting',
      'Accounting services',
      'GST Compliance',
      'E-invoices & E-way Bills',
      'Only Invoicing & Billing',
      'Automate Invoicing (APIs/Shopify)',
    ],
    'INVENTORY MANAGEMENT': [
      'Manage stock',
      'Manage stock locations/warehouses',
      'Batch-wise tracking with expiry',
    ],
    'SALES CRM': [
      'End-to-end Sales Management',
      'Lead Generation Forms',
      'Automate Lead Capture (IndiaMART, Meta, etc.)',
    ],
  };

  void _toggleDropdown() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _toggleItem(String item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: _toggleDropdown,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: _isExpanded
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(AppBorderRadius.md),
                      topRight: Radius.circular(AppBorderRadius.md),
                    )
                  : BorderRadius.circular(AppBorderRadius.md),
              border: Border.all(
                color: _isExpanded ? AppColors.primary : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedItems.isEmpty
                      ? 'Select...'
                      : '${_selectedItems.length} selected',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _selectedItems.isEmpty
                        ? AppColors.textHint
                        : AppColors.textPrimary,
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppBorderRadius.md),
                bottomRight: Radius.circular(AppBorderRadius.md),
              ),
              border: Border(
                left: BorderSide(color: AppColors.primary),
                right: BorderSide(color: AppColors.primary),
                bottom: BorderSide(color: AppColors.primary),
              ),
            ),
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final categoryName = _categories.keys.elementAt(index);
                  final items = _categories[categoryName]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          categoryName,
                          style: AppTextStyles.labelLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      ...items.map((item) {
                        final isSelected = _selectedItems.contains(item);
                        return InkWell(
                          onTap: () => _toggleItem(item),
                          child: Container(
                            color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.transparent,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Icon(
                                  isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                                  color: isSelected ? AppColors.primary : AppColors.border,
                                  size: 20,
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
