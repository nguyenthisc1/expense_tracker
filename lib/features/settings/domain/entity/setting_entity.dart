class AppSettingsEntity {
  final String currencyCode;
  final String locale;
  final bool isDarkMode;
  final int firstDayOfWeek;

  const AppSettingsEntity({
    required this.currencyCode,
    required this.locale,
    required this.isDarkMode,
    required this.firstDayOfWeek,
  });
}
