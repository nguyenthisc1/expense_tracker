import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/reports/domain/entity/monthly_report_entity.dart';
import 'package:expense_tracker/features/reports/domain/repository/report_repository.dart';

class GetMonthlySummaryUsecase {
  final ReportRepository _reportRepository;

  const GetMonthlySummaryUsecase(this._reportRepository);

  Future<MonthlyReportEntity> call({required int year, required int month}) {
    if (month < 1 || month > 12) {
      throw const ValidationException('Month must be between 1 and 12.');
    }

    if (year <= 0) {
      throw const ValidationException('Year must be greater than 0.');
    }

    return _reportRepository.getMonthlySummary(year: year, month: month);
  }
}
