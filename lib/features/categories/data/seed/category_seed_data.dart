import 'dart:ui';

import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/entity/transaction_type.dart';
import 'package:expense_tracker/features/categories/domain/entity/category_entity.dart';

abstract final class CategorySeedData {
  static List<CategoryEntity> buildDefaultCategories() {
    return [
      CategoryEntity(
        id: 'expense_food',
        name: 'Food',
        type: TransactionType.expense,
        colorValue: AppColors.primary.value, // emerald-500
        iconName: 'utensils',
        isDefault: true,
      ),
      CategoryEntity(
        id: 'expense_transport',
        name: 'Transport',
        type: TransactionType.expense,
        colorValue: AppColors.info.value, // blue-500
        iconName: 'car',
        isDefault: true,
      ),
      CategoryEntity(
        id: 'expense_shopping',
        name: 'Shopping',
        type: TransactionType.expense,
        colorValue: const Color(
          0xFF8B5CF6,
        ).value, // violet-500; define in tokens if used elsewhere
        iconName: 'shoppingBag',
        isDefault: true,
      ),
      CategoryEntity(
        id: 'expense_housing',
        name: 'Housing',
        type: TransactionType.expense,
        colorValue: AppColors.warning.value, // amber-500
        iconName: 'house',
        isDefault: true,
      ),
      CategoryEntity(
        id: 'expense_entertainment',
        name: 'Entertainment',
        type: TransactionType.expense,
        colorValue: const Color(
          0xFFEC4899,
        ).value, // pink-500; define in tokens if used elsewhere
        iconName: 'film',
        isDefault: true,
      ),
      CategoryEntity(
        id: 'expense_health',
        name: 'Health',
        type: TransactionType.expense,
        colorValue: AppColors.error.value, // red-500
        iconName: 'heart',
        isDefault: true,
      ),
      CategoryEntity(
        id: 'expense_bills',
        name: 'Bills',
        type: TransactionType.expense,
        colorValue: const Color(
          0xFFF97316,
        ).value, // orange-500; define in tokens if used elsewhere
        iconName: 'zap',
        isDefault: true,
      ),
      CategoryEntity(
        id: 'expense_other',
        name: 'Other',
        type: TransactionType.expense,
        colorValue: AppColors.slate500.value, // neutral; slate-500
        iconName: 'layoutGrid',
        isDefault: true,
      ),
      CategoryEntity(
        id: 'income_salary',
        name: 'Salary',
        type: TransactionType.income,
        colorValue: AppColors.income.value, // emerald-500
        iconName: 'banknote',
        isDefault: true,
      ),
      CategoryEntity(
        id: 'income_freelance',
        name: 'Freelance',
        type: TransactionType.income,
        colorValue: const Color(
          0xFF14B8A6,
        ).value, // teal-500; define in tokens if used elsewhere
        iconName: 'briefcase',
        isDefault: true,
      ),
      CategoryEntity(
        id: 'income_bonus',
        name: 'Bonus',
        type: TransactionType.income,
        colorValue: const Color(
          0xFF6366F1,
        ).value, // indigo-500; define in tokens if used elsewhere
        iconName: 'gift',
        isDefault: true,
      ),
      CategoryEntity(
        id: 'income_other',
        name: 'Other',
        type: TransactionType.income,
        colorValue: const Color(
          0xFF84CC16,
        ).value, // lime-500; define in tokens if used elsewhere
        iconName: 'layoutGrid',
        isDefault: true,
      ),
    ];
  }
}
