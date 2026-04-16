import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/utils/currency_utils.dart';
import '../../../features/reports/domain/entity/detailed_report_entity.dart';
import '../../../features/reports/domain/entity/report_breakdown_point_entity.dart';
import '../../../features/reports/domain/entity/report_breakdown_type.dart';
import '../../../features/reports/domain/entity/report_period_type.dart';

class ReportChart extends StatefulWidget {
  const ReportChart({super.key, this.dataReport});

  final DetailedReportEntity? dataReport;

  @override
  State<ReportChart> createState() => _ReportChartState();
}

class _ReportChartState extends State<ReportChart> {
  static const double _yAxisUnit = 10000;

  late TooltipBehavior _tooltipBehavior;
  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      canShowMarker: true,
      header: '',
      color: AppColors.primary,
      textStyle: const TextStyle(
        color: AppColors.onPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
    );
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
      tooltipSettings: const InteractiveTooltip(
        color: AppColors.primary,
        textStyle: TextStyle(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.dataReport;
    if (report == null || report.breakdown.isEmpty) {
      return const SizedBox.shrink();
    }

    final chartData = report.breakdown
        .map(
          (point) => _ChartPoint(
            xLabel: _formatDisplayLabel(
              report.periodType,
              report.breakdownType,
              point,
            ),
            income: point.income,
            expense: point.expense,
            originalLabel: point.label,
          ),
        )
        .toList();

    final chartWidth = _calculateChartWidth(report, chartData.length);
    final maxY = _calculateMaxY(chartData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Text(
            'Unit: x10k',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondaryLight,
            ),
          ),
        ),
        SizedBox(
          width: chartWidth,
          height: 250,
          child: SfCartesianChart(
            margin: const EdgeInsets.fromLTRB(4, 12, 12, 0),
            plotAreaBorderWidth: 0,
            tooltipBehavior: _tooltipBehavior,
            trackballBehavior: _trackballBehavior,
            primaryXAxis: CategoryAxis(
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
              majorGridLines: const MajorGridLines(width: 0),
              labelStyle: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              labelRotation:
                  report.breakdownType == ReportBreakdownType.day &&
                      report.periodType == ReportPeriodType.month
                  ? 0
                  : 0,
              maximumLabels: chartData.length,
            ),
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: maxY,
              desiredIntervals: 4,
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
              majorGridLines: const MajorGridLines(
                width: 0.8,
                color: AppColors.borderLight,
              ),
              labelStyle: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondaryLight,
              ),
              axisLabelFormatter: (details) {
                final scaled = details.value / _yAxisUnit;
                return ChartAxisLabel(
                  _formatAxisValue(scaled),
                  AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                );
              },
            ),
            legend: Legend(
              isVisible: false,
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
              textStyle: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            series: <CartesianSeries<_ChartPoint, String>>[
              ColumnSeries<_ChartPoint, String>(
                name: 'Income',
                dataSource: chartData,
                xValueMapper: (point, _) => point.xLabel,
                yValueMapper: (point, _) => point.income,
                pointColorMapper: (_, __) => AppColors.income,
                width: 0.38,
                spacing: 0.2,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.md),
                ),
                enableTooltip: true,
                isVisibleInLegend: true,
              ),
              ColumnSeries<_ChartPoint, String>(
                name: 'Expense',
                dataSource: chartData,
                xValueMapper: (point, _) => point.xLabel,
                yValueMapper: (point, _) => point.expense,
                pointColorMapper: (_, __) => AppColors.expense,
                width: 0.38,
                spacing: 0.2,
                isVisibleInLegend: true,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.md),
                ),
                enableTooltip: true,
              ),
            ],
            onTooltipRender: (args) {
              final point = chartData[args.pointIndex?.toInt() ?? 0];
              final isIncome = args.seriesIndex == 0;
              final value = isIncome ? point.income : point.expense;
              args.text =
                  '${point.xLabel}\n${isIncome ? 'Income' : 'Expense'}: ${CurrencyUtils.format(value)}';
            },
          ),
        ),
      ],
    );
  }

  double _calculateChartWidth(DetailedReportEntity report, int pointCount) {
    switch (report.periodType) {
      case ReportPeriodType.week:
        return 340;
      case ReportPeriodType.month:
        if (report.breakdownType == ReportBreakdownType.day) {
          return pointCount * 44.0;
        }
        return pointCount * 68.0;
      case ReportPeriodType.year:
        return pointCount * 54.0;
    }
  }

  double _calculateMaxY(List<_ChartPoint> points) {
    final values = <double>[
      ...points.map((point) => point.income),
      ...points.map((point) => point.expense),
    ];

    final max = values.fold<double>(0, (current, value) {
      return value > current ? value : current;
    });

    if (max == 0) {
      return _yAxisUnit;
    }

    return max * 1.2;
  }

  String _formatAxisValue(double value) {
    if (value >= 100) {
      return value.toStringAsFixed(0);
    }
    if (value >= 10) {
      return value.toStringAsFixed(0);
    }
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }

  String _formatDisplayLabel(
    ReportPeriodType periodType,
    ReportBreakdownType breakdownType,
    ReportBreakdownPointEntity point,
  ) {
    if (periodType == ReportPeriodType.week &&
        breakdownType == ReportBreakdownType.day) {
      return DateFormat('E').format(point.startDate);
    }

    if (periodType == ReportPeriodType.month &&
        breakdownType == ReportBreakdownType.day) {
      return point.startDate.day.toString();
    }

    if (periodType == ReportPeriodType.month &&
        breakdownType == ReportBreakdownType.week) {
      return 'W${_weekOfMonth(point.startDate)}';
    }

    if (periodType == ReportPeriodType.year &&
        breakdownType == ReportBreakdownType.month) {
      return DateFormat('MMM').format(point.startDate);
    }

    return point.label;
  }

  int _weekOfMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    return ((date.day + firstDay.weekday - 2) / 7).floor() + 1;
  }
}

class _ChartPoint {
  const _ChartPoint({
    required this.xLabel,
    required this.income,
    required this.expense,
    required this.originalLabel,
  });

  final String xLabel;
  final double income;
  final double expense;
  final String originalLabel;
}

class _NoGlowScrollBehavior extends ScrollBehavior {
  const _NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
