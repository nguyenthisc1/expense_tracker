import 'package:expense_tracker/core/constants/app_colors.dart';
import 'package:expense_tracker/core/constants/app_durations.dart';
import 'package:expense_tracker/core/constants/app_icons.dart';
import 'package:expense_tracker/core/constants/app_radius.dart';
import 'package:expense_tracker/core/constants/app_spacing.dart';
import 'package:expense_tracker/core/constants/app_typography.dart';
import 'package:expense_tracker/core/di/injection.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_lock_cubit.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_pin_lock_setting_cubit.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/pin_entry_cubit.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/pin_entry_state.dart';
import 'package:expense_tracker/presentation/pin_lock/widget/pin_dot_indicator.dart';
import 'package:expense_tracker/presentation/pin_lock/widget/pin_keypad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class PinEntrySheet extends StatefulWidget {
  const PinEntrySheet({super.key, required this.mode});

  final PinSheetMode mode;

  @override
  State<PinEntrySheet> createState() => PinEntrySheetState();
}

class PinEntrySheetState extends State<PinEntrySheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: AppDurations.standard,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -10), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -10, end: 10), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 10, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Step title/subtitle helpers
  // ---------------------------------------------------------------------------

  String _title(PinEntryState state) {
    switch (state.mode) {
      case PinSheetMode.setup:
        return state.step == 0 ? 'Create PIN' : 'Confirm PIN';
      case PinSheetMode.change:
        if (state.step == 0) return 'Enter Current PIN';
        if (state.step == 1) return 'Enter New PIN';
        return 'Confirm New PIN';
      case PinSheetMode.disable:
        return 'Enter Current PIN';
    }
  }

  String _subtitle(PinEntryState state) {
    switch (state.mode) {
      case PinSheetMode.setup:
        return state.step == 0
            ? 'Choose a 4-digit PIN to protect your app'
            : 'Re-enter your PIN to confirm';
      case PinSheetMode.change:
        if (state.step == 0) return 'Enter your existing PIN to continue';
        if (state.step == 1) return 'Choose a new 4-digit PIN';
        return 'Re-enter your new PIN to confirm';
      case PinSheetMode.disable:
        return 'Enter your PIN to disable the lock';
    }
  }

  int _totalSteps(PinEntryState state) {
    switch (state.mode) {
      case PinSheetMode.setup:
        return 2;
      case PinSheetMode.change:
        return 3;
      case PinSheetMode.disable:
        return 1;
    }
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final sheetNavigator = Navigator.maybeOf(context);

    return BlocProvider(
      create: (_) => sl<PinEntryCubit>()..initialize(widget.mode),
      child: BlocConsumer<PinEntryCubit, PinEntryState>(
        listener: (context, state) async {
          if (state.errorMessage != null) {
            _shakeController.forward(from: 0);
          }

          if (!state.isCompleted) return;

          final settingCubit = context.read<AppPinLockSettingCubit>();
          switch (state.mode) {
            case PinSheetMode.setup:
              await settingCubit.enableAppPinSetting(state.newPinInput);
              break;
            case PinSheetMode.change:
              await settingCubit.changeAppPin(
                state.currentPinInput,
                state.newPinInput,
              );
              break;
            case PinSheetMode.disable:
              final isVerifying = await settingCubit.verifyPin(
                state.currentPinInput,
              );
              if (isVerifying) {
                await settingCubit.disableAppPinSetting();
              } else {
                if (!context.mounted) return;
                context.read<PinEntryCubit>().showError(
                  'Incorrect PIN. Try again.',
                );
                return;
              }
              break;
          }

          if (!mounted || settingCubit.state.errorMessage != null) return;
          final settings = settingCubit.state.settings;
          if (settings != null && context.mounted) {
            context.read<AppLockCubit>().refreshFromSettings(settings);
          }
          sheetNavigator?.pop(true);
        },
        builder: (context, state) {
          final totalSteps = _totalSteps(state);
          final hasError = state.errorMessage != null;

          return Container(
            margin: const EdgeInsets.only(top: AppSpacing.xl),
            padding: EdgeInsets.only(bottom: bottomPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSpacing.xl),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: AppSpacing.md),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.slate300,
                      borderRadius: AppRadius.radiusFull,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.lg),
                    ),
                    child: Icon(
                      LucideIcons.keyRound,
                      size: AppIcons.xl2,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (totalSteps > 1) ...[
                    _StepPills(total: totalSteps, current: state.step),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  AnimatedSwitcher(
                    duration: AppDurations.standard,
                    child: Column(
                      key: ValueKey('step_${state.step}_${state.mode.name}'),
                      children: [
                        Text(_title(state), style: AppTypography.headlineSmall),
                        const SizedBox(height: AppSpacing.xs),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl2,
                          ),
                          child: Text(
                            _subtitle(state),
                            style: AppTypography.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) => Transform.translate(
                      offset: Offset(_shakeAnimation.value, 0),
                      child: child,
                    ),
                    child: PinDotIndicator(
                      filledCount: state.digits,
                      hasError: hasError,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  AnimatedSwitcher(
                    duration: AppDurations.fast,
                    child: hasError
                        ? Text(
                            state.errorMessage!,
                            key: const ValueKey('error'),
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.error,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(key: ValueKey('no-error'), height: 18),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl2,
                    ),
                    child: PinKeypad(
                      onDigitPressed: context.read<PinEntryCubit>().onDigit,
                      onBackspacePressed: context
                          .read<PinEntryCubit>()
                          .onBackspace,
                      enabled: !state.isLoading,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step pills indicator
// ---------------------------------------------------------------------------

class _StepPills extends StatelessWidget {
  const _StepPills({required this.total, required this.current});

  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: _StepPill(active: index == current),
        );
      }),
    );
  }
}

class _StepPill extends StatelessWidget {
  const _StepPill({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppDurations.standard,
      width: active ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.primary : AppColors.slate300,
        borderRadius: AppRadius.radiusFull,
      ),
    );
  }
}
