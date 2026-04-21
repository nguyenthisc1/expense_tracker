import 'package:expense_tracker/features/app_lock/domain/entity/app_lock_setting_entity.dart';
import 'package:expense_tracker/features/app_lock/domain/entity/app_lock_status.dart';

class AppLockState {
  final bool isLoading;
  final String? errorMessage;
  final AppLockStatus status;
  final AppLockSettingsEntity? settings;

  const AppLockState({
    required this.isLoading,
    required this.errorMessage,
    required this.status,
    required this.settings,
  });

  factory AppLockState.initial() {
    return const AppLockState(
      isLoading: false,
      errorMessage: null,
      status: AppLockStatus.disabled,
      settings: null,
    );
  }

  AppLockState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    AppLockStatus? status,
    AppLockSettingsEntity? settings,
  }) {
    return AppLockState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      status: status ?? this.status,
      settings: settings ?? this.settings,
    );
  }
}
