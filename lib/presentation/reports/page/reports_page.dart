import 'package:expense_tracker/core/utils/currency_utils.dart';
import 'package:expense_tracker/core/utils/extensions.dart';
import 'package:expense_tracker/core/widgets/error_view.dart';
import 'package:expense_tracker/core/widgets/loading_indicator.dart';
import 'package:expense_tracker/features/reports/domain/entity/detailed_report_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_period_type.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_types.dart';
import 'package:expense_tracker/presentation/reports/cubit/report_cubit.dart';
import 'package:expense_tracker/presentation/reports/cubit/report_state.dart';
import 'package:expense_tracker/presentation/reports/widget/category_breadkdown_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../widget/report_chart.dart';
import '../widget/report_summary_card.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: MoneyFlowAppBar(titleText: 'Reports'),
      body: BlocConsumer<ReportCubit, ReportState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            context.showSnackBar(state.errorMessage!, isError: true);
          }
        },

        builder: (context, state) {
          if (state.isLoading || state.report == null) {
            return const LoadingIndicator(message: 'Loading Infomation...');
          }

          if (state.errorMessage != null && state.report == null) {
            return ErrorView(
              message: state.errorMessage,
              // onRetry: _reloadTransactions,
            );
          }

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.base,
            ),
            children: [
              _ChartToggle(),
              const SizedBox(height: AppSpacing.base),

              ReportSummaryCard(
                totalLabel: 'Total Spent This ${state.periodType.name}',
                totalAmount: context.formatMoney(
                  (state.report?.totalIncome ?? 0) -
                      (state.report?.totalExpense ?? 0),
                ),
                percentageChange: (() {
                  final totalIncome = state.report?.totalIncome ?? 0;
                  final totalExpense = state.report?.totalExpense ?? 0;
                  final sum = totalIncome + totalExpense;
                  if (sum == 0) {
                    return '0%';
                  }
                  final percent = ((totalIncome - totalExpense) / sum) * 100;
                  return '${percent.toStringAsFixed(1)}%';
                })(),
                isPositive: (() {
                  final totalIncome = state.report?.totalIncome ?? 0;
                  final totalExpense = state.report?.totalExpense ?? 0;
                  return totalIncome > totalExpense;
                })(),
              ),
              const SizedBox(height: AppSpacing.base),
              _SpendingFlowSection(
                // onToggle: (v) => setState(() => _showIncome = v),
                dataReport: state.report,
              ),
              const SizedBox(height: AppSpacing.base),
              _SmartInsightCard(),
              const SizedBox(height: AppSpacing.base),
              CategoryBreakdownSection(
                categories: state.report?.expenseByCategory ?? [],
                totalIncome: state.report?.totalIncome ?? 0,
                totalExpense: state.report?.totalExpense ?? 0,
              ),
              const SizedBox(height: AppSpacing.xl2),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Spending Flow Section
// ---------------------------------------------------------------------------

class _SpendingFlowSection extends StatelessWidget {
  const _SpendingFlowSection({
    // required this.onToggle,
    required this.dataReport,
  });

  final DetailedReportEntity? dataReport;
  // final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('Spending Flow', style: AppTypography.titleMedium)],
          ),
          const SizedBox(height: AppSpacing.base),
          ReportChart(dataReport: dataReport),
        ],
      ),
    );
  }
}

class _ChartToggle extends StatelessWidget {
  const _ChartToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        final period = state.periodType;
        final anchorDate = state.date;
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceVariantLight,
            borderRadius: AppRadius.radiusFull,
          ),
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ToggleChip(
                label: 'Week',
                isSelected: period == ReportPeriodType.week,
                onTap: () => context.read<ReportCubit>().loadDetailedReport(
                  DetailedReportParams(
                    anchorDate: anchorDate,
                    periodType: ReportPeriodType.week,
                  ),
                ),
              ),
              _ToggleChip(
                label: 'Month',
                isSelected: period == ReportPeriodType.month,
                onTap: () => context.read<ReportCubit>().loadDetailedReport(
                  DetailedReportParams(
                    anchorDate: anchorDate,
                    periodType: ReportPeriodType.month,
                  ),
                ),
              ),
              _ToggleChip(
                label: 'Year',
                isSelected: period == ReportPeriodType.year,
                onTap: () => context.read<ReportCubit>().loadDetailedReport(
                  DetailedReportParams(
                    anchorDate: anchorDate,
                    periodType: ReportPeriodType.year,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: AppRadius.radiusFull,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Smart Insight Card
// ---------------------------------------------------------------------------

class _SmartInsightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer,
        borderRadius: AppRadius.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.sparkles,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                'Smart Insight',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your housing costs are 5% lower than last month. Keep up the good work!',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: AppColors.primary,
            ),
            child: const Text('View Advice'),
          ),
        ],
      ),
    );
  }
}
