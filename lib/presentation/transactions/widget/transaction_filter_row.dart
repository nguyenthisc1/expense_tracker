import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class TransactionFilterRow extends StatelessWidget {
  const TransactionFilterRow({
    super.key,
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<String> filters;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final isSelected = selected == index;
          final isLast = index == filters.length - 1;
          return GestureDetector(
            onTap: () => onSelected(index),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceLight,
                borderRadius: AppRadius.radiusFull,
                border: isSelected
                    ? null
                    : Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filters[index],
                    style: AppTypography.labelMedium.copyWith(
                      color: isSelected
                          ? AppColors.onPrimary
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  if (isLast) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      LucideIcons.chevronDown,
                      size: 14,
                      color: isSelected
                          ? AppColors.onPrimary
                          : AppColors.textSecondaryLight,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
