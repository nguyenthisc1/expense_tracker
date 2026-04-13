import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/features/categories/data/model/category_model.dart';
import 'package:expense_tracker/features/categories/domain/entity/category_entity.dart';

class CategoryMapper {
  const CategoryMapper._();

  static CategoryEntity toEntity(CategoryModel model) {
    return CategoryEntity(
      id: model.id,
      name: model.name,
      type: _mapTypeFromString(model.type),
      colorValue: model.colorValue,
      iconName: model.iconName,
      isDefault: model.isDefault,
    );
  }

  static CategoryModel toModel(CategoryEntity entity) {
    return CategoryModel()
      ..id = entity.id
      ..name = entity.name
      ..type = entity.type.name
      ..colorValue = entity.colorValue
      ..iconName = entity.iconName
      ..isDefault = entity.isDefault;
  }

  static TransactionType _mapTypeFromString(String value) {
    return TransactionType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => TransactionType.expense,
    );
  }
}
