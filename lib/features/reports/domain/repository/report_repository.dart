import 'package:expense_tracker/features/reports/domain/entity/detailed_report_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/monthly_report_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_types.dart';

abstract interface class ReportRepository {
  Future<MonthlyReportEntity> getMonthlySummary({
    required int year,
    required int month,
  });

  Future<DetailedReportEntity> getDetailedReport(DetailedReportParams params);
}
