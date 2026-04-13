import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';

abstract interface class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions({
    DateTime? from,
    DateTime? to,
    TransactionType? type,
    String? categoryId,
  });

  Future<TransactionEntity> addTransaction(TransactionEntity transaction);

  Future<TransactionEntity> updateTransaction(TransactionEntity transaction);

  Future<void> deleteTransaction(String id);

  Future<TransactionEntity?> getTransactionById(String id);
}
