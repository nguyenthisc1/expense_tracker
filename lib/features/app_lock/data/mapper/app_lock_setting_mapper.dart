import 'package:expense_tracker/features/app_lock/data/model/app_lock_setting_model.dart';
import 'package:expense_tracker/features/app_lock/domain/entity/app_lock_setting_entity.dart';

class AppLockSettingMapper {
  const AppLockSettingMapper._();

  static AppLockSettingsEntity toEntity(AppLockSettingsModel model) {
    return AppLockSettingsEntity(
      isPinEnabled: model.isPinEnabled,
      hasPin: model.hasPin,
      isBiometricEnabled: model.isBiometricEnabled,
    );
  }

  static AppLockSettingsModel toModel(AppLockSettingsEntity entity) {
    return AppLockSettingsModel(
      isPinEnabled: entity.isPinEnabled,
      hasPin: entity.hasPin,
      isBiometricEnabled: entity.isBiometricEnabled,
    );
  }
}
