import 'package:expense_tracker/features/reports/domain/entity/report_breakdown_type.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_period_type.dart';

class DetailedReportParams {
  final ReportPeriodType periodType;
  final DateTime anchorDate;
  final ReportBreakdownType? breakdownType;

  const DetailedReportParams({
    required this.periodType,
    required this.anchorDate,
    this.breakdownType,
  });
}
