import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/core/utils/extensions.dart';
import 'package:expense_tracker/core/utils/icon_utils.dart';
import 'package:expense_tracker/features/reports/domain/entity/category_expense_summary_entity.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({super.key, required this.data});

  final CategoryExpenseSummaryEntity data;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            backgroundColor: Color(data.colorValue).withValues(alpha: 0.15),
            radius: AppIcons.listTile / 2,
            child: Icon(
              IconUtils.fromName(data.iconName),
              size: AppIcons.md,
              color: Color(data.colorValue),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.categoryName,
                  style: AppTypography.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '${data.type == TransactionType.income ? '+' : "-"}${context.formatMoney(data.totalAmount)}',
            style: AppTypography.amountSmall.copyWith(
              color: data.type == TransactionType.income
                  ? AppColors.income
                  : AppColors.expense,
              fontWeight: AppTypography.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
