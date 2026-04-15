import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/entity/transaction_type.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../routes/app_routes.dart';
import '../widget/category_list_item.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _filter = 0;

  static const _filters = ['All', 'Expense', 'Income'];

  static final _categories = [
    _CategoryData(
      name: 'Food & Dining',
      icon: LucideIcons.utensils,
      color: AppColors.emerald500,
      type: TransactionType.expense,
    ),
    _CategoryData(
      name: 'Transport',
      icon: LucideIcons.car,
      color: Color(0xFF3B82F6),
      type: TransactionType.expense,
    ),
    _CategoryData(
      name: 'Shopping',
      icon: LucideIcons.shoppingBag,
      color: Color(0xFF8B5CF6),
      type: TransactionType.expense,
    ),
    _CategoryData(
      name: 'Housing',
      icon: LucideIcons.house,
      color: Color(0xFFF59E0B),
      type: TransactionType.expense,
    ),
    _CategoryData(
      name: 'Entertainment',
      icon: LucideIcons.film,
      color: Color(0xFFEC4899),
      type: TransactionType.expense,
    ),
    _CategoryData(
      name: 'Utilities',
      icon: LucideIcons.zap,
      color: Color(0xFFF97316),
      type: TransactionType.expense,
    ),
    _CategoryData(
      name: 'Salary',
      icon: LucideIcons.banknote,
      color: AppColors.emerald500,
      type: TransactionType.income,
    ),
    _CategoryData(
      name: 'Freelance',
      icon: LucideIcons.briefcase,
      color: Color(0xFF14B8A6),
      type: TransactionType.income,
    ),
  ];

  List<_CategoryData> get _filtered {
    if (_filter == 0) return _categories;
    final type = _filter == 1 ? TransactionType.expense : TransactionType.income;
    return _categories.where((c) => c.type == type).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return AppScaffold(
      appBar: MoneyFlowAppBar(titleText: 'Categories'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('${AppRoutes.categories}/add'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        child: const Icon(LucideIcons.plus),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.sm,
            ),
            child: _FilterToggle(
              filters: _filters,
              selected: _filter,
              onSelected: (i) => setState(() => _filter = i),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.sm,
              ),
              itemCount: filtered.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, i) {
                final cat = filtered[i];
                return CategoryListItem(
                  name: cat.name,
                  icon: cat.icon,
                  color: cat.color,
                  type: cat.type,
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter Toggle
// ---------------------------------------------------------------------------

class _FilterToggle extends StatelessWidget {
  const _FilterToggle({
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<String> filters;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceVariantLight,
        borderRadius: AppRadius.radiusFull,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: List.generate(filters.length, (i) {
          final isSelected = selected == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: AppRadius.radiusFull,
                ),
                alignment: Alignment.center,
                child: Text(
                  filters[i],
                  style: AppTypography.labelMedium.copyWith(
                    color: isSelected
                        ? AppColors.onPrimary
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

class _CategoryData {
  const _CategoryData({
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  final String name;
  final IconData icon;
  final Color color;
  final TransactionType type;
}
