import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';

abstract class TransactionEvent {
  const TransactionEvent();
}

class LoadTransactions extends TransactionEvent {
  final DateTime? from;
  final DateTime? to;
  final TransactionType? type;
  final String? categoryId;

  const LoadTransactions({this.from, this.to, this.type, this.categoryId});
}

class AddTransactionRequested extends TransactionEvent {
  final TransactionEntity transaction;

  const AddTransactionRequested(this.transaction);
}

class UpdateTransactionRequested extends TransactionEvent {
  final TransactionEntity transaction;

  const UpdateTransactionRequested(this.transaction);
}

class DeleteTransactionRequested extends TransactionEvent {
  final String id;

  const DeleteTransactionRequested(this.id);
}
