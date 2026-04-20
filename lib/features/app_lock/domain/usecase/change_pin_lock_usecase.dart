import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/app_lock/domain/repository/app_lock_repository.dart';

class ChangePinLockUsecase {
  final AppLockRepository _appLockRepository;

  const ChangePinLockUsecase(this._appLockRepository);

  Future<void> call(String oldPin, String newPin) {
    if (oldPin.trim().isEmpty) {
      throw const ValidationException('Pin is required.');
    }

    if (newPin.trim().isEmpty) {
      throw const ValidationException('Pin is required.');
    }

    return _appLockRepository.changePin(oldPin, newPin);
  }
}
