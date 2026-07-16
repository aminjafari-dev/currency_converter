/// Non-translatable app constants (API keys, debug labels, cache keys, …).
///
/// Keep user-facing copy in ARB files — only put non-l10n values here.
abstract final class AppConstants {
  static const String ratesCacheKey = 'cached_rate_snapshot';
  static const String ratesUpdatedAtKey = 'rates_updated_at';
  static const String selectedCurrenciesKey = 'selected_currencies';
  static const String baseCurrencyKey = 'base_currency';
  static const String localeKey = 'app_locale';
  static const String themeModeKey = 'app_theme_mode';
  static const String defaultBaseCurrency = 'IRT';

  /// Oanor Iran Rial Market API gateway (free-market / bazaar IRR only).
  static const String oanorBaseUrl = 'https://api.oanor.com/irr-api';

  /// Oanor marketplace key for IRR overrides.
  ///
  /// Override at build time without editing source:
  /// `flutter run --dart-define=OANOR_API_KEY=oanor_live_…`
  ///
  /// Also subscribe the key to **Iran Rial Market API** on oanor.com
  /// (Free tier is enough) — otherwise calls return `subscription_required`.
  static const String oanorApiKey = String.fromEnvironment(
    'OANOR_API_KEY',
    defaultValue:
        'oanor_live_b1116527294d6f3878249c75480ad32dd744f4018916503c34cb68b7ee569d3d',
  );

  /// Foreign ISO codes Oanor prices directly vs IRR (lowercase on the wire).
  static const Set<String> oanorIrrForeignCodes = {
    'USD',
    'EUR',
    'GBP',
    'AED',
    'TRY',
    'CAD',
    'AUD',
    'CHF',
    'CNY',
    'JPY',
    'RUB',
  };

  /// Synthetic Iranian Toman code (not on Frankfurter — derived as IRR ÷ 10).
  static const String iranianTomanCode = 'IRT';

  /// Official ISO code for Iranian Rial.
  static const String iranianRialCode = 'IRR';

  /// Fixed market convention: 1 Toman = 10 Rial (drop one zero).
  ///
  /// Example: `1_782_000 IRR / rialPerToman == 178_200 IRT`.
  static const int rialPerToman = 10;

  /// Default selected list when the user has never customized.
  ///
  /// First-launch line-up for the target audience (Iran):
  /// Toman (synthetic IRT, also the base row), US Dollar, Euro,
  /// Armenian Dram, Omani Rial, and UAE Dirham.
  static const List<String> defaultSelectedCurrencies = [
    'IRT',
    'USD',
    'EUR',
    'AMD',
    'OMR',
    'AED',
  ];

  /// Popular currencies shown at the top of Add Currency.
  static const List<String> popularCurrencies = [
    'USD',
    'EUR',
    'AMD',
    'IRT',
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
    'IRR',
    'IRT',
  };
}
