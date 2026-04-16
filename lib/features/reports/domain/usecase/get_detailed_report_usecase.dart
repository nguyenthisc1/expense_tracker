import 'package:expense_tracker/features/reports/domain/entity/detailed_report_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_types.dart';
import 'package:expense_tracker/features/reports/domain/repository/report_repository.dart';

class GetDetailedReportUsecase {
  final ReportRepository _reportRepository;

  const GetDetailedReportUsecase(this._reportRepository);

  Future<DetailedReportEntity> call(DetailedReportParams params) {
    return _reportRepository.getDetailedReport(params);
  }
}
