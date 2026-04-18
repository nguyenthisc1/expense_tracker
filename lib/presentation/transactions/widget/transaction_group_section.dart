import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../features/transactions/domain/entity/transaction_entity.dart';
import 'transaction_history_item.dart';
import 'transaction_view_data.dart';

class TransactionGroupSection extends StatelessWidget {
  const TransactionGroupSection({
    super.key,
    required this.group,
    required this.onTapTransaction,
  });

  final TransactionDateGroup group;
  final ValueChanged<TransactionEntity> onTapTransaction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.base,
            bottom: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Text(group.date, style: AppTypography.headlineSmall),
              const SizedBox(width: AppSpacing.sm),
              Text(group.dateLabel, style: AppTypography.labelSmall),
            ],
          ),
        ),
        ...List.generate(group.items.length, (index) {
          final item = group.items[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index < group.items.length - 1 ? AppSpacing.sm : 0,
            ),
            child: GestureDetector(
              onTap: () => onTapTransaction(item.transaction),
              child: TransactionHistoryItem(data: item),
            ),
          );
        }),
        const SizedBox(height: AppSpacing.base),
      ],
    );
  }
}
