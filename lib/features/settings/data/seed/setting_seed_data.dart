import 'package:expense_tracker/features/settings/domain/entity/setting_entity.dart';

abstract class SettingSeedData {
  static AppSettingsEntity buildDefaultSettings() {
    return const AppSettingsEntity(
      currencyCode: 'VND',
      locale: 'vi_VN',
      isDarkMode: false,
      firstDayOfWeek: 1,
    );
  }
}
