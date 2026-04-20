import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/app_lock/domain/repository/app_lock_repository.dart';

class VerifyPinLockUsecase {
  final AppLockRepository _appLockRepository;

  const VerifyPinLockUsecase(this._appLockRepository);

  Future<bool> call(String pin) {
    if (pin.trim().isEmpty) {
      throw const ValidationException('Pin is required.');
    }

    return _appLockRepository.verifyPin(pin);
  }
}
