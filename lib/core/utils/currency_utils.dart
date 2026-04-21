import 'package:intl/intl.dart';

/// Currency formatting helpers for MoneyFlow.
abstract final class CurrencyUtils {
  static final Map<String, NumberFormat> _formatCache = {};
  static final Map<String, NumberFormat> _compactFormatCache = {};

  static NumberFormat _getFormatter(String currencyCode) {
    return _formatCache.putIfAbsent(
      currencyCode,
      () => NumberFormat.currency(
        locale: _localeForCurrency(currencyCode),
        symbol: symbolForCurrency(currencyCode),
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
    String currencyCode = 'VND',
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
  static String formatCompact(double amount, {String currencyCode = 'VND'}) {
    final formatter = _compactFormatCache.putIfAbsent(
      currencyCode,
      () => NumberFormat.compactCurrency(
        locale: _localeForCurrency(currencyCode),
        symbol: symbolForCurrency(currencyCode),
        decimalDigits: _decimalsForCurrency(currencyCode),
      ),
    );

    return formatter.format(amount);
  }

  /// Returns only the numeric part as a string, without currency symbol.
  static String formatNumber(double amount, {int decimals = 2}) =>
      amount.toStringAsFixed(decimals);

  static double convert(
    double amount, {
    required String fromCurrency,
    required String toCurrency,
  }) {
    if (fromCurrency == toCurrency) {
      return amount;
    }

    final amountInVnd = amount * _exchangeRateFromVnd(fromCurrency);
    return amountInVnd / _exchangeRateFromVnd(toCurrency);
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static String symbolForCurrency(String code) {
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

  static double _exchangeRateFromVnd(String code) {
    const rates = {
      'VND': 1.0,
      'USD': 25000.0,
      'EUR': 27000.0,
      'GBP': 31500.0,
      'JPY': 170.0,
      'KRW': 18.0,
      'CNY': 3500.0,
      'INR': 300.0,
      'AUD': 16500.0,
      'CAD': 18500.0,
    };
    return rates[code] ?? 1.0;
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
