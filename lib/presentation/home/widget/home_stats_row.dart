import 'package:expense_tracker/core/utils/extensions.dart';
import 'package:expense_tracker/presentation/home/cubit/home_cubit.dart';
import 'package:expense_tracker/presentation/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class HomeStatsRow extends StatelessWidget {
  const HomeStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      HomeCubit,
      HomeState,
      ({double income, double expense})
    >(
      selector: (state) => (
        income: state.totalIncome,
        expense: state.totalExpense,
      ),
      builder: (context, data) {
        return Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: LucideIcons.arrowDown,
                label: 'Income',
                amount: context.formatMoney(data.income),
                iconColor: AppColors.income,
                backgroundColor: AppColors.primaryContainer,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _StatCard(
                icon: LucideIcons.arrowUp,
                label: 'Expenses',
                amount: context.formatMoney(data.expense),
                iconColor: AppColors.expense,
                backgroundColor: AppColors.expenseLight,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.amount,
    required this.iconColor,
    required this.backgroundColor,
  });

  final IconData icon;
  final String label;
  final String amount;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: AppTypography.labelSmall.copyWith(color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            amount,
            style: AppTypography.amountSmall.copyWith(color: iconColor),
          ),
        ],
      ),
    );
  }
}
