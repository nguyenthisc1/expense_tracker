import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/categories/domain/repository/category_repository.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';
import 'package:expense_tracker/features/transactions/domain/repository/transaction_repository.dart';

class AddTransactionUsecase {
  final TransactionRepository _transactionRepository;
  final CategoryRepository _categoryRepository;

  const AddTransactionUsecase(
    this._transactionRepository,
    this._categoryRepository,
  );

  Future<TransactionEntity> call(TransactionEntity transaction) async {
    if (transaction.title.trim().isEmpty) {
      throw const ValidationException('Transaction title cannot be empty.');
    }

    if (transaction.amount <= 0) {
      throw const ValidationException(
        'Transaction amount must be greater than 0.',
      );
    }
    final category = await _categoryRepository.getCategoryById(
      transaction.categoryId,
    );

    if (category == null) {
      throw const NotFoundException('Selected category was not found.');
    }

    if (category.type != transaction.type) {
      throw const BusinessRuleException(
        'Transaction type must match category type.',
      );
    }

    return _transactionRepository.addTransaction(transaction);
  }
}
