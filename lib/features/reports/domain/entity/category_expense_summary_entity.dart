import 'package:expense_tracker/core/entity/transaction_type.dart';

class CategoryExpenseSummaryEntity {
  final String categoryId;
  final String categoryName;
  final double totalAmount;
  final int colorValue;
  final TransactionType type;
  final String iconName;

  const CategoryExpenseSummaryEntity({
    required this.categoryId,
    required this.categoryName,
    required this.totalAmount,
    required this.colorValue,
    required this.type,
    required this.iconName,
  });
}
