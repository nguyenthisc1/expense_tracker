import 'package:expense_tracker/features/settings/data/model/setting_model.dart';
import 'package:expense_tracker/features/settings/domain/entity/setting_entity.dart';

class AppSettingsMapper {
  static AppSettingsEntity toEntity(AppSettingsModel model) {
    return AppSettingsEntity(
      currencyCode: model.currencyCode,
      locale: model.locale,
      isDarkMode: model.isDarkMode,
      firstDayOfWeek: model.firstDayOfWeek,
    );
  }

  static AppSettingsModel toModel(AppSettingsEntity entity) {
    final model = AppSettingsModel()
      ..key = 'app_settings'
      ..currencyCode = entity.currencyCode
      ..locale = entity.locale
      ..isDarkMode = entity.isDarkMode
      ..firstDayOfWeek = entity.firstDayOfWeek;
    return model;
  }
}
