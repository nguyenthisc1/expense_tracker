import 'package:expense_tracker/features/categories/data/model/category_model.dart';
import 'package:expense_tracker/features/transactions/data/model/transaction_model.dart';
import 'package:isar/isar.dart';

import 'category_local_datasource.dart';

class CategoryLocalDatasourceImpl implements CategoryLocalDatasource {
  final Isar _isar;

  const CategoryLocalDatasourceImpl(this._isar);

  @override
  Future<List<CategoryModel>> getCategories({String? type}) async {
    final items = await _isar.categoryModels.where().findAll();

    if (type == null) {
      return items;
    }

    return items.where((item) => item.type == type).toList();
  }

  @override
  Future<CategoryModel?> getCategoryById(String id) {
    return _isar.categoryModels.filter().idEqualTo(id).findFirst();
  }

  @override
  Future<CategoryModel> addCategory(CategoryModel category) async {
    await _isar.writeTxn(() async {
      await _isar.categoryModels.put(category);
    });

    return category;
  }

  @override
  Future<CategoryModel> updateCategory(CategoryModel category) async {
    await _isar.writeTxn(() async {
      await _isar.categoryModels.put(category);
    });

    return category;
  }

  @override
  Future<void> deleteCategory(String id) async {
    final existing = await _isar.categoryModels
        .filter()
        .idEqualTo(id)
        .findFirst();

    if (existing == null) {
      return;
    }

    await _isar.writeTxn(() async {
      await _isar.categoryModels.delete(existing.isarId);
    });
  }

  @override
  Future<bool> existsCategoryName({
    required String name,
    required String type,
    String? excludeId,
  }) async {
    final normalizedName = name.trim().toLowerCase();
    final items = await _isar.categoryModels.where().findAll();

    return items.any((item) {
      final sameName = item.name.trim().toLowerCase() == normalizedName;
      final sameType = item.type == type;
      final isDifferentItem = excludeId == null || item.id != excludeId;

      return sameName && sameType && isDifferentItem;
    });
  }

  @override
  Future<bool> isCategoryInUse(String categoryId) async {
    final transaction = await _isar.transactionModels
        .filter()
        .categoryIdEqualTo(categoryId)
        .findFirst();

    return transaction != null;
  }

  @override
  Future<List<CategoryModel>> getAllCategories({String? type}) async {
    final items = await _isar.categoryModels.where().findAll();

    if (type == null) {
      return items;
    }

    return items.toList();
  }
}
