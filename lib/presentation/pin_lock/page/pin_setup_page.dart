import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/constants/app_durations.dart';
import 'package:expense_tracker/core/constants/app_icons.dart';
import 'package:expense_tracker/core/constants/app_radius.dart';
import 'package:expense_tracker/core/constants/app_shadows.dart';
import 'package:expense_tracker/core/constants/app_spacing.dart';
import 'package:expense_tracker/core/constants/app_typography.dart';
import 'package:expense_tracker/core/utils/extensions.dart';
import 'package:expense_tracker/core/widgets/app_scaffold.dart';
import 'package:expense_tracker/core/widgets/loading_indicator.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_lock_cubit.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_lock_state.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_pin_lock_setting_cubit.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_pin_lock_setting_state.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/pin_entry_state.dart';
import 'package:expense_tracker/presentation/pin_lock/widget/pin_entry_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({super.key});

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  Future<void> _showPinSheet(PinSheetMode mode) async {
    final success = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PinEntrySheet(mode: mode),
    );
    if (!mounted || success != true) return;
  }

  void _onToggle(bool value) {
    _showPinSheet(value ? PinSheetMode.setup : PinSheetMode.disable);
  }

  void _onDeletePin() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove PIN'),
        content: const Text(
          'Are you sure you want to remove your PIN lock? Your app will no longer be protected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppPinLockSettingCubit, AppPinLockSettingState>(
      listener: (BuildContext context, AppPinLockSettingState state) {
        if (state.errorMessage != null) {
          context.showSnackBar(state.errorMessage!, isError: true);
        }
      },
      builder: (BuildContext context, AppPinLockSettingState state) {
        if (state.isLoading) {
          return const LoadingIndicator(message: 'Loading Infomation...');
        }

        return AppScaffold(
          appBar: MoneyFlowAppBar(titleText: 'PIN Lock'),
          body: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base,
              vertical: AppSpacing.base,
            ),
            children: [
              _StatusCard(),
              const SizedBox(height: AppSpacing.md),
              _CardSection(
                children: [
                  BlocSelector<AppLockCubit, AppLockState, bool>(
                    selector: (AppLockState state) =>
                        state.settings != null &&
                        state.settings!.isPinEnabled == true,

                    builder: (BuildContext context, bool isPinEnabled) {
                      return _SettingRow(
                        icon: LucideIcons.keyRound,
                        title: 'Enable PIN Lock',
                        trailing: Switch(
                          value: isPinEnabled,
                          onChanged: _onToggle,
                          activeColor: AppColors.primary,
                        ),
                      );
                    },
                  ),
                ],
              ),
              if (state.settings?.isPinEnabled ?? false) ...[
                const SizedBox(height: AppSpacing.md),
                _CardSection(
                  children: [
                    _SettingRow(
                      icon: LucideIcons.refreshCw,
                      title: 'Change PIN',
                      trailing: const Icon(
                        LucideIcons.chevronRight,
                        size: AppIcons.sm,
                        color: AppColors.textSecondaryLight,
                      ),
                      onTap: () => _showPinSheet(PinSheetMode.change),
                    ),
                    const Divider(
                      height: 1,
                      indent: AppSpacing.xl2 + AppSpacing.xl,
                    ),
                    // _SettingRow(
                    //   icon: LucideIcons.trash2,
                    //   title: 'Remove PIN',
                    //   iconColor: AppColors.error,
                    //   titleColor: AppColors.error,
                    //   trailing: const Icon(
                    //     LucideIcons.chevronRight,
                    //     size: AppIcons.sm,
                    //     color: AppColors.error,
                    //   ),
                    //   onTap: _onDeletePin,
                    // ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              _HintCard(),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Status card
// ---------------------------------------------------------------------------

class _StatusCard extends StatelessWidget {
  const _StatusCard();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppPinLockSettingCubit, AppPinLockSettingState, bool>(
      selector: (state) => state.settings?.isPinEnabled ?? false,
      builder: (BuildContext context, isPinEnabled) {
        return AnimatedContainer(
          duration: AppDurations.standard,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: isPinEnabled
                ? AppColors.primaryContainer
                : AppColors.slate100,
            borderRadius: AppRadius.card,
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isPinEnabled ? AppColors.primary : AppColors.slate400,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPinEnabled
                      ? LucideIcons.shieldCheck
                      : LucideIcons.shieldOff,
                  size: AppIcons.md,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: AppSpacing.base),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isPinEnabled ? 'PIN Lock Enabled' : 'PIN Lock Disabled',
                      style: AppTypography.titleMedium.copyWith(
                        color: isPinEnabled
                            ? AppColors.primary
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      isPinEnabled
                          ? 'Your app is protected with a PIN'
                          : 'Enable PIN to secure your app',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Hint card
// ---------------------------------------------------------------------------

class _HintCard extends StatelessWidget {
  const _HintCard();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppPinLockSettingCubit, AppPinLockSettingState, bool>(
      selector: (state) => state.settings?.isPinEnabled ?? false,
      builder: (BuildContext context, isPinEnabled) {
        return Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.slate100,
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.slate200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                LucideIcons.info,
                size: AppIcons.md,
                color: AppColors.textSecondaryLight,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  isPinEnabled
                      ? 'Your PIN is required every time you open the app. Keep it somewhere safe.'
                      : 'PIN lock adds an extra layer of security. You will be asked to enter it each time you open MoneyFlow.',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Card section container
// ---------------------------------------------------------------------------

class _CardSection extends StatelessWidget {
  const _CardSection({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.card,
        boxShadow: AppShadows.sm,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

// ---------------------------------------------------------------------------
// Setting row
// ---------------------------------------------------------------------------

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
    this.iconColor,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
        ),
        child: Icon(
          icon,
          size: AppIcons.md,
          color: iconColor ?? AppColors.primary,
        ),
      ),
      title: Text(
        title,
        style: AppTypography.bodyMedium.copyWith(
          color: titleColor ?? AppColors.textPrimaryLight,
        ),
      ),
      trailing: trailing,
    );
  }
}
