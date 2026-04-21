import 'package:expense_tracker/features/app_lock/data/model/app_lock_setting_model.dart';
import 'package:expense_tracker/features/app_lock/data/model/pin_credential_model.dart';

// abstract interface class AppLockLocalDatasource {
//   Future<void> enablePinLock(String pin);
//   Future<void> disablePinLock();
//   Future<bool> verifyPin(String pin);
//   Future<void> changePin(String oldPin, String newPin);
//   Future<AppLockSettingsModel> getAppLockSettings();
//   Future<void> updateBiometricEnabled(bool enabled);
// }

abstract interface class AppLockLocalDatasource {
  Future<PinCredentialModel> savePinCredential(PinCredentialModel credential);
  Future<PinCredentialModel?> getPinCredential();
  Future<void> deletePinCredential();

  Future<AppLockSettingsModel> saveAppLockSettings(
    AppLockSettingsModel settings,
  );
  Future<AppLockSettingsModel> getAppLockSettings();
}
