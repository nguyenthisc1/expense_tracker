import 'package:intl/intl.dart';

/// Currency formatting helpers for MoneyFlow.
abstract final class CurrencyUtils {
  static final Map<String, NumberFormat> _formatCache = {};

  static NumberFormat _getFormatter(String currencyCode) {
    return _formatCache.putIfAbsent(
      currencyCode,
      () => NumberFormat.currency(
        locale: _localeForCurrency(currencyCode),
        symbol: _symbolForCurrency(currencyCode),
        decimalDigits: _decimalsForCurrency(currencyCode),
      ),
    );
  }

  /// Formats [amount] as a currency string.
  ///
  /// - [currencyCode]: ISO 4217 code (defaults to `"USD"`).
  /// - [showSign]: prepend `+` for positive values.
  static String format(
    double amount, {
    String currencyCode = 'USD',
    bool showSign = false,
  }) {
    final formatted = _getFormatter(currencyCode).format(amount.abs());
    if (showSign && amount >= 0) return '+$formatted';
    if (amount < 0) return '-$formatted';
    return formatted;
  }

  /// Formats [amount] compactly (K, M suffixes).
  ///
  /// e.g. 1500 → `"\$1.5K"`, 2000000 → `"\$2M"`.
  static String formatCompact(double amount, {String symbol = '\$'}) {
    final abs = amount.abs();
    final sign = amount < 0 ? '-' : '';
    if (abs >= 1e6) return '$sign$symbol${(abs / 1e6).toStringAsFixed(1)}M';
    if (abs >= 1e3) return '$sign$symbol${(abs / 1e3).toStringAsFixed(1)}K';
    return '$sign$symbol${abs.toStringAsFixed(2)}';
  }

  /// Returns only the numeric part as a string, without currency symbol.
  static String formatNumber(double amount, {int decimals = 2}) =>
      amount.toStringAsFixed(decimals);

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static String _symbolForCurrency(String code) {
    const symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'VND': '₫',
      'KRW': '₩',
      'CNY': '¥',
      'INR': '₹',
      'AUD': 'A\$',
      'CAD': 'C\$',
    };
    return symbols[code] ?? code;
  }

  static int _decimalsForCurrency(String code) {
    const noDecimal = {'JPY', 'VND', 'KRW'};
    return noDecimal.contains(code) ? 0 : 2;
  }

  static String _localeForCurrency(String code) {
    const locales = {
      'USD': 'en_US',
      'EUR': 'de_DE',
      'GBP': 'en_GB',
      'JPY': 'ja_JP',
      'VND': 'vi_VN',
      'KRW': 'ko_KR',
      'CNY': 'zh_CN',
      'INR': 'en_IN',
      'AUD': 'en_AU',
      'CAD': 'en_CA',
    };
    return locales[code] ?? 'en_US';
  }
}
