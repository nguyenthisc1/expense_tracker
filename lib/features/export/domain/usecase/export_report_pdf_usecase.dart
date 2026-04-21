import 'package:expense_tracker/features/export/domain/repository/export_repository.dart';
import 'package:expense_tracker/features/reports/domain/entity/detailed_report_entity.dart';

class ExportReportPdfUsecase {
  final ExportRepository _exportRepository;

  const ExportReportPdfUsecase(this._exportRepository);

  Future<String> call(DetailedReportEntity report) {
    return _exportRepository.exportReportPdf(report);
  }
}
