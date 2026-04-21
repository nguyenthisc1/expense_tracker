import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/transactions/domain/repository/transaction_repository.dart';

class DeleteTransactionUsecase {
  final TransactionRepository _transactionRepository;

  const DeleteTransactionUsecase(this._transactionRepository);

  Future<void> call(String id) async {
    final existingTransaction = await _transactionRepository.getTransactionById(
      id,
    );

    if (existingTransaction == null) {
      throw const NotFoundException('Transaction was not found.');
    }

    await _transactionRepository.deleteTransaction(id);
  }
}
