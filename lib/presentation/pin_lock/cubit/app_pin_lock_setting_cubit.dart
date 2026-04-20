import 'package:expense_tracker/features/app_lock/domain/usecase/change_pin_lock_usecase.dart';
import 'package:expense_tracker/features/app_lock/domain/usecase/disable_pin_lock_usecase.dart';
import 'package:expense_tracker/features/app_lock/domain/usecase/enable_pin_lock_usecase.dart';
import 'package:expense_tracker/features/app_lock/domain/usecase/get_app_lock_setting_usecase.dart';
import 'package:expense_tracker/features/app_lock/domain/usecase/verify_pin_lock_usecase.dart';
import 'package:expense_tracker/presentation/pin_lock/cubit/app_pin_lock_setting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppPinLockSettingCubit extends Cubit<AppPinLockSettingState> {
  final EnablePinLockUsecase _enablePinLockUsecase;
  final DisablePinLockUsecase _disablePinLockUsecase;
  final ChangePinLockUsecase _changePinLockUsecase;
  final GetAppLockSettingsUsecase _getAppLockSettingsUsecase;
  final VerifyPinLockUsecase _verifyPinLockUsecase;

  AppPinLockSettingCubit({
    required EnablePinLockUsecase enablePinLockUsecase,
    required DisablePinLockUsecase disablePinLockUsecase,
    required GetAppLockSettingsUsecase getAppLockSettingsUsecase,
    required ChangePinLockUsecase changePinLockUsecase,
    required VerifyPinLockUsecase verifyPinLockUsecase,
  }) : _verifyPinLockUsecase = verifyPinLockUsecase,
       _changePinLockUsecase = changePinLockUsecase,
       _enablePinLockUsecase = enablePinLockUsecase,
       _disablePinLockUsecase = disablePinLockUsecase,
       _getAppLockSettingsUsecase = getAppLockSettingsUsecase,
       super(AppPinLockSettingState.initial());

  Future<void> loadAppLockSettings() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final settings = await _getAppLockSettingsUsecase();
      emit(
        state.copyWith(isLoading: false, clearError: true, settings: settings),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<void> enableAppPinSetting(String pin) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final settings = await _enablePinLockUsecase(pin);
      emit(
        state.copyWith(isLoading: false, clearError: true, settings: settings),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<void> disableAppPinSetting() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final settings = await _disablePinLockUsecase();
      emit(
        state.copyWith(isLoading: false, clearError: true, settings: settings),
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<void> changeAppPin(String oldPin, String newPin) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      await _changePinLockUsecase(oldPin, newPin);

      emit(state.copyWith(isLoading: false, clearError: true));
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
    }
  }

  Future<bool> verifyPin(String pin) async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));
      final isVerifying = await _verifyPinLockUsecase(pin);
      emit(
        state.copyWith(
          isLoading: false,
          clearError: isVerifying,
          errorMessage: isVerifying ? null : state.errorMessage,
        ),
      );
      return isVerifying;
    } catch (error) {
      emit(state.copyWith(isLoading: false, errorMessage: error.toString()));
      return false;
    }
  }
}
