import 'package:expense_tracker/features/settings/data/seed/setting_seed_data.dart';

import '../../features/categories/data/seed/category_seed_data.dart';
import '../../features/categories/domain/entity/category_entity.dart';
import '../../features/categories/domain/repository/category_repository.dart';
import '../../features/settings/domain/repository/setting_repository.dart';
import '../../features/transactions/data/seed/transaction_seed_data.dart';
import '../../features/transactions/domain/repository/transaction_repository.dart';

class AppSeedService {
  const AppSeedService(
    this._settingsRepository,
    this._categoryRepository,
    this._transactionRepository,
  );

  final SettingsRepository _settingsRepository;
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactionRepository;

  Future<void> seedIfEmpty() async {
    await _seedSettingsIfNeeded();
    final categories = await _seedCategoriesIfNeeded();

    if (categories.isEmpty) return;

    await _seedTransactionsIfNeeded(categories);
  }

  Future<void> _seedSettingsIfNeeded() async {
    // Nếu repository của bạn đã tự tạo default settings thì có thể bỏ try/catch này.
    try {
      await _settingsRepository.getSettings();
    } catch (_) {
      await _settingsRepository.updateSettings(
        SettingSeedData.buildDefaultSettings(),
      );
    }
  }

  Future<List<CategoryEntity>> _seedCategoriesIfNeeded() async {
    final existing = await _categoryRepository.getCategories();
    if (existing.isNotEmpty) {
      return existing;
    }

    final defaults = CategorySeedData.buildDefaultCategories();
    for (final category in defaults) {
      await _categoryRepository.addCategory(category);
    }

    return _categoryRepository.getCategories();
  }

  Future<void> _seedTransactionsIfNeeded(
    List<CategoryEntity> categories,
  ) async {
    final existing = await _transactionRepository.getTransactions();
    if (existing.isNotEmpty) {
      return;
    }

    final demoTransactions = TransactionSeedData.buildDemoTransactions(
      now: DateTime.now(),
      categories: categories,
    );

    for (final transaction in demoTransactions) {
      await _transactionRepository.addTransaction(transaction);
    }
  }
}
