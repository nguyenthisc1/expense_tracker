import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/features/categories/domain/entity/category_entity.dart';

abstract interface class CategoryRepository {
  Future<List<CategoryEntity>> getCategories({TransactionType? type});

  Future<CategoryEntity?> getCategoryById(String id);

  Future<CategoryEntity> addCategory(CategoryEntity category);

  Future<CategoryEntity> updateCategory(CategoryEntity category);

  Future<void> deleteCategory(String id);

  Future<bool> isCategoryInUse(String categoryId);
}
