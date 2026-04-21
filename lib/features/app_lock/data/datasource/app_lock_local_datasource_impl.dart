import 'dart:convert';

import 'package:expense_tracker/features/app_lock/data/datasource/app_lock_local_datasource.dart';
import 'package:expense_tracker/features/app_lock/data/model/app_lock_setting_model.dart';
import 'package:expense_tracker/features/app_lock/data/model/pin_credential_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppLockLocalDatasourceImpl implements AppLockLocalDatasource {
  static const String _appLockSettingsKey = 'app_lock_settings';
  static const String _appLockPinCredentialKey = 'app_lock_pin_credential';

  final FlutterSecureStorage _storage;

  const AppLockLocalDatasourceImpl(this._storage);

  @override
  Future<void> deletePinCredential() async {
    await _storage.delete(key: _appLockPinCredentialKey);
  }

  @override
  Future<AppLockSettingsModel> getAppLockSettings() async {
    final raw = await _storage.read(key: _appLockSettingsKey);

    if (raw == null) {
      final newSettings = AppLockSettingsModel(
        isPinEnabled: false,
        hasPin: false,
        isBiometricEnabled: false,
      );
      await saveAppLockSettings(newSettings);
      return newSettings;
    }

    final jsonMap = jsonDecode(raw) as Map<String, dynamic>;
    return AppLockSettingsModel.fromJson(jsonMap);
  }

  @override
  Future<PinCredentialModel?> getPinCredential() async {
    final raw = await _storage.read(key: _appLockPinCredentialKey);

    if (raw == null) return null;

    final jsonMap = jsonDecode(raw) as Map<String, dynamic>;

    return PinCredentialModel.fromJson(jsonMap);
  }

  @override
  Future<AppLockSettingsModel> saveAppLockSettings(
    AppLockSettingsModel settings,
  ) async {
    final jsonString = jsonEncode(settings.toJson());
    await _storage.write(key: _appLockSettingsKey, value: jsonString);
    return settings;
  }

  @override
  Future<PinCredentialModel> savePinCredential(
    PinCredentialModel credential,
  ) async {
    final jsonString = jsonEncode(credential.toJson());
    await _storage.write(key: _appLockPinCredentialKey, value: jsonString);
    return credential;
  }
}
