import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/entity/transaction_type.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    this.onTap,
  });

  final String name;
  final IconData icon;
  final Color color;
  final TransactionType type;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isIncome = type == TransactionType.income;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: AppRadius.card,
          boxShadow: AppShadows.sm,
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              radius: AppIcons.listTile / 2,
              child: Icon(icon, size: AppIcons.md, color: color),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(name, style: AppTypography.titleMedium),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isIncome
                    ? AppColors.primaryContainer
                    : AppColors.expenseLight,
                borderRadius: AppRadius.radiusFull,
              ),
              child: Text(
                isIncome ? 'Income' : 'Expense',
                style: AppTypography.labelSmall.copyWith(
                  color: isIncome ? AppColors.income : AppColors.expense,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
