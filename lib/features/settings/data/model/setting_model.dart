import 'package:isar/isar.dart';

part 'setting_model.g.dart';

@collection
class AppSettingsModel {
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  late String currencyCode;
  late String locale;
  late bool isDarkMode;
  late int firstDayOfWeek;
}
