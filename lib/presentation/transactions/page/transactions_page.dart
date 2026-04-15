import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../routes/app_routes.dart';
import '../widget/transaction_list_item.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  int _selectedFilter = 0;

  static const _filters = ['All', 'Income', 'Expenses', 'Category'];

  static final _groups = [
    _DateGroup(
      date: 'Today',
      dateLabel: 'Oct 24, 2023',
      items: [
        _TxData(
          title: 'Whole Foods Market',
          subtitle: 'Groceries • 10:24 AM',
          icon: LucideIcons.shoppingBag,
          iconColor: AppColors.slate600,
          amount: '\$84.20',
          isIncome: false,
        ),
        _TxData(
          title: 'Netflix Subscription',
          subtitle: 'Entertainment • 08:00 AM',
          icon: LucideIcons.tv,
          iconColor: Color(0xFFE50914),
          amount: '\$15.99',
          isIncome: false,
        ),
        _TxData(
          title: 'Salary Deposit',
          subtitle: 'Income • 06:15 AM',
          icon: LucideIcons.banknote,
          iconColor: AppColors.income,
          amount: '\$4,250.00',
          isIncome: true,
        ),
      ],
    ),
    _DateGroup(
      date: 'Yesterday',
      dateLabel: 'Oct 23, 2023',
      items: [
        _TxData(
          title: 'Uber Trip',
          subtitle: 'Transport • 09:45 PM',
          icon: LucideIcons.car,
          iconColor: Color(0xFF1C1E22),
          amount: '\$24.50',
          isIncome: false,
        ),
        _TxData(
          title: 'The Green Bistro',
          subtitle: 'Dining • 07:30 PM',
          icon: LucideIcons.utensils,
          iconColor: AppColors.emerald500,
          amount: '\$112.00',
          isIncome: false,
        ),
        _TxData(
          title: 'Utility Bill',
          subtitle: 'Housing • 11:20 AM',
          icon: LucideIcons.zap,
          iconColor: Color(0xFFF59E0B),
          amount: '\$89.15',
          isIncome: false,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: MoneyFlowAppBar(
        titleText: 'History',
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.search),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addTransaction),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        child: const Icon(LucideIcons.plus),
      ),
      body: Column(
        children: [
          _FilterRow(
            filters: _filters,
            selected: _selectedFilter,
            onSelected: (i) => setState(() => _selectedFilter = i),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.base,
              ),
              itemCount: _groups.length,
              itemBuilder: (context, groupIndex) {
                final group = _groups[groupIndex];
                return _TransactionGroup(group: group);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter Row
// ---------------------------------------------------------------------------

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<String> filters;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, i) {
          final isSelected = selected == i;
          final isLast = i == filters.length - 1;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                borderRadius: AppRadius.radiusFull,
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filters[i],
                    style: AppTypography.labelMedium.copyWith(
                      color: isSelected
                          ? AppColors.onPrimary
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  if (isLast) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      LucideIcons.chevronDown,
                      size: 14,
                      color: isSelected
                          ? AppColors.onPrimary
                          : AppColors.textSecondaryLight,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Transaction Group
// ---------------------------------------------------------------------------

class _TransactionGroup extends StatelessWidget {
  const _TransactionGroup({required this.group});

  final _DateGroup group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.base,
            bottom: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Text(group.date, style: AppTypography.headlineSmall),
              const SizedBox(width: AppSpacing.sm),
              Text(group.dateLabel, style: AppTypography.labelSmall),
            ],
          ),
        ),
        ...List.generate(group.items.length, (i) {
          final item = group.items[i];
          return Padding(
            padding: EdgeInsets.only(
              bottom: i < group.items.length - 1 ? AppSpacing.sm : 0,
            ),
            child: TransactionListItem(
              title: item.title,
              subtitle: item.subtitle,
              icon: item.icon,
              iconColor: item.iconColor,
              amount: item.amount,
              isIncome: item.isIncome,
            ),
          );
        }),
        const SizedBox(height: AppSpacing.base),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Data models
// ---------------------------------------------------------------------------

class _DateGroup {
  const _DateGroup({
    required this.date,
    required this.dateLabel,
    required this.items,
  });

  final String date;
  final String dateLabel;
  final List<_TxData> items;
}

class _TxData {
  const _TxData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.amount,
    required this.isIncome,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String amount;
  final bool isIncome;
}
