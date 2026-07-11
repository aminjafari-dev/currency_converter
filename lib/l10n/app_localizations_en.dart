// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Orbit';

  @override
  String get addCurrencyTitle => 'Add Currency';

  @override
  String get searchCurrencyHint => 'Search currency or country';

  @override
  String get popularSection => 'Popular';

  @override
  String get trendingBadge => 'TRENDING';

  @override
  String ratesUpdated(String time) {
    return 'Rates updated $time';
  }

  @override
  String get ratesUpdatedJustNow => 'just now';

  @override
  String ratesUpdatedMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String ratesUpdatedHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String get liveRate => 'Live Rate';

  @override
  String conversionLine(String base) {
    return '1 $base =';
  }

  @override
  String percentToday(String sign, String value) {
    return '$sign$value% today';
  }

  @override
  String get rangeOneDay => '1D';

  @override
  String get rangeOneWeek => '1W';

  @override
  String get rangeOneMonth => '1M';

  @override
  String get rangeSixMonths => '6M';

  @override
  String get rangeOneYear => '1Y';

  @override
  String get rangeAll => 'ALL';

  @override
  String get statHigh => 'High';

  @override
  String get statLow => 'Low';

  @override
  String get statPercentChange => '% Change';

  @override
  String get orbitInsightTitle => 'Orbit Insight';

  @override
  String orbitInsightBody(String currency) {
    return '$currency remains active against the selected base. Indicative reference rates are updated daily from official sources.';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsEnglish => 'English';

  @override
  String get settingsPersian => 'Persian';

  @override
  String get settingsPlaceholder => 'More settings coming soon.';

  @override
  String get navConvert => 'Convert';

  @override
  String get navChart => 'Chart';

  @override
  String get navSettings => 'Settings';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorNetwork =>
      'No internet connection. Showing cached rates if available.';

  @override
  String get errorServer => 'Unable to reach the rates service.';

  @override
  String get errorCache =>
      'No cached rates found. Connect to the internet to refresh.';

  @override
  String get retry => 'Retry';

  @override
  String get emptyCurrencies => 'No currencies selected yet. Tap + to add one.';

  @override
  String get emptySearch => 'No currencies match your search.';

  @override
  String get editList => 'Edit list';

  @override
  String get addCurrencyAction => 'Add currency';

  @override
  String baseCurrency(String code) {
    return 'Base: $code';
  }

  @override
  String get details => 'Details';

  @override
  String get indicativeRatesDisclaimer =>
      'Rates are indicative reference values, not bank cash rates.';
}
