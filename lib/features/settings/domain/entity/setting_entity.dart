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

  AppSettingsEntity copyWith({
    String? currencyCode,
    String? locale,
    bool? isDarkMode,
    int? firstDayOfWeek,
  }) {
    return AppSettingsEntity(
      currencyCode: currencyCode ?? this.currencyCode,
      locale: locale ?? this.locale,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      firstDayOfWeek: firstDayOfWeek ?? this.firstDayOfWeek,
    );
  }
}
