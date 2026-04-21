import 'package:expense_tracker/core/errors/app_exeption.dart';
import 'package:expense_tracker/features/settings/domain/entity/setting_entity.dart';
import 'package:expense_tracker/features/settings/domain/repository/setting_repository.dart';

class UpdateSettingsUsecase {
  final SettingsRepository _settingsRepository;

  const UpdateSettingsUsecase(this._settingsRepository);

  Future<AppSettingsEntity> call(AppSettingsEntity settings) async {
    if (settings.currencyCode.trim().isEmpty) {
      throw const ValidationException('Currency code cannot be empty.');
    }

    if (settings.locale.trim().isEmpty) {
      throw const ValidationException('Locale cannot be empty.');
    }

    if (settings.firstDayOfWeek < 1 || settings.firstDayOfWeek > 7) {
      throw const ValidationException(
        'First day of week must be between 1 and 7.',
      );
    }

    return _settingsRepository.updateSettings(settings);
  }
}
