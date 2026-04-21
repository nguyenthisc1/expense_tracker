import 'package:expense_tracker/features/reports/domain/entity/detailed_report_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/monthly_report_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_period_type.dart';

class ReportState {
  final bool isLoading;
  final MonthlyReportEntity? monthlyReport;
  final String? errorMessage;
  final int year;
  final int month;
  final DateTime date;
  final ReportPeriodType periodType;
  final DetailedReportEntity? report;

  const ReportState({
    required this.isLoading,
    required this.monthlyReport,
    required this.errorMessage,
    required this.year,
    required this.month,
    required this.date,
    this.periodType = ReportPeriodType.month,
    required this.report,
  });

  factory ReportState.initial() {
    final now = DateTime.now();

    return ReportState(
      isLoading: false,
      monthlyReport: null,
      errorMessage: null,
      year: now.year,
      month: now.month,
      date: now,
      report: null,
    );
  }

  ReportState copyWith({
    bool? isLoading,
    MonthlyReportEntity? monthlyReport,
    String? errorMessage,
    int? year,
    int? month,
    bool clearError = false,
    ReportPeriodType? periodType,
    DateTime? date,
    DetailedReportEntity? report,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      monthlyReport: monthlyReport ?? this.monthlyReport,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      year: year ?? this.year,
      month: month ?? this.month,
      periodType: periodType ?? this.periodType,
      date: date ?? this.date,
      report: report ?? this.report,
    );
  }
}
