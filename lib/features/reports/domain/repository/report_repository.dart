import 'package:expense_tracker/features/reports/domain/entity/monthly_report_entity.dart';

abstract interface class ReportRepository {
  Future<MonthlyReportEntity> getMonthlySummary({
    required int year,
    required int month,
  });
}
