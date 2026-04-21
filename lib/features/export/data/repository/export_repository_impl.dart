import 'package:expense_tracker/features/export/data/datasource/export_local_datasource.dart';
import 'package:expense_tracker/features/export/domain/repository/export_repository.dart';
import 'package:expense_tracker/features/reports/domain/entity/detailed_report_entity.dart';
import 'package:expense_tracker/features/transactions/data/mapper/transaction_mapper.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';

class ExportRepositoryImpl implements ExportRepository {
  final ExportLocalDatasource _datasource;

  const ExportRepositoryImpl(this._datasource);

  @override
  Future<String> exportReportPdf(DetailedReportEntity report) {
    return _datasource.exportReportPdf(report);
  }

  @override
  Future<String> exportTransactionsCsv(List<TransactionEntity> transactions) {
    final model = transactions.map(TransactionMapper.toModel).toList();

    return _datasource.exportTransactionsCsv(model);
  }
}
