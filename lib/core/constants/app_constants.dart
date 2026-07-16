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
  /// App baseline for Home + Chart: rates are always “1 USD = …”.
  ///
  /// Example: live row shows `1 USD = 179_500 IRT`, not `1 IRT = 0.000005 USD`.
  static const String defaultBaseCurrency = 'USD';

  /// Public Google Drive direct-download URL for the USD→IRR JSON feed.
  ///
  /// Uses `drive.usercontent.google.com` (final host after redirect) so Dio
  /// does not depend on following Google’s 303 from `drive.google.com`.
  /// File must be shared as “Anyone with the link”. Override at build time:
  /// `flutter run --dart-define=USD_IRR_DRIVE_FEED_URL=https://…`
  ///
  /// Default file: https://drive.google.com/file/d/1uGZWmU6gtese0BUvW_OocrfmeQeJynM3/view
  static const String usdIrrDriveFeedUrl = String.fromEnvironment(
    'USD_IRR_DRIVE_FEED_URL',
    defaultValue:
        'https://drive.usercontent.google.com/download?id=1uGZWmU6gtese0BUvW_OocrfmeQeJynM3&export=download',
  );

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
  /// First-launch line-up: USD is the base row, then Toman (IRT) and
  /// common regional quotes (Euro, Dram, Omani Rial, UAE Dirham).
  static const List<String> defaultSelectedCurrencies = [
    'USD',
    'IRT',
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
