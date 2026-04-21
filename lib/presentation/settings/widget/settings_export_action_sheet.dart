import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';

const _sheetPadding = EdgeInsets.fromLTRB(
  AppSpacing.base,
  0,
  AppSpacing.base,
  AppSpacing.xl,
);

enum SettingsExportAction { transactionsCsv, currentMonthPdf }

class SettingsExportActionSheet extends StatelessWidget {
  const SettingsExportActionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: _sheetPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Export Data', style: AppTypography.headlineSmall),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Choose the file you want to generate from your local data.',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ExportOptionTile(
              icon: LucideIcons.sheet,
              title: 'Transactions CSV',
              subtitle: 'Export all transactions as a spreadsheet-friendly file',
              onTap: () => Navigator.of(context).pop(
                SettingsExportAction.transactionsCsv,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _ExportOptionTile(
              icon: LucideIcons.fileText,
              title: 'Current Month Report PDF',
              subtitle: 'Export this month summary and category breakdown',
              onTap: () => Navigator.of(context).pop(
                SettingsExportAction.currentMonthPdf,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportOptionTile extends StatelessWidget {
  const _ExportOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.bodyMedium),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                LucideIcons.chevronRight,
                size: 18,
                color: AppColors.textSecondaryLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
