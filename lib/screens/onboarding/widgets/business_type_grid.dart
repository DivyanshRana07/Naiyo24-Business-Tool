import 'package:flutter/material.dart';
import '../../../theme/theme.dart';

class BusinessTypeGrid extends StatefulWidget {
  const BusinessTypeGrid({super.key});

  @override
  State<BusinessTypeGrid> createState() => _BusinessTypeGridState();
}

class _BusinessTypeGridState extends State<BusinessTypeGrid> {
  String? _selectedType;

  static const List<Map<String, dynamic>> _types = [
    {
      'id': 'manufacturer',
      'title': 'Manufacturer',
      'subtitle': 'Produce & sell goods.',
      'icon': Icons.factory_outlined,
    },
    {
      'id': 'trading',
      'title': 'Trading',
      'subtitle': 'Buy & resell goods.',
      'icon': Icons.inventory_2_outlined,
    },
    {
      'id': 'retail',
      'title': 'Retail',
      'subtitle': 'Sell via physical stores.',
      'icon': Icons.storefront_outlined,
    },
    {
      'id': 'online',
      'title': 'Online',
      'subtitle': 'Online store or marketplace.',
      'icon': Icons.shopping_cart_outlined,
    },
    {
      'id': 'services',
      'title': 'Professional Services',
      'subtitle': 'Provide expertise & consulting.',
      'icon': Icons.work_outline,
    },
    {
      'id': 'contractor',
      'title': 'Contractor',
      'subtitle': 'End-to-end project delivery.',
      'icon': Icons.engineering_outlined,
    },
    {
      'id': 'software',
      'title': 'Software',
      'subtitle': 'Sell software or digital products.',
      'icon': Icons.computer_outlined,
    },
    {
      'id': 'other',
      'title': 'Something else',
      'subtitle': 'My business is different.',
      'icon': Icons.auto_awesome_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
        childAspectRatio: 2.8,
      ),
      itemCount: _types.length,
      itemBuilder: (context, index) {
        final type = _types[index];
        final isSelected = _selectedType == type['id'];

        return GestureDetector(
          onTap: () => setState(() => _selectedType = type['id'] as String),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  type['icon'] as IconData,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  size: 24,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        type['title'] as String,
                        style: AppTextStyles.labelMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        type['subtitle'] as String,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: isSelected ? 5 : 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
