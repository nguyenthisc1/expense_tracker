import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/features/categories/data/datasource/category_local_datasource.dart';
import 'package:expense_tracker/features/categories/data/mapper/category_mapper.dart';
import 'package:expense_tracker/features/categories/domain/entity/category_entity.dart';
import 'package:expense_tracker/features/categories/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDatasource _localDatasource;

  const CategoryRepositoryImpl(this._localDatasource);

  @override
  Future<CategoryEntity> addCategory(CategoryEntity category) async {
    final model = CategoryMapper.toModel(category);
    final added = await _localDatasource.addCategory(model);

    return CategoryMapper.toEntity(added);
  }

  @override
  Future<void> deleteCategory(String id) async {
    return await _localDatasource.deleteCategory(id);
  }

  @override
  Future<bool> existsCategoryName({
    required String name,
    required TransactionType type,
    String? excludeId,
  }) async {
    return await _localDatasource.existsCategoryName(
      name: name,
      type: type.name,
      excludeId: excludeId,
    );
  }

  @override
  Future<List<CategoryEntity>> getCategories({TransactionType? type}) async {
    final models = await _localDatasource.getCategories(type: type?.name);
    return models.map(CategoryMapper.toEntity).toList();
  }

  @override
  Future<CategoryEntity?> getCategoryById(String id) async {
    final model = await _localDatasource.getCategoryById(id);

    if (model == null) return null;

    return CategoryMapper.toEntity(model);
  }

  @override
  Future<bool> isCategoryInUse(String categoryId) async {
    return await _localDatasource.isCategoryInUse(categoryId);
  }

  @override
  Future<CategoryEntity> updateCategory(CategoryEntity category) async {
    final model = CategoryMapper.toModel(category);
    final updated = await _localDatasource.updateCategory(model);

    return CategoryMapper.toEntity(updated);
  }

  @override
  Future<List<CategoryEntity>> getAllCategories({TransactionType? type}) async {
    final models = await _localDatasource.getAllCategories();
    return models.map(CategoryMapper.toEntity).toList();
  }
}
