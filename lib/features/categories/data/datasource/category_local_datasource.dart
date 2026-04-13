import 'package:expense_tracker/features/categories/data/model/category_model.dart';

abstract interface class CategoryLocalDatasource {
  Future<List<CategoryModel>> getCategories({String? type});

  Future<CategoryModel?> getCategoryById(String id);

  Future<CategoryModel> addCategory(CategoryModel category);

  Future<CategoryModel> updateCategory(CategoryModel category);

  Future<void> deleteCategory(String id);

  Future<bool> existsCategoryName({
    required String name,
    required String type,
    String? excludeId,
  });

  Future<bool> isCategoryInUse(String categoryId);
}
