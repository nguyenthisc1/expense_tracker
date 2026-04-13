class MonthlyReportEntity {
  final int year;
  final int month;
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final List<CategoryExpenseSummary> expenseByCategory;

  MonthlyReportEntity({
    required this.year,
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.expenseByCategory,
  });
}

class CategoryExpenseSummary {
  final String categoryId;
  final String categoryName;
  final double totalAmount;

  CategoryExpenseSummary({
    required this.categoryId,
    required this.categoryName,
    required this.totalAmount,
  });
}
