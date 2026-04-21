import 'package:expense_tracker/features/settings/data/datasource/setting_local_datasource.dart';
import 'package:expense_tracker/features/settings/data/model/setting_model.dart';
import 'package:isar/isar.dart';

class SettingsLocalDatasourceImpl implements SettingsLocalDatasource {
  final Isar _isar;

  const SettingsLocalDatasourceImpl(this._isar);

  static const _settingsKey = 'app_settings';

  @override
  Future<AppSettingsModel?> getSettings() {
    return _isar.appSettingsModels
        .filter()
        .keyEqualTo(_settingsKey)
        .findFirst();
  }

  @override
  Future<AppSettingsModel> updateSettings(AppSettingsModel settings) async {
    settings.key = _settingsKey;

    await _isar.writeTxn(() async {
      await _isar.appSettingsModels.put(settings);
    });

    return settings;
  }
}
