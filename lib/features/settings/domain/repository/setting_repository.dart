import 'package:expense_tracker/features/settings/domain/entity/setting_entity.dart';

abstract interface class SettingsRepository {
  Future<AppSettingsEntity> getSettings();
  Future<AppSettingsEntity> updateSettings(AppSettingsEntity settings);
}
