import 'package:expense_tracker/features/transactions/domain/usecase/add_transaction_usecase.dart';
import 'package:expense_tracker/features/transactions/domain/usecase/delete_transaction_usecase.dart';
import 'package:expense_tracker/features/transactions/domain/usecase/get_transactions_usecase.dart';
import 'package:expense_tracker/features/transactions/domain/usecase/update_transaction_usecase.dart';
import 'package:expense_tracker/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:expense_tracker/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsUsecase _getTransactionsUsecase;
  final AddTransactionUsecase _addTransactionUsecase;
  final UpdateTransactionUsecase _updateTransactionUsecase;
  final DeleteTransactionUsecase _deleteTransactionUsecase;

  TransactionBloc({
    required GetTransactionsUsecase getTransactionsUsecase,
    required AddTransactionUsecase addTransactionUsecase,
    required UpdateTransactionUsecase updateTransactionUsecase,
    required DeleteTransactionUsecase deleteTransactionUsecase,
  }) : _getTransactionsUsecase = getTransactionsUsecase,
       _addTransactionUsecase = addTransactionUsecase,
       _updateTransactionUsecase = updateTransactionUsecase,
       _deleteTransactionUsecase = deleteTransactionUsecase,
       super(TransactionState.initial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransactionRequested>(_onAddTransactionRequested);
    on<UpdateTransactionRequested>(_onUpdateTransactionRequested);
    on<DeleteTransactionRequested>(_onDeleteTransactionRequested);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final transactions = await _getTransactionsUsecase(
        from: event.from,
        to: event.to,
        type: event.type,
        categoryId: event.categoryId,
      );

      emit(
        state.copyWith(
          isLoading: false,
          transactions: transactions,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddTransactionRequested(
    AddTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await _addTransactionUsecase(event.transaction);
      final transactions = await _getTransactionsUsecase();

      emit(
        state.copyWith(
          isLoading: false,
          transactions: transactions,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdateTransactionRequested(
    UpdateTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await _updateTransactionUsecase(event.transaction);
      final transactions = await _getTransactionsUsecase();

      emit(
        state.copyWith(
          isLoading: false,
          transactions: transactions,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteTransactionRequested(
    DeleteTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      await _deleteTransactionUsecase(event.id);
      final transactions = await _getTransactionsUsecase();

      emit(
        state.copyWith(
          isLoading: false,
          transactions: transactions,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
