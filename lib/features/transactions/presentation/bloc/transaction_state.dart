import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';

class TransactionState {
  final bool isLoading;
  final List<TransactionEntity> transactions;
  final String? errorMessage;

  const TransactionState({
    required this.isLoading,
    required this.transactions,
    this.errorMessage,
  });

  factory TransactionState.initial() {
    return const TransactionState(
      isLoading: false,
      transactions: [],
      errorMessage: null,
    );
  }

  TransactionState copyWith({
    bool? isLoading,
    List<TransactionEntity>? transactions,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TransactionState(
      isLoading: isLoading ?? this.isLoading,
      transactions: transactions ?? this.transactions,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
