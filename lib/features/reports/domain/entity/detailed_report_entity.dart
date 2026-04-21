import 'package:expense_tracker/features/reports/domain/entity/category_expense_summary_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_breakdown_point_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_breakdown_type.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_period_type.dart';

class DetailedReportEntity {
  final ReportPeriodType periodType;
  final ReportBreakdownType breakdownType;
  final DateTime startDate;
  final DateTime endDate;

  final double totalIncome;
  final double totalExpense;
  final double balance;

  final List<ReportBreakdownPointEntity> breakdown;
  final List<CategoryExpenseSummaryEntity> expenseByCategory;

  const DetailedReportEntity({
    required this.periodType,
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.breakdown,
    required this.expenseByCategory,
    required this.breakdownType,
  });
}
