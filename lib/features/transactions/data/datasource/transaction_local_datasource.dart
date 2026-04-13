import 'package:expense_tracker/features/transactions/data/model/transaction_model.dart';

abstract interface class TransactionLocalDatasource {
  Future<List<TransactionModel>> getTransactions({
    DateTime? from,
    DateTime? to,
    String? type,
    String? categoryId,
  });

  Future<TransactionModel?> getTransactionById(String id);

  Future<TransactionModel> addTransaction(TransactionModel transaction);

  Future<TransactionModel> updateTransaction(TransactionModel transaction);

  Future<void> deleteTransaction(String id);
}
