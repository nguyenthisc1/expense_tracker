import 'package:expense_tracker/features/app_lock/domain/entity/app_lock_setting_entity.dart';
import 'package:expense_tracker/features/app_lock/domain/entity/app_lock_status.dart';
import 'package:expense_tracker/features/app_lock/domain/usecase/get_app_lock_setting_usecase.dart';
import 'package:expense_tracker/features/app_lock/domain/usecase/verify_pin_lock_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_lock_state.dart';

class AppLockCubit extends Cubit<AppLockState> {
  final GetAppLockSettingsUsecase _getAppLockSettingsUsecase;
  final VerifyPinLockUsecase _verifyPinLockUsecase;

  AppLockCubit({
    required GetAppLockSettingsUsecase getAppLockSettingsUsecase,
    required VerifyPinLockUsecase verifyPinLockUsecase,
  }) : _getAppLockSettingsUsecase = getAppLockSettingsUsecase,
       _verifyPinLockUsecase = verifyPinLockUsecase,
       super(AppLockState.initial());

  Future<void> initialize() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final settings = await _getAppLockSettingsUsecase();
      emit(
        state.copyWith(
          isLoading: false,
          settings: settings,
          status: _statusFromSettings(settings),
          clearError: true,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<bool> unlock(String pin) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final isValid = await _verifyPinLockUsecase(pin);
      if (isValid) {
        emit(
          state.copyWith(
            isLoading: false,
            status: AppLockStatus.unlocked,
            clearError: true,
          ),
        );
        return true;
      }

      emit(
        state.copyWith(
          isLoading: false,
          status: AppLockStatus.locked,
          errorMessage: 'Incorrect PIN. Try again.',
        ),
      );
      return false;
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          status: AppLockStatus.locked,
          errorMessage: error.toString(),
        ),
      );
      return false;
    }
  }

  void lock() {
    final settings = state.settings;
    if (settings == null) return;
    emit(
      state.copyWith(
        status: _statusFromSettings(settings),
        clearError: true,
      ),
    );
  }

  void refreshFromSettings(AppLockSettingsEntity settings) {
    final nextStatus = _statusFromSettings(
      settings,
      keepUnlocked: state.status != AppLockStatus.locked,
    );

    emit(
      state.copyWith(
        settings: settings,
        status: nextStatus,
        clearError: true,
      ),
    );
  }

  AppLockStatus _statusFromSettings(
    AppLockSettingsEntity settings, {
    bool keepUnlocked = false,
  }) {
    if (!settings.isPinEnabled || !settings.hasPin) {
      return AppLockStatus.disabled;
    }

    if (keepUnlocked) {
      return AppLockStatus.unlocked;
    }

    return AppLockStatus.locked;
  }
}
