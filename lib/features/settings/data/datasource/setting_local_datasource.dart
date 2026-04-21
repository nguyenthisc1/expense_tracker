import 'package:expense_tracker/features/settings/data/model/setting_model.dart';

abstract interface class SettingsLocalDatasource {
  Future<AppSettingsModel?> getSettings();
  Future<AppSettingsModel> updateSettings(AppSettingsModel settings);
}
