import 'package:expense_tracker/core/utils/extensions.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_breakdown_point_entity.dart';
import 'package:expense_tracker/presentation/home/cubit/home_cubit.dart';
import 'package:expense_tracker/presentation/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_shadows.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class HomeWeeklyChart extends StatefulWidget {
  const HomeWeeklyChart({super.key});

  @override
  State<HomeWeeklyChart> createState() => _HomeWeeklyChartState();
}

class _HomeWeeklyChartState extends State<HomeWeeklyChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: '',
      color: AppColors.primary,
      textStyle: const TextStyle(
        color: AppColors.onPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeCubit, HomeState, List<ReportBreakdownPointEntity>>(
      selector: (state) => state.weeklyReport?.breakdown ?? [],
      builder: (context, breakdown) {
        final chartData = breakdown
            .map(
              (point) => _HomeChartPoint(
                label: DateFormat('E').format(point.startDate),
                expense: point.expense,
              ),
            )
            .toList();
        final totalExpense = breakdown.fold<double>(
          0,
          (sum, point) => sum + point.expense,
        );

        return Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.surfaceLight,
            borderRadius: AppRadius.card,
            boxShadow: AppShadows.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Expense Summary', style: AppTypography.titleMedium),
                      const SizedBox(height: 2),
                      Text(
                        'Weekly outflow visualization',
                        style: AppTypography.labelSmall,
                      ),
                    ],
                  ),
                  Text(
                    context.formatMoney(totalExpense),
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.expense,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.base),
              SizedBox(
                height: 160,
                child: SfCartesianChart(
                  margin: EdgeInsets.zero,
                  plotAreaBorderWidth: 0,
                  tooltipBehavior: _tooltipBehavior,
                  primaryXAxis: CategoryAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    majorGridLines: const MajorGridLines(width: 0),
                    labelStyle: AppTypography.labelSmall.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  primaryYAxis: NumericAxis(
                    isVisible: false,
                    minimum: 0,
                  ),
                  series: <CartesianSeries<_HomeChartPoint, String>>[
                    SplineAreaSeries<_HomeChartPoint, String>(
                      dataSource: chartData,
                      xValueMapper: (point, _) => point.label,
                      yValueMapper: (point, _) => point.expense,
                      color: AppColors.expense.withValues(alpha: 0.18),
                      borderColor: AppColors.expense,
                      borderWidth: 3,
                      splineType: SplineType.natural,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.expense.withValues(alpha: 0.28),
                          AppColors.expense.withValues(alpha: 0.04),
                        ],
                      ),
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        width: 7,
                        height: 7,
                        shape: DataMarkerType.circle,
                        borderWidth: 2,
                        color: AppColors.surfaceLight,
                        borderColor: AppColors.expense,
                      ),
                      enableTooltip: true,
                    ),
                  ],
                  onTooltipRender: (args) {
                    final point = chartData[args.pointIndex?.toInt() ?? 0];
                    args.text =
                        '${point.label}\nExpense: ${context.formatMoney(point.expense)}';
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeChartPoint {
  const _HomeChartPoint({required this.label, required this.expense});

  final String label;
  final double expense;
}
