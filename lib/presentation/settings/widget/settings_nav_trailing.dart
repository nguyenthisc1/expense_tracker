import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

class SettingsNavTrailing extends StatelessWidget {
  const SettingsNavTrailing({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        const Icon(
          LucideIcons.chevronRight,
          size: 18,
          color: AppColors.textSecondaryLight,
        ),
      ],
    );
  }
}
