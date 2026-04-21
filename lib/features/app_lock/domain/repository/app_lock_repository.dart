import 'package:expense_tracker/features/app_lock/domain/entity/app_lock_setting_entity.dart';

abstract interface class AppLockRepository {
  Future<AppLockSettingsEntity> enablePinLock(String pin);
  Future<AppLockSettingsEntity> disablePinLock();
  Future<bool> verifyPin(String pin);
  Future<void> changePin(String oldPin, String newPin);
  Future<AppLockSettingsEntity> getAppLockSettings();
  Future<void> updateBiometricEnabled(bool enabled);
}
