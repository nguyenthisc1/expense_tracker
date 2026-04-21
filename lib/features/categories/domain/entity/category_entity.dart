import 'package:expense_tracker/core/entity/transaction_type.dart';

class CategoryEntity {
  final String id;
  final String name;
  final TransactionType type;
  final int colorValue;
  final String iconName;
  final bool isDefault;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.colorValue,
    required this.iconName,
    required this.isDefault,
  });

  CategoryEntity copyWith({
    String? id,
    String? name,
    TransactionType? type,
    int? colorValue,
    String? iconName,
    bool? isDefault,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      colorValue: colorValue ?? this.colorValue,
      iconName: iconName ?? this.iconName,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
