import 'package:expense_tracker/features/reports/domain/entity/detailed_report_entity.dart';
import 'package:expense_tracker/features/transactions/data/model/transaction_model.dart';

abstract interface class ExportLocalDatasource {
  Future<String> exportTransactionsCsv(List<TransactionModel> transactions);
  Future<String> exportReportPdf(DetailedReportEntity report);
}
