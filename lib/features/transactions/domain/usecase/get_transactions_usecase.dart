import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';
import 'package:expense_tracker/features/transactions/domain/repository/transaction_repository.dart';

class GetTransactionsUsecase {
  final TransactionRepository _transactionRepository;

  const GetTransactionsUsecase(this._transactionRepository);

  Future<List<TransactionEntity>> call({
    DateTime? from,
    DateTime? to,
    TransactionType? type,
    String? categoryId,
  }) async {
    if (from != null && to != null && from.isAfter(to)) {
      throw const ValidationException(
        'The start date must be earlier than or equal to the end date.',
      );
    }

    return await _transactionRepository.getTransactions(
      from: from,
      to: to,
      type: type,
      categoryId: categoryId,
    );
  }
}
