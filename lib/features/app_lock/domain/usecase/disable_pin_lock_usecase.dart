import 'package:expense_tracker/features/app_lock/domain/entity/app_lock_setting_entity.dart';
import 'package:expense_tracker/features/app_lock/domain/repository/app_lock_repository.dart';

class DisablePinLockUsecase {
  final AppLockRepository _appLockRepository;

  const DisablePinLockUsecase(this._appLockRepository);

  Future<AppLockSettingsEntity> call() {
    return _appLockRepository.disablePinLock();
  }
}
