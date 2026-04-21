import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/features/categories/domain/usecase/get_all_categories_usecase.dart';
import 'package:expense_tracker/features/categories/domain/usecase/get_categorie_by_id_usecase.dart';
import 'package:expense_tracker/presentation/categories/cubit/categories_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final GetAllCategoriesUsecase _getAllCategoriesUsecase;
  final GetCategoryByIdUsecase _getCategoryByIdUsecase;

  CategoriesCubit({
    required GetAllCategoriesUsecase getAllCategoriesUsecase,
    required GetCategoryByIdUsecase getCategoryByIdUsecase,
  }) : _getAllCategoriesUsecase = getAllCategoriesUsecase,
       _getCategoryByIdUsecase = getCategoryByIdUsecase,
       super(CategoriesState.initial());

  Future<void> loadCategories() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final allCategories = await _getAllCategoriesUsecase();

      emit(
        state.copyWith(
          isLoading: false,
          allCategories: allCategories,
          categories: allCategories,
          clearError: true,
        ),
      );
    } catch (error) {
      state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> getCategoriesByTypeTransaction(TransactionType? type) async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
      final categoriesByType = type == null
          ? state.allCategories
          : state.allCategories.where((c) => c.type == type).toList();

      emit(
        state.copyWith(
          isLoading: false,
          categories: categoriesByType,
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }
}
