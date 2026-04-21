import 'package:expense_tracker/features/reports/domain/entity/detailed_report_entity.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';

abstract interface class ExportRepository {
  Future<String> exportTransactionsCsv(List<TransactionEntity> transactions);
  Future<String> exportReportPdf(DetailedReportEntity report);
}
