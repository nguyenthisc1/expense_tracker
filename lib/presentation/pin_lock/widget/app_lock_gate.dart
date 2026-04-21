import 'package:expense_tracker/features/app_lock/domain/entity/app_lock_status.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_lock_cubit.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_lock_state.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_pin_lock_setting_cubit.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_pin_lock_setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../page/pin_lock_page.dart';

class AppLockGate extends StatelessWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppPinLockSettingCubit, AppPinLockSettingState>(
          listenWhen: (previous, current) => previous.settings != current.settings,
          listener: (context, state) {
            final settings = state.settings;
            if (settings != null) {
              context.read<AppLockCubit>().refreshFromSettings(settings);
            }
          },
        ),
      ],
      child: BlocBuilder<AppLockCubit, AppLockState>(
        builder: (context, state) {
          final showLockScreen = state.status == AppLockStatus.locked;

          return Stack(
            children: [
              child,
              if (showLockScreen)
                Positioned.fill(
                  child: PinLockPage(
                    onVerifyPin: (pin) => context.read<AppLockCubit>().unlock(pin),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
