import 'package:expense_tracker/core/utils/extensions.dart';
import 'package:expense_tracker/presentation/home/cubit/home_cubit.dart';
import 'package:expense_tracker/presentation/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class HomeBalanceCard extends StatelessWidget {
  const HomeBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, double>(
      selector: (state) => state.totalBalance,
      builder: (context, balance) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppRadius.card,
            boxShadow: AppShadows.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Balance',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.formatMoney(balance),
                style: AppTypography.displayLarge,
              ),
              const SizedBox(height: AppSpacing.base),
              Row(
                children: const [
                  _BalanceActionButton(
                    icon: LucideIcons.send,
                    label: 'Send',
                  ),
                  SizedBox(width: AppSpacing.md),
                  _BalanceActionButton(
                    icon: LucideIcons.download,
                    label: 'Deposit',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BalanceActionButton extends StatelessWidget {
  const _BalanceActionButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.radiusFull),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
      ),
    );
  }
}
