import 'package:expense_tracker/core/di/injection.dart';
import 'package:expense_tracker/core/utils/extensions.dart';
import 'package:expense_tracker/core/utils/currency_utils.dart';
import 'package:expense_tracker/core/widgets/error_view.dart';
import 'package:expense_tracker/core/widgets/loading_indicator.dart';
import 'package:expense_tracker/features/export/domain/usecase/export_report_pdf_usecase.dart';
import 'package:expense_tracker/features/export/domain/usecase/export_transaction_csv_usecase.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_breakdown_type.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_period_type.dart';
import 'package:expense_tracker/features/reports/domain/entity/report_types.dart';
import 'package:expense_tracker/features/reports/domain/usecase/get_detailed_report_usecase.dart';
import 'package:expense_tracker/features/transactions/domain/usecase/get_transactions_usecase.dart';
import 'package:expense_tracker/presentation/settings/cubit/setting_cubit.dart';
import 'package:expense_tracker/presentation/settings/cubit/setting_state.dart';
import 'package:expense_tracker/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../widget/settings_export_action_sheet.dart';
import '../widget/settings_nav_trailing.dart';
import '../widget/settings_section.dart';
import '../widget/settings_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> _currencies = ['USD', 'VND', 'EUR', 'GBP', 'JPY', 'INR'];

  final List<String> _languages = [
    'English',
    'Vietnamese',
    'Spanish',
    'French',
    'German',
    'Chinese',
  ];

  bool _isExporting = false;

  void _showCurrencyDialog(SettingsState state, BuildContext context) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Currency'),
          children: [
            ..._currencies.map(
              (currency) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, currency),
                child: Text(
                  _currencyDisplay(currency),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: currency == state.settings.currencyCode
                        ? AppColors.primary
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;
    if (selected != null && selected != state.settings.currencyCode) {
      context.read<SettingsCubit>().saveSettings(
        state.settings.copyWith(currencyCode: selected),
      );
    }
  }

  void _showLanguageDialog(SettingsState state, BuildContext context) async {
    final selected = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Language'),
          children: [
            ..._languages.map(
              (language) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, language),
                child: Text(
                  language,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: language == state.settings.locale
                        ? AppColors.primary
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;
    if (selected != null && selected != state.settings.locale) {
      context.read<SettingsCubit>().saveSettings(
        state.settings.copyWith(locale: selected),
      );
    }
  }

  Future<void> _handleExportPressed(BuildContext context) async {
    if (_isExporting) return;

    final action = await showModalBottomSheet<SettingsExportAction>(
      context: context,
      showDragHandle: true,
      builder: (_) => const SettingsExportActionSheet(),
    );

    if (!context.mounted || action == null) return;

    setState(() => _isExporting = true);

    try {
      final path = switch (action) {
        SettingsExportAction.transactionsCsv => await _exportTransactionsCsv(),
        SettingsExportAction.currentMonthPdf => await _exportCurrentMonthPdf(),
      };

      print(path);

      if (!context.mounted) return;
      context.showSnackBar('Exported successfully: $path');
    } catch (error) {
      if (!context.mounted) return;
      context.showSnackBar(error.toString(), isError: true);
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Future<String> _exportTransactionsCsv() async {
    final transactions = await sl<GetTransactionsUsecase>()();
    return sl<ExportTransactionCsvUseCase>()(transactions);
  }

  Future<String> _exportCurrentMonthPdf() async {
    final report = await sl<GetDetailedReportUsecase>()(
      DetailedReportParams(
        periodType: ReportPeriodType.month,
        anchorDate: DateTime.now(),
        breakdownType: ReportBreakdownType.day,
      ),
    );

    return sl<ExportReportPdfUsecase>()(report);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          context.showSnackBar(state.errorMessage!, isError: true);
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const LoadingIndicator(message: 'Loading information...');
        }

        if (state.errorMessage != null) {
          return ErrorView(message: state.errorMessage);
        }

        return AppScaffold(
          appBar: MoneyFlowAppBar(titleText: 'Settings'),
          body: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.base,
            ),
            children: [
              const SizedBox(height: AppSpacing.base),
              SettingsSection(
                title: 'GENERAL',
                tiles: [
                  SettingsTile(
                    icon: LucideIcons.banknote,
                    title: 'Currency',
                    trailing: SettingsNavTrailing(
                      value: _currencyDisplay(state.settings.currencyCode),
                    ),
                    onTap: () => _showCurrencyDialog(state, context),
                  ),
                  SettingsTile(
                    icon: LucideIcons.globe,
                    title: 'Language',
                    trailing: SettingsNavTrailing(value: state.settings.locale),
                    onTap: () => _showLanguageDialog(state, context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SettingsSection(
                title: 'SECURITY',
                tiles: [
                  SettingsTile(
                    icon: LucideIcons.keyRound,
                    title: 'PIN',
                    trailing: const Icon(
                      LucideIcons.chevronRight,
                      size: 18,
                      color: AppColors.textSecondaryLight,
                    ),
                    onTap: () => context.push(AppRoutes.pin),
                  ),
                ],
              ),
              // const SizedBox(height: AppSpacing.md),
              // SettingsSection(
              //   title: 'NOTIFICATIONS',
              //   tiles: [
              //     SettingsTile(
              //       icon: LucideIcons.bell,
              //       title: 'Daily Reminders',
              //       subtitle: 'Morning summary',
              //       trailing: const Icon(
              //         LucideIcons.chevronRight,
              //         size: 18,
              //         color: AppColors.textSecondaryLight,
              //       ),
              //       onTap: () {},
              //     ),
              //     SettingsTile(
              //       icon: LucideIcons.triangleAlert,
              //       title: 'Budget Alerts',
              //       subtitle: 'At 80% limit',
              //       trailing: const Icon(
              //         LucideIcons.chevronRight,
              //         size: 18,
              //         color: AppColors.textSecondaryLight,
              //       ),
              //       onTap: () {},
              //     ),
              //   ],
              // ),
              const SizedBox(height: AppSpacing.md),
              SettingsSection(
                title: 'DATA & PRIVACY',
                tiles: [
                  SettingsTile(
                    icon: LucideIcons.download,
                    title: 'Export Data (CSV/PDF)',
                    subtitle: _isExporting
                        ? 'Preparing file...'
                        : 'Transactions CSV or current month report PDF',
                    trailing: _isExporting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            LucideIcons.chevronRight,
                            size: 18,
                            color: AppColors.textSecondaryLight,
                          ),
                    onTap: () => _handleExportPressed(context),
                  ),
                  SettingsTile(
                    icon: LucideIcons.trash2,
                    title: 'Clear All Data',
                    trailing: const Icon(
                      LucideIcons.chevronRight,
                      size: 18,
                      color: AppColors.textSecondaryLight,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _currencyDisplay(String currencyCode) {
    final symbol = CurrencyUtils.symbolForCurrency(currencyCode);
    return '$currencyCode ($symbol)';
  }
}
