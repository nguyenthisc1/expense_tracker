import 'package:expense_tracker/features/categories/domain/entity/category_entity.dart';

class CategoriesState {
  final bool isLoading;
  final List<CategoryEntity> categories;
  final List<CategoryEntity> allCategories;
  final String? errorMessage;

  const CategoriesState({
    required this.isLoading,
    required this.errorMessage,
    this.categories = const [],
    this.allCategories = const [],
  });

  factory CategoriesState.initial() {
    return CategoriesState(
      isLoading: false,
      errorMessage: null,
      categories: [],
      allCategories: [],
    );
  }

  CategoriesState copyWith({
    bool? isLoading,
    List<CategoryEntity>? categories,
    List<CategoryEntity>? allCategories,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CategoriesState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      allCategories: allCategories ?? this.allCategories,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
