import 'package:expense_tracker/features/reports/domain/usecase/get_monthly_summary_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final GetMonthlySummaryUsecase _getMonthlySummaryUsecase;

  ReportCubit({required GetMonthlySummaryUsecase getMonthlySummaryUsecase})
    : _getMonthlySummaryUsecase = getMonthlySummaryUsecase,
      super(ReportState.initial());

  Future<void> loadCurrentMonth() async {
    await loadMonthlySummary(year: state.year, month: state.month);
  }

  Future<void> loadMonthlySummary({
    required int year,
    required int month,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        year: year,
        month: month,
        clearError: true,
      ),
    );

    try {
      final report = await _getMonthlySummaryUsecase(year: year, month: month);

      emit(state.copyWith(isLoading: false, report: report, clearError: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> loadPreviousMonth() async {
    final current = DateTime(state.year, state.month, 1);
    final previous = DateTime(current.year, current.month - 1, 1);

    await loadMonthlySummary(year: previous.year, month: previous.month);
  }

  Future<void> loadNextMonth() async {
    final current = DateTime(state.year, state.month, 1);
    final next = DateTime(current.year, current.month + 1, 1);

    await loadMonthlySummary(year: next.year, month: next.month);
  }
}
