import 'package:expense_tracker/core/di/injection.dart';
import 'package:expense_tracker/core/utils/currency_utils.dart';
import 'package:expense_tracker/core/utils/extensions.dart';
import 'package:expense_tracker/core/widgets/error_view.dart';
import 'package:expense_tracker/core/widgets/loading_indicator.dart';
import 'package:expense_tracker/features/categories/domain/entity/category_entity.dart';
import 'package:expense_tracker/features/categories/domain/usecase/get_categories_usecase.dart';
import 'package:expense_tracker/features/reports/domain/entity/detailed_report_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_period_type.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_types.dart';
import 'package:expense_tracker/presentation/reports/cubit/report_cubit.dart';
import 'package:expense_tracker/presentation/reports/cubit/report_state.dart';
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
  bool _showIncome = false;
  List<CategoryEntity> _categories = const [];
  bool _isLoadingCategories = true;
  String? _categoryError;

  // static final _categories = [
  //   _CategoryBreakdown(
  //     icon: LucideIcons.house,
  //     name: 'Housing',
  //     amount: '\$1,712.00',
  //     percentage: 0.40,
  //     percentLabel: '40%',
  //     color: Color(0xFFF59E0B),
  //     status: 'ON TRACK',
  //     onTrack: true,
  //   ),
  //   _CategoryBreakdown(
  //     icon: LucideIcons.utensils,
  //     name: 'Food & Dining',
  //     amount: '\$856.10',
  //     percentage: 0.20,
  //     percentLabel: '20%',
  //     color: AppColors.emerald500,
  //     status: 'OVER LIMIT',
  //     onTrack: false,
  //   ),
  //   _CategoryBreakdown(
  //     icon: LucideIcons.car,
  //     name: 'Transport',
  //     amount: '\$428.05',
  //     percentage: 0.10,
  //     percentLabel: '10%',
  //     color: Color(0xFF3B82F6),
  //     status: 'ON TRACK',
  //     onTrack: true,
  //   ),
  //   _CategoryBreakdown(
  //     icon: LucideIcons.film,
  //     name: 'Entertainment',
  //     amount: '\$642.08',
  //     percentage: 0.15,
  //     percentLabel: '15%',
  //     color: Color(0xFFEC4899),
  //     status: 'ON TRACK',
  //     onTrack: true,
  //   ),
  // ];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
      _categoryError = null;
    });

    try {
      final categories = await sl<GetCategoriesUsecase>()();
      if (!mounted) return;
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _categoryError = error.toString();
        _isLoadingCategories = false;
      });
    }
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
                totalAmount: CurrencyUtils.format(
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
                showIncome: _showIncome,
                onToggle: (v) => setState(() => _showIncome = v),
                dataReport: state.report,
              ),
              const SizedBox(height: AppSpacing.base),
              // _SmartInsightCard(),
              const SizedBox(height: AppSpacing.base),
              // _CategoryBreakdownSection(categories: _categories),
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
    required this.showIncome,
    required this.onToggle,
    required this.dataReport,
  });

  final DetailedReportEntity? dataReport;
  final bool showIncome;
  final ValueChanged<bool> onToggle;

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

// ---------------------------------------------------------------------------
// Category Breakdown
// ---------------------------------------------------------------------------

class _CategoryBreakdownSection extends StatelessWidget {
  const _CategoryBreakdownSection({required this.categories});

  final List<_CategoryBreakdown> categories;

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
                  _CategoryBreakdownRow(category: cat),
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
  const _CategoryBreakdownRow({required this.category});

  final _CategoryBreakdown category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: category.color.withValues(alpha: 0.15),
            child: Icon(category.icon, size: 18, color: category.color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(category.name, style: AppTypography.titleSmall),
                    Text(
                      category.amount,
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
                    value: category.percentage,
                    color: category.color,
                    backgroundColor: category.color.withValues(alpha: 0.15),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.percentLabel,
                      style: AppTypography.labelSmall,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: category.onTrack
                            ? AppColors.primaryContainer
                            : AppColors.expenseLight,
                        borderRadius: AppRadius.radiusFull,
                      ),
                      child: Text(
                        category.status,
                        style: AppTypography.labelSmall.copyWith(
                          color: category.onTrack
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

// ---------------------------------------------------------------------------
// Data model
// ---------------------------------------------------------------------------

class _CategoryBreakdown {
  const _CategoryBreakdown({
    required this.icon,
    required this.name,
    required this.amount,
    required this.percentage,
    required this.percentLabel,
    required this.color,
    required this.status,
    required this.onTrack,
  });

  final IconData icon;
  final String name;
  final String amount;
  final double percentage;
  final String percentLabel;
  final Color color;
  final String status;
  final bool onTrack;
}
