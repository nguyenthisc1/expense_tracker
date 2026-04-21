import 'package:expense_tracker/features/reports/domain/entity/detailed_report_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_period_type.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';

class HomeState {
  final bool isLoading;
  final DetailedReportEntity? weeklyReport;
  final List<TransactionEntity> recentTransactions;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final String? errorMessage;
  final DateTime date;
  final ReportPeriodType periodType;

  const HomeState({
    required this.isLoading,
    this.weeklyReport,
    required this.recentTransactions,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
    this.errorMessage,
    this.periodType = ReportPeriodType.week,
    required this.date,
  });

  factory HomeState.initial() {
    final now = DateTime.now();

    return HomeState(
      isLoading: false,
      errorMessage: null,
      date: now,
      weeklyReport: null,
      recentTransactions: const [],
      totalBalance: 0,
      totalIncome: 0,
      totalExpense: 0,
    );
  }

  HomeState copyWith({
    bool? isLoading,
    DetailedReportEntity? weeklyReport,
    List<TransactionEntity>? recentTransactions,
    double? totalBalance,
    double? totalIncome,
    double? totalExpense,
    String? errorMessage,
    bool clearError = false,
    DateTime? date,
    ReportPeriodType? periodType,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      totalBalance: totalBalance ?? this.totalBalance,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      date: date ?? this.date,
      periodType: periodType ?? this.periodType,
    );
  }
}
