class CategoryExpenseSummaryEntity {
  final String categoryId;
  final String categoryName;
  final double totalAmount;
  final int colorValue;

  const CategoryExpenseSummaryEntity({
    required this.categoryId,
    required this.categoryName,
    required this.totalAmount,
    required this.colorValue,
  });
}
