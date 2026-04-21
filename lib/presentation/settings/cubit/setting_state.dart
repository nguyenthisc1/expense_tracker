import 'package:expense_tracker/features/settings/domain/entity/setting_entity.dart';

class SettingsState {
  final bool isLoading;
  final AppSettingsEntity settings;
  final String? errorMessage;

  const SettingsState({
    required this.isLoading,
    required this.settings,
    required this.errorMessage,
  });

  factory SettingsState.initial() {
    return const SettingsState(
      isLoading: false,
      settings: AppSettingsEntity(
        currencyCode: 'VND',
        locale: 'vi_VN',
        isDarkMode: false,
        firstDayOfWeek: 1,
      ),
      errorMessage: null,
    );
  }

  SettingsState copyWith({
    bool? isLoading,
    AppSettingsEntity? settings,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      settings: settings ?? this.settings,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
