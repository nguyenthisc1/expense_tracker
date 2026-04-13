import 'package:expense_tracker/features/categories/data/model/category_model.dart';
import 'package:expense_tracker/features/categories/domain/entity/category_entity.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';

class CategoryMapper {
  static CategoryEntity toEntity(CategoryModel model) {
    return CategoryEntity(
      id: model.id,
      name: model.name,
      type: model.type == 'income'
          ? TransactionType.income
          : TransactionType.expense,
      colorValue: model.colorValue,
      iconName: model.iconName,
      isDefault: model.isDefault,
    );
  }

  static CategoryModel toModel(CategoryEntity entity) {
    final model = CategoryModel()
      ..id = entity.id
      ..name = entity.name
      ..type = entity.type.name
      ..colorValue = entity.colorValue
      ..iconName = entity.iconName
      ..isDefault = entity.isDefault;
    return model;
  }
}
