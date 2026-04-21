import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/app_lock/domain/entity/app_lock_setting_entity.dart';
import 'package:expense_tracker/features/app_lock/domain/repository/app_lock_repository.dart';

class EnablePinLockUsecase {
  final AppLockRepository _appLockRepository;

  const EnablePinLockUsecase(this._appLockRepository);

  Future<AppLockSettingsEntity> call(String pin) {
    if (pin.trim().isEmpty) {
      throw const ValidationException('Pin is required.');
    }

    return _appLockRepository.enablePinLock(pin);
  }
}
