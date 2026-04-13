enum TransactionType { income, expense }

class TransactionEntity {
  final String id;
  final String title;
  final double amount;
  final TransactionType type; // income | expense
  final DateTime date;
  final String categoryId;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.categoryId,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
}
