import 'package:expense_tracker/features/categories/domain/entity/category_entity.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';

abstract interface class CategoryRepository {
  Future<List<CategoryEntity>> getCategories({TransactionType? type});
  Future<CategoryEntity> addCategory(CategoryEntity category);
  Future<CategoryEntity> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(String id);
  Future<CategoryEntity?> getCategoryById(String id);
  Future<bool> isCategoryInUse(String categoryId);
}
