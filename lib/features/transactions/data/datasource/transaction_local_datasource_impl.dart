import 'package:expense_tracker/features/transactions/data/model/transaction_model.dart';
import 'package:isar/isar.dart';

import 'transaction_local_datasource.dart';

class TransactionLocalDataSourceImpl implements TransactionLocalDatasource {
  final Isar _isar;

  const TransactionLocalDataSourceImpl(this._isar);

  @override
  Future<List<TransactionModel>> getTransactions({
    DateTime? from,
    DateTime? to,
    String? type,
    String? categoryId,
  }) async {
    final items = await _isar.transactionModels
        .where()
        .sortByDateDesc()
        .findAll();

    return items.where((item) {
      final matchesFrom = from == null || !item.date.isBefore(from);
      final matchesTo = to == null || !item.date.isAfter(to);
      final matchesType = type == null || item.type == type;
      final matchesCategory =
          categoryId == null || item.categoryId == categoryId;

      return matchesFrom && matchesTo && matchesType && matchesCategory;
    }).toList();
  }

  @override
  Future<TransactionModel?> getTransactionById(String id) {
    return _isar.transactionModels.filter().idEqualTo(id).findFirst();
  }

  @override
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    await _isar.writeTxn(() async {
      await _isar.transactionModels.put(transaction);
    });

    return transaction;
  }

  @override
  Future<TransactionModel> updateTransaction(
    TransactionModel transaction,
  ) async {
    await _isar.writeTxn(() async {
      await _isar.transactionModels.put(transaction);
    });

    return transaction;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final existing = await _isar.transactionModels
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (existing == null) {
      return;
    }

    await _isar.writeTxn(() async {
      await _isar.transactionModels.delete(existing.isarId);
    });
  }
}
