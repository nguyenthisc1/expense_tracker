import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';

class CategoryEntity {
  final String id;
  final String name;
  final TransactionType type;
  final int colorValue;
  final String iconName;
  final bool isDefault;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.colorValue,
    required this.iconName,
    required this.isDefault,
  });
}
