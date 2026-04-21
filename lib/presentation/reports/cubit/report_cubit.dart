import 'package:expense_tracker/features/reports/domain/entity/report_types.dart';
import 'package:expense_tracker/features/reports/domain/usecase/get_detailed_report_usecase.dart';
import 'package:expense_tracker/features/reports/domain/usecase/get_monthly_summary_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final GetMonthlySummaryUsecase _getMonthlySummaryUsecase;
  final GetDetailedReportUsecase _getDetailedReportUsecase;

  ReportCubit({
    required GetMonthlySummaryUsecase getMonthlySummaryUsecase,
    required GetDetailedReportUsecase getDetailedReportUsecase,
  }) : _getDetailedReportUsecase = getDetailedReportUsecase,
       _getMonthlySummaryUsecase = getMonthlySummaryUsecase,
       super(ReportState.initial());

  Future<void> loadCurrentMonth() async {
    final params = DetailedReportParams(
      anchorDate: state.date,
      periodType: state.periodType,
    );
    await loadDetailedReport(params);
  }

  Future<void> loadDetailedReport(DetailedReportParams param) async {
    emit(
      state.copyWith(
        isLoading: true,
        date: param.anchorDate,
        clearError: true,
        periodType: param.periodType,
      ),
    );

    try {
      final report = await _getDetailedReportUsecase(param);

      emit(state.copyWith(isLoading: false, report: report, clearError: true));
    } catch (error) {
      state.copyWith(isLoading: false, errorMessage: error.toString());
    }
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
      final monthlyReport = await _getMonthlySummaryUsecase(
        year: year,
        month: month,
      );

      emit(
        state.copyWith(
          isLoading: false,
          monthlyReport: monthlyReport,
          clearError: true,
        ),
      );
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
