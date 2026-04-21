import 'package:expense_tracker/features/settings/data/datasource/setting_local_datasource.dart';
import 'package:expense_tracker/features/settings/data/mapper/setting_mapper.dart';
import 'package:expense_tracker/features/settings/domain/entity/setting_entity.dart';
import 'package:expense_tracker/features/settings/domain/repository/setting_repository.dart';

class SettingRepositoryImpl implements SettingsRepository {
  final SettingsLocalDatasource _localDatasource;

  const SettingRepositoryImpl(this._localDatasource);

  @override
  Future<AppSettingsEntity> getSettings() async {
    final model = await _localDatasource.getSettings();

    if (model != null) {
      return AppSettingsMapper.toEntity(model);
    }

    final defaultSettings = AppSettingsEntity(
      currencyCode: 'VND',
      locale: 'vi_VN',
      isDarkMode: false,
      firstDayOfWeek: 1,
    );

    final saved = await _localDatasource.updateSettings(
      AppSettingsMapper.toModel(defaultSettings),
    );

    return AppSettingsMapper.toEntity(saved);
  }

  @override
  Future<AppSettingsEntity> updateSettings(AppSettingsEntity settings) async {
    final model = AppSettingsMapper.toModel(settings);
    final saved = await _localDatasource.updateSettings(model);
    return AppSettingsMapper.toEntity(saved);
  }
}
