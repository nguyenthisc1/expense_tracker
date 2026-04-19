class AppLockSettingsEntity {
  final bool isPinEnabled;
  final bool hasPin;
  final bool isBiometricEnabled;

  const AppLockSettingsEntity({
    required this.isPinEnabled,
    required this.hasPin,
    required this.isBiometricEnabled,
  });

  AppLockSettingsEntity copyWith({
    bool? isPinEnabled,
    bool? hasPin,
    bool? isBiometricEnabled,
  }) {
    return AppLockSettingsEntity(
      isPinEnabled: isPinEnabled ?? this.isPinEnabled,
      hasPin: hasPin ?? this.hasPin,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }
}
