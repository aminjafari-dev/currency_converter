/// Non-translatable app constants (API keys, debug labels, cache keys, …).
///
/// Keep user-facing copy in ARB files — only put non-l10n values here.
abstract final class AppConstants {
  static const String ratesCacheKey = 'cached_rate_snapshot';
  static const String ratesUpdatedAtKey = 'rates_updated_at';
  static const String selectedCurrenciesKey = 'selected_currencies';
  static const String baseCurrencyKey = 'base_currency';
  static const String localeKey = 'app_locale';
  static const String defaultBaseCurrency = 'USD';

  /// Default selected list when the user has never customized.
  static const List<String> defaultSelectedCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
  ];

  /// Popular currencies shown at the top of Add Currency.
  static const List<String> popularCurrencies = [
    'USD',
    'EUR',
    'AMD',
    'IRR',
    'RUB',
    'GBP',
  ];

  /// Currencies that show a TRENDING badge on Add Currency.
  static const List<String> trendingCurrencies = ['USD'];

  /// Currencies that typically use 0 decimal places when formatting.
  static const Set<String> zeroDecimalCurrencies = {
    'JPY',
    'KRW',
    'VND',
    'CLP',
    'ISK',
  };
}
