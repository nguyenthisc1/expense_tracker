import 'package:expense_tracker/features/reports/domain/entity/category_expense_summary_entity.dart';

class MonthlyReportEntity {
  final int year;
  final int month;
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<CategoryExpenseSummaryEntity> expenseByCategory;

  const MonthlyReportEntity({
    required this.year,
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.expenseByCategory,
  });
}
