import 'package:expense_tracker/features/categories/data/datasource/category_local_datasource.dart';
import 'package:expense_tracker/features/categories/data/mapper/category_mapper.dart';
import 'package:expense_tracker/features/reports/domain/entity/category_expense_summary_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/monthly_report_entity.dart';
import 'package:expense_tracker/features/reports/domain/repository/report_repository.dart';
import 'package:expense_tracker/features/transactions/data/datasource/transaction_local_datasource.dart';
import 'package:expense_tracker/features/transactions/data/mapper/transaction_mapper.dart';

class ReportRepositoryImpl implements ReportRepository {
  final TransactionLocalDatasource _transactionLocalDatasource;
  final CategoryLocalDatasource _categoryLocalDatasource;

  const ReportRepositoryImpl(
    this._categoryLocalDatasource,
    this._transactionLocalDatasource,
  );

  @override
  Future<MonthlyReportEntity> getMonthlySummary({
    required int year,
    required int month,
  }) async {
    final from = DateTime(year, month, 1);
    final to = DateTime(year, month + 1, 0, 23, 59, 59);

    final transactionModels = await _transactionLocalDatasource.getTransactions(
      from: from,
      to: to,
    );

    final categoryModels = await _categoryLocalDatasource.getCategories();

    final transactions = transactionModels
        .map(TransactionMapper.toEntity)
        .toList();
    final categories = categoryModels.map(CategoryMapper.toEntity).toList();

    final totalIncome = transactions
        .where((item) => item.type.name == 'income')
        .fold<double>(0, (sum, item) => sum + item.amount);

    final totalExpense = transactions
        .where((item) => item.type.name == 'expense')
        .fold<double>(0, (sum, item) => sum + item.amount);

    final expenseTransactions = transactions
        .where((item) => item.type.name == 'expense')
        .toList();

    final expenseByCategoryMap = <String, double>{};

    for (final transaction in expenseTransactions) {
      expenseByCategoryMap.update(
        transaction.categoryId,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    final expenseByCategory = expenseByCategoryMap.entries.map((entry) {
      final category = categories.firstWhere((item) => item.id == entry.key);

      return CategoryExpenseSummaryEntity(
        categoryId: category.id,
        categoryName: category.name,
        totalAmount: entry.value,
        colorValue: category.colorValue,
      );
    }).toList();

    expenseByCategory.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    return MonthlyReportEntity(
      year: year,
      month: month,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      balance: totalIncome - totalExpense,
      expenseByCategory: expenseByCategory,
    );
  }
}
