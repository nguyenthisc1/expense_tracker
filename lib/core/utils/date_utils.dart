import 'package:intl/intl.dart';

/// Date formatting helpers for MoneyFlow.
abstract final class MoneyFlowDateUtils {
  static final DateFormat _dayMonth = DateFormat('d MMM');
  static final DateFormat _dayMonthYear = DateFormat('d MMM yyyy');
  static final DateFormat _monthYear = DateFormat('MMM yyyy');
  static final DateFormat _fullDate = DateFormat('EEEE, d MMMM yyyy');
  static final DateFormat _isoDate = DateFormat('yyyy-MM-dd');
  static final DateFormat _time = DateFormat('HH:mm');

  /// Returns `"d MMM"` — e.g. `"13 Apr"`.
  static String formatDayMonth(DateTime date) => _dayMonth.format(date);

  /// Returns `"d MMM yyyy"` — e.g. `"13 Apr 2026"`.
  static String formatDayMonthYear(DateTime date) =>
      _dayMonthYear.format(date);

  /// Returns `"MMM yyyy"` — e.g. `"Apr 2026"`.
  static String formatMonthYear(DateTime date) => _monthYear.format(date);

  /// Returns full weekday date — e.g. `"Monday, 13 April 2026"`.
  static String formatFull(DateTime date) => _fullDate.format(date);

  /// Returns ISO date string — e.g. `"2026-04-13"`.
  static String formatIso(DateTime date) => _isoDate.format(date);

  /// Returns time string — e.g. `"14:30"`.
  static String formatTime(DateTime date) => _time.format(date);

  /// Returns a friendly relative label:
  /// - "Today" if same calendar day as now
  /// - "Yesterday" for yesterday
  /// - formatted day-month for older dates
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(date.year, date.month, date.day);
    final diff = today.difference(d).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (date.year == now.year) return formatDayMonth(date);
    return formatDayMonthYear(date);
  }

  /// Returns the start of the current month.
  static DateTime startOfMonth([DateTime? ref]) {
    final d = ref ?? DateTime.now();
    return DateTime(d.year, d.month);
  }

  /// Returns the last moment of the current month.
  static DateTime endOfMonth([DateTime? ref]) {
    final d = ref ?? DateTime.now();
    return DateTime(d.year, d.month + 1).subtract(const Duration(seconds: 1));
  }

  /// Returns a list of [DateTime] objects representing the first day of
  /// each month for the past [count] months, starting from [ref] (or now).
  static List<DateTime> lastNMonths(int count, [DateTime? ref]) {
    final pivot = ref ?? DateTime.now();
    return List.generate(count, (i) {
      final offset = count - 1 - i;
      return DateTime(pivot.year, pivot.month - offset);
    });
  }
}
