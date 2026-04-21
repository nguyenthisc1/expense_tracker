import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/export/domain/repository/export_repository.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';

class ExportTransactionCsvUseCase {
  final ExportRepository _exportRepository;

  const ExportTransactionCsvUseCase(this._exportRepository);

  Future<String> call(List<TransactionEntity> transactions) async {
    if (transactions.isEmpty) {
      throw const ValidationException("Transaction list is empty");
    }

    return await _exportRepository.exportTransactionsCsv(transactions);
  }
}
