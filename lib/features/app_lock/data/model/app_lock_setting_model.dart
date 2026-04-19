class AppLockSettingsModel {
  final bool isPinEnabled;
  final bool hasPin;
  final bool isBiometricEnabled;

  const AppLockSettingsModel({
    required this.isPinEnabled,
    required this.hasPin,
    required this.isBiometricEnabled,
  });

  Map<String, dynamic> toJson() {
    return {
      'isPinEnabled': isPinEnabled,
      'hasPin': hasPin,
      'isBiometricEnabled': isBiometricEnabled,
    };
  }

  factory AppLockSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppLockSettingsModel(
      isPinEnabled: json['isPinEnabled'],
      hasPin: json['hasPin'],
      isBiometricEnabled: json['isBiometricEnabled'],
    );
  }

  AppLockSettingsModel copyWith({
    bool? isPinEnabled,
    bool? hasPin,
    bool? isBiometricEnabled,
  }) {
    return AppLockSettingsModel(
      isPinEnabled: isPinEnabled ?? this.isPinEnabled,
      hasPin: hasPin ?? this.hasPin,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }
}
