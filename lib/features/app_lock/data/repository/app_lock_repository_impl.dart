import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/app_lock/data/datasource/app_lock_local_datasource.dart';
import 'package:expense_tracker/features/app_lock/data/mapper/app_lock_setting_mapper.dart';
import 'package:expense_tracker/features/app_lock/data/model/app_lock_setting_model.dart';
import 'package:expense_tracker/features/app_lock/data/model/pin_credential_model.dart';
import 'package:expense_tracker/features/app_lock/domain/entity/app_lock_setting_entity.dart';
import 'package:expense_tracker/features/app_lock/domain/repository/app_lock_repository.dart';

class AppLockRepositoryImpl implements AppLockRepository {
  final AppLockLocalDatasource _localDatasource;

  AppLockRepositoryImpl(this._localDatasource);

  @override
  Future<void> changePin(String oldPin, String newPin) async {
    // Validate the provided PINs
    _validatePin(oldPin);
    _validatePin(newPin);

    // Check if the old PIN matches the existing credential
    final isOldPinValid = await verifyPin(oldPin);

    if (!isOldPinValid) {
      throw ValidationException('Old PIN is incorrect.');
    }

    // Generate new salt and hash for the new PIN
    final newSalt = _generateSalt();
    final newHash = _hashPin(newPin, newSalt);

    // Create a new credential model with the new PIN hash and salt
    final newCredentialModel = PinCredentialModel(
      pinHash: newHash,
      salt: newSalt,
    );

    // Persist the new credentials
    await _localDatasource.savePinCredential(newCredentialModel);

    final settings = await _localDatasource.getAppLockSettings();

    await _localDatasource.saveAppLockSettings(
      settings.copyWith(isPinEnabled: true, hasPin: true),
    );
  }

  @override
  Future<AppLockSettingsEntity> disablePinLock() async {
    final settings = await _localDatasource.getAppLockSettings();

    final newSettings = await _localDatasource.saveAppLockSettings(
      settings.copyWith(isPinEnabled: false, isBiometricEnabled: false),
    );

    return AppLockSettingMapper.toEntity(newSettings);
  }

  @override
  Future<AppLockSettingsEntity> enablePinLock(String pin) async {
    _validatePin(pin);

    final salt = _generateSalt();
    final hash = _hashPin(pin, salt);

    final credentialModel = PinCredentialModel(pinHash: hash, salt: salt);

    await _localDatasource.savePinCredential(credentialModel);

    final settings = AppLockSettingsModel(
      isPinEnabled: true,
      hasPin: true,
      isBiometricEnabled: false,
    );

    final settingsModel = await _localDatasource.saveAppLockSettings(settings);

    return AppLockSettingMapper.toEntity(settingsModel);
  }

  @override
  Future<AppLockSettingsEntity> getAppLockSettings() async {
    final settings = await _localDatasource.getAppLockSettings();

    return AppLockSettingMapper.toEntity(settings);
  }

  @override
  Future<bool> verifyPin(String pin) async {
    _validatePin(pin);

    final credential = await _localDatasource.getPinCredential();
    if (credential == null) {
      return false;
    }

    final computedHash = _hashPin(pin, credential.salt);

    return constantTimeEquality(computedHash, credential.pinHash);
  }

  @override
  Future<void> updateBiometricEnabled(bool enabled) {
    throw UnimplementedError();
  }

  /// Prevents timing attacks when comparing sensitive hashes.
  bool constantTimeEquality(String a, String b) {
    if (a.length != b.length) return false;
    var result = 0;
    for (var i = 0; i < a.length; i++) {
      result |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return result == 0;
  }

  String _generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Url.encode(saltBytes);
  }

  String _hashPin(String pin, String salt) {
    final key = utf8.encode(pin + salt);
    final hash = sha256.convert(key);
    return hash.toString();
  }

  void _validatePin(String pin) {
    if (pin.length != 4) {
      throw ValidationException('Pin must be exactly 4 digits.');
    }
    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      throw ValidationException('Pin must contain only numeric digits.');
    }
  }
}
