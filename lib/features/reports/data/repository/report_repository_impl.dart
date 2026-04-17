import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/core/utils/date_utils.dart';
import 'package:expense_tracker/features/categories/data/datasource/category_local_datasource.dart';
import 'package:expense_tracker/features/categories/data/mapper/category_mapper.dart';
import 'package:expense_tracker/features/reports/domain/entity/category_expense_summary_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/detailed_report_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/monthly_report_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_breakdown_point_entity.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_breakdown_type.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_period_type.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_types.dart';
import 'package:expense_tracker/features/reports/domain/repository/report_repository.dart';
import 'package:expense_tracker/features/transactions/data/datasource/transaction_local_datasource.dart';
import 'package:expense_tracker/features/transactions/data/mapper/transaction_mapper.dart';
import 'package:expense_tracker/features/transactions/domain/entity/transaction_entity.dart';

class _Bucket {
  final String key;
  final String label;
  final DateTime start;
  final DateTime end;

  const _Bucket({
    required this.label,
    required this.start,
    required this.end,
    required this.key,
  });
}

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
        .where((item) => item.type.name == TransactionType.income.name)
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
        type: category.type,
        iconName: category.iconName,
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

  /// Generates a detailed report within the specified period, breaking down totals
  /// and groupings (by income, expense, category, and bucket, e.g. day or month).
  @override
  Future<DetailedReportEntity> getDetailedReport(
    DetailedReportParams params,
  ) async {
    final periodType = params.periodType;
    final anchorDate = params.anchorDate;

    // Determine which breakdown type to use for the report's x-axis granularity
    final effectiveBreakdownType =
        params.breakdownType ??
        switch (periodType) {
          ReportPeriodType.week => ReportBreakdownType.day,
          ReportPeriodType.month => ReportBreakdownType.day,
          ReportPeriodType.year => ReportBreakdownType.month,
        };

    // Compute report start ("from") and end ("to") dates based on period type
    final from = _getPeriodStart(periodType, anchorDate);
    final to = anchorDate;

    // Generate list of "buckets" (i.e., segments—days/months) for breakdowns
    final buckets = _generateBuckets(from, to, effectiveBreakdownType);

    // Fetch transaction and category models from datasources
    final transactionModels = await _transactionLocalDatasource.getTransactions(
      from: from,
      to: to,
    );
    final categoryModels = await _categoryLocalDatasource.getCategories();

    // Map models to domain entities
    final transactions = transactionModels
        .map(TransactionMapper.toEntity)
        .toList();
    final categories = categoryModels.map(CategoryMapper.toEntity).toList();

    // Compute total income and total expense for the period
    final totalIncome = _sumAmountByType(TransactionType.income, transactions);
    final totalExpense = _sumAmountByType(
      TransactionType.expense,
      transactions,
    );

    // Generate list of breakdowns per bucket (day/month) based on transactions
    final breakdowns = buckets.map((b) {
      final bucketTransactions = transactions.where((tx) {
        return !tx.date.isBefore(b.start) && !tx.date.isAfter(b.end);
      }).toList();

      final income = bucketTransactions
          .where((tx) => tx.type.name == TransactionType.income.name)
          .fold<double>(0.0, (sum, tx) => sum + tx.amount);
      final expense = bucketTransactions
          .where((tx) => tx.type.name == TransactionType.expense.name)
          .fold<double>(0.0, (sum, tx) => sum + tx.amount);

      return ReportBreakdownPointEntity(
        label: b.label,
        startDate: b.start,
        endDate: b.end,
        income: income,
        expense: expense,
        balance: income - expense,
      );
    }).toList();

    // Compute expense-by-category summary for the period
    final expenseTransactions = transactions
        .where((item) => item.type.name == TransactionType.expense.name)
        .toList();

    final expenseByCategoryMap = <String, double>{};

    // Aggregate expenses by categoryId
    for (final transaction in expenseTransactions) {
      expenseByCategoryMap.update(
        transaction.categoryId,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    // Map expense sums to CategoryExpenseSummaryEntity list; filter unknown
    final expenseByCategory = expenseByCategoryMap.entries
        .map((entry) {
          final category = categories
              .where((item) => item.id == entry.key)
              .firstOrNull;

          if (category == null) return null;

          return CategoryExpenseSummaryEntity(
            categoryId: category.id,
            categoryName: category.name,
            totalAmount: entry.value,
            colorValue: category.colorValue,
            type: category.type,
            iconName: category.iconName,
          );
        })
        .whereType<CategoryExpenseSummaryEntity>()
        .toList();

    // Sort expense categories descending by total spent
    expenseByCategory.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    // Assemble and return the report entity
    return DetailedReportEntity(
      periodType: periodType,
      startDate: from,
      endDate: to,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      balance: totalIncome - totalExpense,
      breakdown: breakdowns,
      expenseByCategory: expenseByCategory,
      breakdownType: effectiveBreakdownType,
    );
  }

  /// Returns the start date for a reporting period based on type and anchor date.
  DateTime _getPeriodStart(ReportPeriodType periodType, DateTime anchorDate) {
    if (periodType == ReportPeriodType.week) {
      return anchorDate.subtract(Duration(days: anchorDate.weekday - 1));
    } else if (periodType == ReportPeriodType.month) {
      return DateTime(anchorDate.year, anchorDate.month, 1);
    } else if (periodType == ReportPeriodType.year) {
      return DateTime(anchorDate.year, 1, 1);
    }
    throw UnsupportedError('Unsupported periodType: $periodType');
  }

  /// Sums the amount for all transactions of the given type.
  double _sumAmountByType(
    TransactionType type,
    List<TransactionEntity> transactions,
  ) {
    return transactions
        .where((item) => item.type.name == type.name)
        .fold<double>(0, (sum, item) => sum + item.amount);
  }

  /// Generates bucket intervals (daily/monthly/weekly) with associated internal and display labels for breakdowns.
  List<_Bucket> _generateBuckets(
    DateTime from,
    DateTime to,
    ReportBreakdownType breakdownType,
  ) {
    final List<_Bucket> buckets = [];
    DateTime bucketStart = from;

    while (!bucketStart.isAfter(to)) {
      late DateTime bucketEnd;
      late String internalLabel;
      late String displayLabel;

      if (breakdownType == ReportBreakdownType.day) {
        // Internal: 2026-04-16
        // Display: 16 Apr or Thu
        bucketEnd = DateTime(
          bucketStart.year,
          bucketStart.month,
          bucketStart.day,
          23,
          59,
          59,
        );

        // Format date as yyyy-MM-dd
        internalLabel =
            '${bucketStart.year}-${bucketStart.month.toString().padLeft(2, '0')}-${bucketStart.day.toString().padLeft(2, '0')}';
        // Format display as '16 Apr'
        final day = bucketStart.day.toString().padLeft(2, '0');
        final month = MoneyFlowDateUtils.monthShortName(
          bucketStart.month,
        ); // Helper below
        displayLabel = '$day $month';
        // Optionally, use weekday: bucketStart.weekday (1=Mon, 7=Sun)
        // final weekday = _weekdayShortName(bucketStart.weekday);

        buckets.add(
          _Bucket(
            key: internalLabel,
            label: displayLabel,
            start: DateTime(
              bucketStart.year,
              bucketStart.month,
              bucketStart.day,
              0,
              0,
              0,
            ),
            end: bucketEnd,
          ),
        );
        bucketStart = bucketStart.add(const Duration(days: 1));
      } else if (breakdownType == ReportBreakdownType.month) {
        // Internal: 2026-04
        // Display: Apr
        final nextMonth = DateTime(bucketStart.year, bucketStart.month + 1, 1);
        bucketEnd = nextMonth.subtract(const Duration(seconds: 1));
        if (bucketEnd.isAfter(to)) {
          bucketEnd = DateTime(to.year, to.month, to.day, 23, 59, 59);
        }
        internalLabel =
            '${bucketStart.year}-${bucketStart.month.toString().padLeft(2, '0')}';
        displayLabel = MoneyFlowDateUtils.monthShortName(bucketStart.month);

        buckets.add(
          _Bucket(
            key: internalLabel,
            label: displayLabel,
            start: DateTime(bucketStart.year, bucketStart.month, 1, 0, 0, 0),
            end: bucketEnd,
          ),
        );
        bucketStart = nextMonth;
      } else if (breakdownType == ReportBreakdownType.week) {
        // Internal: 2026-W16
        // Display: Week 3 (relative week from start)
        // Find ISO week number. Optionally, shift display to "Week N" in range.

        // ISO 8601: weeks start on Monday and the first week has the year's first Thursday
        int weekNumber = MoneyFlowDateUtils.isoWeekNumber(bucketStart);
        internalLabel =
            '${bucketStart.year}-W${weekNumber.toString().padLeft(2, '0')}';

        // Calculate relative week (1, 2, 3...) from 'from' date:
        int weekDelta =
            bucketStart.difference(from).inDays ~/ 7 + 1; // start from 1

        displayLabel = 'Week $weekDelta';

        // From weekStart Monday to Sunday
        final weekStart = bucketStart.subtract(
          Duration(days: bucketStart.weekday - 1),
        ); // Monday
        final weekEnd = weekStart.add(
          Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
        );
        bucketEnd = weekEnd.isAfter(to)
            ? DateTime(to.year, to.month, to.day, 23, 59, 59)
            : weekEnd;

        buckets.add(
          _Bucket(
            key: internalLabel,
            label: displayLabel,
            start: DateTime(
              weekStart.year,
              weekStart.month,
              weekStart.day,
              0,
              0,
              0,
            ),
            end: bucketEnd,
          ),
        );
        bucketStart = bucketEnd.add(const Duration(seconds: 1));
      } else {
        throw UnsupportedError('Unsupported breakdown type: $breakdownType');
      }
    }
    return buckets;
  }
}
