import 'package:uuid/uuid.dart';

import '../../../../core/entity/transaction_type.dart';
import '../../../categories/domain/entity/category_entity.dart';
import '../../domain/entity/transaction_entity.dart';

abstract final class TransactionSeedData {
  static final Uuid _uuid = const Uuid();

  static List<TransactionEntity> buildDemoTransactions({
    required DateTime now,
    required List<CategoryEntity> categories,
  }) {
    final items = <TransactionEntity>[];

    // Helper to find the matching category id (ID-lookup by name and type)
    String categoryId(String name, TransactionType type) {
      final category = categories.firstWhere(
        (item) => item.name == name && item.type == type,
        orElse: () =>
            throw StateError('No matching category found for $name ($type)'),
      );
      return category.id;
    }

    // Helper for creating transaction entities with accurate category linkage
    TransactionEntity tx({
      required String title,
      required double amount,
      required TransactionType type,
      required DateTime date,
      required String categoryName,
      String? note,
    }) {
      return TransactionEntity(
        id: _uuid.v4(),
        title: title,
        amount: amount,
        type: type,
        date: date,
        categoryId: categoryId(categoryName, type),
        note: note,
        createdAt: date,
        updatedAt: date,
      );
    }

    // Calculate the start of the week (Monday) and start of the month
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfMonth = DateTime(now.year, now.month, 1);

    // Demo transactions this week
    items.addAll([
      tx(
        title: 'Lunch',
        amount: 85000,
        type: TransactionType.expense,
        date: startOfWeek.add(const Duration(hours: 12)),
        categoryName: 'Food',
      ),
      tx(
        title: 'Bus fare',
        amount: 15000,
        type: TransactionType.expense,
        date: startOfWeek.add(const Duration(hours: 18)),
        categoryName: 'Transport',
      ),
      tx(
        title: 'Freelance payout',
        amount: 1200000,
        type: TransactionType.income,
        date: startOfWeek.add(const Duration(days: 1, hours: 10)),
        categoryName: 'Freelance',
      ),
      tx(
        title: 'Dinner',
        amount: 120000,
        type: TransactionType.expense,
        date: startOfWeek.add(const Duration(days: 1, hours: 19)),
        categoryName: 'Food',
      ),
      tx(
        title: 'Movie night',
        amount: 180000,
        type: TransactionType.expense,
        date: startOfWeek.add(const Duration(days: 3, hours: 20)),
        categoryName: 'Entertainment',
      ),
      tx(
        title: 'Coffee',
        amount: 45000,
        type: TransactionType.expense,
        date: startOfWeek.add(const Duration(days: 4, hours: 9)),
        categoryName: 'Food',
      ),
      tx(
        title: 'Ride home',
        amount: 35000,
        type: TransactionType.expense,
        date: startOfWeek.add(const Duration(days: 5, hours: 21)),
        categoryName: 'Transport',
      ),
      tx(
        title: 'Gift money',
        amount: 500000,
        type: TransactionType.income,
        date: startOfWeek.add(const Duration(days: 6, hours: 11)),
        categoryName: 'Other',
      ),
    ]);

    // Demo transactions this month
    items.addAll([
      tx(
        title: 'Monthly salary',
        amount: 18000000,
        type: TransactionType.income,
        date: startOfMonth.add(const Duration(hours: 8)),
        categoryName: 'Salary',
      ),
      tx(
        title: 'Apartment rent',
        amount: 6500000,
        type: TransactionType.expense,
        date: startOfMonth.add(const Duration(hours: 9)),
        categoryName: 'Housing',
      ),
      tx(
        title: 'Electric bill',
        amount: 520000,
        type: TransactionType.expense,
        date: startOfMonth.add(const Duration(days: 1, hours: 19)),
        categoryName: 'Bills',
      ),
      tx(
        title: 'Water bill',
        amount: 180000,
        type: TransactionType.expense,
        date: startOfMonth.add(const Duration(days: 2, hours: 19)),
        categoryName: 'Bills',
      ),
      tx(
        title: 'Groceries',
        amount: 420000,
        type: TransactionType.expense,
        date: startOfMonth.add(const Duration(days: 3, hours: 18)),
        categoryName: 'Food',
      ),
      tx(
        title: 'New shoes',
        amount: 950000,
        type: TransactionType.expense,
        date: startOfMonth.add(const Duration(days: 5, hours: 14)),
        categoryName: 'Shopping',
      ),
      tx(
        title: 'Clinic visit',
        amount: 300000,
        type: TransactionType.expense,
        date: startOfMonth.add(const Duration(days: 7, hours: 10)),
        categoryName: 'Health',
      ),
      tx(
        title: 'Freelance project',
        amount: 2500000,
        type: TransactionType.income,
        date: startOfMonth.add(const Duration(days: 10, hours: 16)),
        categoryName: 'Freelance',
      ),
      tx(
        title: 'Weekend groceries',
        amount: 360000,
        type: TransactionType.expense,
        date: startOfMonth.add(const Duration(days: 12, hours: 11)),
        categoryName: 'Food',
      ),
      tx(
        title: 'Cinema',
        amount: 220000,
        type: TransactionType.expense,
        date: startOfMonth.add(const Duration(days: 13, hours: 20)),
        categoryName: 'Entertainment',
      ),
      tx(
        title: 'Phone bill',
        amount: 150000,
        type: TransactionType.expense,
        date: startOfMonth.add(const Duration(days: 15, hours: 9)),
        categoryName: 'Bills',
      ),
      tx(
        title: 'Office lunch',
        amount: 95000,
        type: TransactionType.expense,
        date: startOfMonth.add(const Duration(days: 16, hours: 12)),
        categoryName: 'Food',
      ),
    ]);

    // Demo transactions from previous months (Jan, Feb, Mar)
    items.addAll([
      tx(
        title: 'January salary',
        amount: 17500000,
        type: TransactionType.income,
        date: DateTime(now.year, 1, 2, 8),
        categoryName: 'Salary',
      ),
      tx(
        title: 'Tet bonus',
        amount: 4000000,
        type: TransactionType.income,
        date: DateTime(now.year, 1, 25, 10),
        categoryName: 'Bonus',
      ),
      tx(
        title: 'January rent',
        amount: 6200000,
        type: TransactionType.expense,
        date: DateTime(now.year, 1, 3, 9),
        categoryName: 'Housing',
      ),
      tx(
        title: 'Supermarket',
        amount: 510000,
        type: TransactionType.expense,
        date: DateTime(now.year, 1, 12, 18),
        categoryName: 'Food',
      ),
      tx(
        title: 'February salary',
        amount: 18000000,
        type: TransactionType.income,
        date: DateTime(now.year, 2, 1, 8),
        categoryName: 'Salary',
      ),
      tx(
        title: 'Valentine dinner',
        amount: 650000,
        type: TransactionType.expense,
        date: DateTime(now.year, 2, 14, 20),
        categoryName: 'Food',
      ),
      tx(
        title: 'Shopping mall',
        amount: 1350000,
        type: TransactionType.expense,
        date: DateTime(now.year, 2, 18, 15),
        categoryName: 'Shopping',
      ),
      tx(
        title: 'Freelance deposit',
        amount: 1800000,
        type: TransactionType.income,
        date: DateTime(now.year, 2, 22, 14),
        categoryName: 'Freelance',
      ),
      tx(
        title: 'March salary',
        amount: 18000000,
        type: TransactionType.income,
        date: DateTime(now.year, 3, 1, 8),
        categoryName: 'Salary',
      ),
      tx(
        title: 'Flight booking',
        amount: 2400000,
        type: TransactionType.expense,
        date: DateTime(now.year, 3, 8, 9),
        categoryName: 'Other',
      ),
      tx(
        title: 'Hospital checkup',
        amount: 850000,
        type: TransactionType.expense,
        date: DateTime(now.year, 3, 17, 10),
        categoryName: 'Health',
      ),
      tx(
        title: 'Streaming services',
        amount: 260000,
        type: TransactionType.expense,
        date: DateTime(now.year, 3, 24, 21),
        categoryName: 'Entertainment',
      ),
    ]);

    // Ensure most recent transactions show first
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }
}
