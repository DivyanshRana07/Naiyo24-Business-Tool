import 'package:flutter/material.dart';
import '../../../theme/theme.dart';
import '../../../widgets/custom_button.dart';

// ─── Use Case Dropdown ────────────────────────────────────────────────────────

class _UseCaseDropdown extends StatefulWidget {
  const _UseCaseDropdown();

  @override
  State<_UseCaseDropdown> createState() => _UseCaseDropdownState();
}

class _UseCaseDropdownState extends State<_UseCaseDropdown> {
  bool _open = false;
  final Set<String> _selected = {};

  static const _categories = [
    (
      name: 'ACCOUNTING',
      items: [
        'End-to-end accounting',
        'Accounting services',
        'GST Compliance',
        'E-invoices & E-way Bills',
        'Only Invoicing & Billing',
        'Automate Invoicing (APIs/Shopify)',
      ]
    ),
    (
      name: 'INVENTORY MANAGEMENT',
      items: [
        'Manage stock',
        'Manage stock locations/warehouses',
        'Batch-wise tracking with expiry',
      ]
    ),
    (
      name: 'SALES CRM',
      items: [
        'End-to-end Sales Management',
        'Lead Generation Forms',
        'Automate Lead Capture (IndiaMART, Meta, etc.)',
      ]
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Trigger button
        GestureDetector(
          onTap: () => setState(() => _open = !_open),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: _open ? AppColors.primary : AppColors.border,
              ),
              borderRadius: _open
                  ? const BorderRadius.vertical(top: Radius.circular(8))
                  : BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selected.isEmpty
                      ? 'Select...'
                      : '${_selected.length} selected',
                  style: TextStyle(
                    fontSize: 14,
                    color: _selected.isEmpty
                        ? AppColors.textHint
                        : AppColors.textPrimary,
                  ),
                ),
                Icon(
                  _open
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),

        // Dropdown panel — plain Column, no ListView, no scrollable
        if (_open)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                left: BorderSide(color: AppColors.primary),
                right: BorderSide(color: AppColors.primary),
                bottom: BorderSide(color: AppColors.primary),
              ),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(8)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final cat in _categories) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                    child: Text(
                      cat.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                      ),
                    ),
                  ),
                  for (final item in cat.items)
                    InkWell(
                      onTap: () => setState(() {
                        if (_selected.contains(item)) {
                          _selected.remove(item);
                        } else {
                          _selected.add(item);
                        }
                      }),
                      child: Container(
                        color: _selected.contains(item)
                            ? AppColors.primary.withValues(alpha: 0.06)
                            : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 11),
                        child: Row(
                          children: [
                            Icon(
                              _selected.contains(item)
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 18,
                              color: _selected.contains(item)
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: _selected.contains(item)
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

// ─── Business Type Cards ──────────────────────────────────────────────────────

class _BizType {
  final String id, title, subtitle;
  final IconData icon;
  const _BizType(this.id, this.title, this.subtitle, this.icon);
}

const _kBizTypes = [
  _BizType('manufacturer', 'Manufacturer', 'Produce & sell goods.',
      Icons.factory_outlined),
  _BizType(
      'trading', 'Trading', 'Buy & resell goods.', Icons.inventory_2_outlined),
  _BizType('retail', 'Retail', 'Sell via physical stores.',
      Icons.storefront_outlined),
  _BizType('online', 'Online', 'Online store or marketplace.',
      Icons.shopping_cart_outlined),
  _BizType('services', 'Professional Services', 'Provide expertise & consulting.',
      Icons.work_outline),
  _BizType('contractor', 'Contractor', 'End-to-end project delivery.',
      Icons.engineering_outlined),
  _BizType('software', 'Software', 'Sell software or digital products.',
      Icons.computer_outlined),
  _BizType('other', 'Something else', 'My business is different.',
      Icons.auto_awesome_outlined),
];

class _BusinessTypeCards extends StatefulWidget {
  const _BusinessTypeCards();

  @override
  State<_BusinessTypeCards> createState() => _BusinessTypeCardsState();
}

class _BusinessTypeCardsState extends State<_BusinessTypeCards> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder to get actual available width and make 2 cards per row
    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 12.0;
        final cardWidth = (constraints.maxWidth - gap) / 2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final t in _kBizTypes)
              GestureDetector(
                onTap: () => setState(() => _selected = t.id),
                child: SizedBox(
                  width: cardWidth,
                  height: 66,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: _selected == t.id
                          ? AppColors.primary.withValues(alpha: 0.05)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _selected == t.id
                            ? AppColors.primary
                            : AppColors.border,
                        width: _selected == t.id ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          t.icon,
                          size: 22,
                          color: _selected == t.id
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                t.title,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                t.subtitle,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Radio dot
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selected == t.id
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: _selected == t.id ? 5 : 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ─── StepTwoForm ─────────────────────────────────────────────────────────────

class StepTwoForm extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onFinish;

  const StepTwoForm({
    super.key,
    required this.onBack,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── 1. Use Case ────────────────────────────────────────────────────
        const Text(
          '1. What do you want to use Naiyo Business Tool for?*',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Help us serve you better!',
          style: TextStyle(fontSize: 12, color: AppColors.primary),
        ),
        const SizedBox(height: 10),
        const _UseCaseDropdown(),

        const SizedBox(height: 24),

        // ── 2. Business Type ───────────────────────────────────────────────
        const Text(
          '2. What best describes your business?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Choose the category that matches how your business operates to get a personalized onboarding experience.',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 12),
        const _BusinessTypeCards(),

        const SizedBox(height: 28),

        // ── Buttons ────────────────────────────────────────────────────────
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back, size: 16),
              label: const Text('Back'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: AppColors.border),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                label: 'Finish Setup',
                onPressed: onFinish,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
