import 'package:expense_tracker/features/reports/domain/entity/monthly_report_entity.dart';

class ReportState {
  final bool isLoading;
  final MonthlyReportEntity? report;
  final String? errorMessage;
  final int year;
  final int month;

  const ReportState({
    required this.isLoading,
    required this.report,
    required this.errorMessage,
    required this.year,
    required this.month,
  });

  factory ReportState.initial() {
    final now = DateTime.now();

    return ReportState(
      isLoading: false,
      report: null,
      errorMessage: null,
      year: now.year,
      month: now.month,
    );
  }

  ReportState copyWith({
    bool? isLoading,
    MonthlyReportEntity? report,
    String? errorMessage,
    int? year,
    int? month,
    bool clearError = false,
  }) {
    return ReportState(
      isLoading: isLoading ?? this.isLoading,
      report: report ?? this.report,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      year: year ?? this.year,
      month: month ?? this.month,
    );
  }
}
