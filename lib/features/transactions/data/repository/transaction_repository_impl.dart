import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/features/transactions/data/datasource/transaction_local_datasource.dart';
import 'package:expense_tracker/features/transactions/data/mapper/transaction_mapper.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';
import 'package:expense_tracker/features/transactions/domain/repository/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDatasource _localDatasource;

  const TransactionRepositoryImpl(this._localDatasource);

  @override
  Future<TransactionEntity> addTransaction(
    TransactionEntity transaction,
  ) async {
    final model = TransactionMapper.toModel(transaction);
    final saved = await _localDatasource.addTransaction(model);
    return TransactionMapper.toEntity(saved);
  }

  @override
  Future<void> deleteTransaction(String id) {
    return _localDatasource.deleteTransaction(id);
  }

  @override
  Future<TransactionEntity?> getTransactionById(String id) async {
    final model = await _localDatasource.getTransactionById(id);

    if (model == null) {
      return null;
    }

    return TransactionMapper.toEntity(model);
  }

  @override
  Future<List<TransactionEntity>> getTransactions({
    DateTime? from,
    DateTime? to,
    TransactionType? type,
    String? categoryId,
  }) async {
    final models = await _localDatasource.getTransactions(
      from: from,
      to: to,
      type: type?.name,
      categoryId: categoryId,
    );

    return models.map(TransactionMapper.toEntity).toList();
  }

  @override
  Future<TransactionEntity> updateTransaction(
    TransactionEntity transaction,
  ) async {
    final model = TransactionMapper.toModel(transaction);
    final updated = await _localDatasource.updateTransaction(model);
    return TransactionMapper.toEntity(updated);
  }
}
