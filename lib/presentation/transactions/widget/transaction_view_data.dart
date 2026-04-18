import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/entity/transaction_type.dart';
import '../../../core/utils/date_utils.dart';
import '../../../features/categories/domain/entity/category_entity.dart';
import '../../../features/transactions/domain/entity/transaction_entity.dart';

class TransactionDateGroup {
  const TransactionDateGroup({
    required this.date,
    required this.dateLabel,
    required this.items,
  });

  final String date;
  final String dateLabel;
  final List<TransactionViewData> items;
}

class TransactionViewData {
  const TransactionViewData({
    required this.transaction,
    required this.category,
  });

  final TransactionEntity transaction;
  final CategoryEntity? category;

  String get subtitle {
    final categoryName = category?.name ?? 'Uncategorized';
    final time = MoneyFlowDateUtils.formatTime(transaction.date);
    return '$categoryName • $time';
  }

  IconData get icon {
    switch (category?.iconName) {
      case 'utensils':
        return LucideIcons.utensils;
      case 'car':
        return LucideIcons.car;
      case 'shoppingBag':
        return LucideIcons.shoppingBag;
      case 'banknote':
        return LucideIcons.banknote;
      case 'briefcase':
        return LucideIcons.briefcase;
      case 'layoutGrid':
        return LucideIcons.layoutGrid;
      default:
        return transaction.type == TransactionType.income
            ? LucideIcons.banknote
            : LucideIcons.receipt;
    }
  }

  Color get iconColor => category != null
      ? Color(category!.colorValue)
      : transaction.type == TransactionType.income
          ? AppColors.income
          : AppColors.expense;
}
