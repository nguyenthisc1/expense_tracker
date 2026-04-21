import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_types.dart';
import 'package:expense_tracker/features/reports/domain/usecase/get_detailed_report_usecase.dart';
import 'package:expense_tracker/features/transactions/domain/usecase/get_transactions_usecase.dart';
import 'package:expense_tracker/presentation/home/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetDetailedReportUsecase _getDetailedReportUsecase;
  final GetTransactionsUsecase _getTransactionsUsecase;

  HomeCubit({
    required GetDetailedReportUsecase getDetailedReportUsecase,
    required GetTransactionsUsecase getTransactionsUsecase,
  })
    : _getDetailedReportUsecase = getDetailedReportUsecase,
      _getTransactionsUsecase = getTransactionsUsecase,
      super(HomeState.initial());

  Future<void> loadHomeDashboard() async {
    final params = DetailedReportParams(
      anchorDate: state.date,
      periodType: state.periodType,
    );
    emit(
      state.copyWith(
        isLoading: true,
        date: params.anchorDate,
        clearError: true,
        periodType: params.periodType,
      ),
    );

    try {
      final allTransactions = await _getTransactionsUsecase();
      final weekStart = _startOfWeek(state.date);
      final recentFrom = DateTime(
        state.date.year,
        state.date.month,
        state.date.day,
      ).subtract(const Duration(days: 6));
      final weeklyReport = await _getDetailedReportUsecase(params);

      final totalIncome = allTransactions
          .where((item) => item.type == TransactionType.income)
          .fold<double>(0, (sum, item) => sum + item.amount);
      final totalExpense = allTransactions
          .where((item) => item.type == TransactionType.expense)
          .fold<double>(0, (sum, item) => sum + item.amount);
      final recentTransactions = allTransactions
          .where((item) => !item.date.isBefore(recentFrom))
          .toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      emit(
        state.copyWith(
          isLoading: false,
          weeklyReport: weeklyReport,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          totalBalance: totalIncome - totalExpense,
          recentTransactions: recentTransactions.take(5).toList(),
          date: weekStart,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  DateTime _startOfWeek(DateTime value) {
    final dateOnly = DateTime(value.year, value.month, value.day);
    return dateOnly.subtract(Duration(days: dateOnly.weekday - 1));
  }
}
