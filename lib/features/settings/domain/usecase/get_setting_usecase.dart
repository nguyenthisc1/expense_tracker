import 'package:expense_tracker/features/settings/domain/entity/setting_entity.dart';
import 'package:expense_tracker/features/settings/domain/repository/setting_repository.dart';

class GetSettingsUsecase {
  final SettingsRepository _settingsRepository;

  const GetSettingsUsecase(this._settingsRepository);

  Future<AppSettingsEntity> call() {
    return _settingsRepository.getSettings();
  }
}
