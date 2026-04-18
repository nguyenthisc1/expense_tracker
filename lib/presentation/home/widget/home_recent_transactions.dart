import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/core/utils/extensions.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';
import 'package:expense_tracker/presentation/home/cubit/home_cubit.dart';
import 'package:expense_tracker/presentation/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class HomeRecentTransactions extends StatelessWidget {
  const HomeRecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, List<TransactionEntity>>(
      selector: (state) => state.recentTransactions,
      builder: (context, transactions) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Transactions', style: AppTypography.titleMedium),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ...List.generate(transactions.length, (index) {
              final transaction = transactions[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < transactions.length - 1 ? AppSpacing.sm : 0,
                ),
                child: _RecentTransactionTile(data: transaction),
              );
            }),
          ],
        );
      },
    );
  }
}

class _RecentTransactionTile extends StatelessWidget {
  const _RecentTransactionTile({required this.data});

  final TransactionEntity data;

  @override
  Widget build(BuildContext context) {
    final isIncome = data.type == TransactionType.income;
    final accentColor = isIncome ? AppColors.income : AppColors.expense;

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
            backgroundColor: accentColor.withValues(alpha: 0.15),
            child: Icon(
              isIncome ? LucideIcons.arrowDownLeft : LucideIcons.arrowUpRight,
              color: accentColor,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  DateFormat('dd MMM, HH:mm').format(data.date),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            '${isIncome ? '+' : '-'}${context.formatMoney(data.amount)}',
            style: AppTypography.amountSmall.copyWith(
              color: accentColor,
              fontWeight: AppTypography.semiBold,
            ),
          ),
        ],
      ),
    );
  }
}
