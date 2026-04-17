import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/constants/app_radius.dart';
import 'package:expense_tracker/core/constants/app_shadows.dart';
import 'package:expense_tracker/core/constants/app_spacing.dart';
import 'package:expense_tracker/core/constants/app_typography.dart';
import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/core/utils/currency_utils.dart';
import 'package:expense_tracker/core/utils/extensions.dart';
import 'package:expense_tracker/core/utils/icon_utils.dart';
import 'package:expense_tracker/features/reports/domain/entity/category_expense_summary_entity.dart';
import 'package:flutter/material.dart';

class CategoryBreakdownSection extends StatelessWidget {
  const CategoryBreakdownSection({
    super.key,
    required this.categories,
    required this.totalIncome,
    required this.totalExpense,
  });

  final List<CategoryExpenseSummaryEntity> categories;
  final double totalIncome;
  final double totalExpense;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Category Breakdown', style: AppTypography.titleMedium),
            TextButton(onPressed: () {}, child: const Text('Full Audit')),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.card,
            boxShadow: AppShadows.sm,
          ),
          child: Column(
            children: List.generate(categories.length, (i) {
              final cat = categories[i];
              return Column(
                children: [
                  _CategoryBreakdownRow(
                    category: cat,
                    totalIncome: totalIncome,
                    totalExpense: totalExpense,
                  ),
                  if (i < categories.length - 1)
                    Divider(
                      height: 1,
                      color: AppColors.borderLight,
                      indent: AppSpacing.xl3,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _CategoryBreakdownRow extends StatelessWidget {
  const _CategoryBreakdownRow({
    required this.category,
    required this.totalIncome,
    required this.totalExpense,
  });

  final CategoryExpenseSummaryEntity category;
  final double totalIncome;
  final double totalExpense;

  double _calculateProportion() {
    if (category.type == TransactionType.income) {
      // Proportion compared to totalExpense
      if (totalExpense == 0) return 0;
      return category.totalAmount / totalExpense;
    } else {
      // Proportion compared to totalIncome
      if (totalIncome == 0) return 0;
      return category.totalAmount / totalIncome;
    }
  }

  String _formatAsPercent(double value) {
    final percent = value * 100;
    return '${percent.toStringAsFixed(1)}%';
  }

  @override
  Widget build(BuildContext context) {
    final proportion = _calculateProportion().clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Color(category.colorValue).withValues(alpha: 0.18),
            child: Icon(
              IconUtils.fromName(category.iconName),
              size: 18,
              color: Color(category.colorValue),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.categoryName,
                      style: AppTypography.titleSmall,
                    ),
                    Text(
                      context.formatMoney(category.totalAmount),
                      style: AppTypography.amountSmall.copyWith(
                        fontSize: 13,
                        color: AppColors.textPrimaryLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                ClipRRect(
                  borderRadius: AppRadius.radiusFull,
                  child: LinearProgressIndicator(
                    value: proportion,
                    color: Color(category.colorValue),
                    backgroundColor: Color(
                      category.colorValue,
                    ).withValues(alpha: 0.15),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatAsPercent(proportion),
                      style: AppTypography.labelSmall,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: category.type == TransactionType.income
                            ? AppColors.primaryContainer
                            : AppColors.expenseLight,
                        borderRadius: AppRadius.radiusFull,
                      ),
                      child: Text(
                        category.type.name,
                        style: AppTypography.labelSmall.copyWith(
                          color: category.type == TransactionType.income
                              ? AppColors.income
                              : AppColors.expense,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
