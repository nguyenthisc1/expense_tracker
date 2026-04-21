import 'package:expense_tracker/features/app_lock/domain/entity/app_lock_setting_entity.dart';

class AppPinLockSettingState {
  final bool isLoading;
  final String? errorMessage;
  final AppLockSettingsEntity? settings;

  const AppPinLockSettingState({
    required this.isLoading,
    this.errorMessage,
    required this.settings,
  });

  factory AppPinLockSettingState.initial() {
    return AppPinLockSettingState(
      isLoading: false,
      errorMessage: null,
      settings: null,
    );
  }

  AppPinLockSettingState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    AppLockSettingsEntity? settings,
  }) {
    return AppPinLockSettingState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      settings: settings ?? this.settings,
    );
  }
}
