class ReportBreakdownPointEntity {
  final String label;
  final DateTime startDate;
  final DateTime endDate;
  final double income;
  final double expense;
  final double balance;

  const ReportBreakdownPointEntity({
    required this.label,
    required this.startDate,
    required this.endDate,
    required this.income,
    required this.expense,
    required this.balance,
  });
}

