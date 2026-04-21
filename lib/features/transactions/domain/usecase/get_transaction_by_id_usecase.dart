import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';
import 'package:expense_tracker/features/transactions/domain/repository/transaction_repository.dart';

class GetTransactionByIdUsecase {
  final TransactionRepository _transactionRepository;

  const GetTransactionByIdUsecase(this._transactionRepository);

  Future<TransactionEntity?> call(String id) async {
    final transaction = await _transactionRepository.getTransactionById(id);

    if (transaction == null) {
      throw const NotFoundException('Transaction was not found.');
    }

    return transaction;
  }
}
