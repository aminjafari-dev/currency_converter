import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa')
  ];

  /// Brand name shown in the app bar and widget
  ///
  /// In en, this message translates to:
  /// **'Nerkhak'**
  String get appName;

  /// Title of the Add Currency screen
  ///
  /// In en, this message translates to:
  /// **'Add Currency'**
  String get addCurrencyTitle;

  /// Placeholder in the currency search field
  ///
  /// In en, this message translates to:
  /// **'Search currency or country'**
  String get searchCurrencyHint;

  /// Section header for popular currencies
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get popularSection;

  /// Badge shown next to trending currencies
  ///
  /// In en, this message translates to:
  /// **'TRENDING'**
  String get trendingBadge;

  /// Footer showing when rates were last refreshed
  ///
  /// In en, this message translates to:
  /// **'Rates updated {time}'**
  String ratesUpdated(String time);

  /// Relative time when rates were updated moments ago
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get ratesUpdatedJustNow;

  /// Relative time in minutes
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String ratesUpdatedMinutesAgo(int minutes);

  /// Relative time in hours
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String ratesUpdatedHoursAgo(int hours);

  /// Label above the live rate on the detail screen
  ///
  /// In en, this message translates to:
  /// **'Live Rate'**
  String get liveRate;

  /// Hero conversion prefix on detail screen
  ///
  /// In en, this message translates to:
  /// **'1 {base} ='**
  String conversionLine(String base);

  /// Today percent change label
  ///
  /// In en, this message translates to:
  /// **'{sign}{value}% today'**
  String percentToday(String sign, String value);

  /// No description provided for @rangeOneDay.
  ///
  /// In en, this message translates to:
  /// **'1D'**
  String get rangeOneDay;

  /// No description provided for @rangeOneWeek.
  ///
  /// In en, this message translates to:
  /// **'1W'**
  String get rangeOneWeek;

  /// No description provided for @rangeOneMonth.
  ///
  /// In en, this message translates to:
  /// **'1M'**
  String get rangeOneMonth;

  /// No description provided for @rangeSixMonths.
  ///
  /// In en, this message translates to:
  /// **'6M'**
  String get rangeSixMonths;

  /// No description provided for @rangeOneYear.
  ///
  /// In en, this message translates to:
  /// **'1Y'**
  String get rangeOneYear;

  /// No description provided for @rangeAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get rangeAll;

  /// No description provided for @statHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get statHigh;

  /// No description provided for @statLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get statLow;

  /// No description provided for @statPercentChange.
  ///
  /// In en, this message translates to:
  /// **'% Change'**
  String get statPercentChange;

  /// Title of the insight card on the detail screen
  ///
  /// In en, this message translates to:
  /// **'Nerkhak Insight'**
  String get nerkhakInsightTitle;

  /// Static insight copy for v1
  ///
  /// In en, this message translates to:
  /// **'{currency} remains active against the selected base. Indicative reference rates are updated daily from official sources.'**
  String nerkhakInsightBody(String currency);

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Language row label in settings
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsEnglish;

  /// No description provided for @settingsPersian.
  ///
  /// In en, this message translates to:
  /// **'Persian'**
  String get settingsPersian;

  /// Placeholder body on the settings screen
  ///
  /// In en, this message translates to:
  /// **'More settings coming soon.'**
  String get settingsPlaceholder;

  /// No description provided for @navConvert.
  ///
  /// In en, this message translates to:
  /// **'Convert'**
  String get navConvert;

  /// No description provided for @navChart.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get navChart;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// Network failure message
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Showing cached rates if available.'**
  String get errorNetwork;

  /// Server failure message
  ///
  /// In en, this message translates to:
  /// **'Unable to reach the rates service.'**
  String get errorServer;

  /// Cache miss failure message
  ///
  /// In en, this message translates to:
  /// **'No cached rates found. Connect to the internet to refresh.'**
  String get errorCache;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Empty state on the home list
  ///
  /// In en, this message translates to:
  /// **'No currencies selected yet. Tap + to add one.'**
  String get emptyCurrencies;

  /// Empty state when search has no results
  ///
  /// In en, this message translates to:
  /// **'No currencies match your search.'**
  String get emptySearch;

  /// Semantics / tooltip for the edit affordance
  ///
  /// In en, this message translates to:
  /// **'Edit list'**
  String get editList;

  /// Semantics / tooltip when leaving list-edit mode
  ///
  /// In en, this message translates to:
  /// **'Done editing'**
  String get doneEditing;

  /// Semantics / tooltip for the remove icon on a currency card
  ///
  /// In en, this message translates to:
  /// **'Remove currency'**
  String get removeCurrency;

  /// Semantics / tooltip for the drag handle on a currency card
  ///
  /// In en, this message translates to:
  /// **'Reorder currency'**
  String get reorderCurrency;

  /// Semantics / tooltip for the add button
  ///
  /// In en, this message translates to:
  /// **'Add currency'**
  String get addCurrencyAction;

  /// Widget base currency pill
  ///
  /// In en, this message translates to:
  /// **'Base: {code}'**
  String baseCurrency(String code);

  /// Widget details affordance
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Honesty disclaimer for FX rates
  ///
  /// In en, this message translates to:
  /// **'Rates are indicative reference values, not bank cash rates.'**
  String get indicativeRatesDisclaimer;

  /// Display name for synthetic IRT (IRR ÷ 10)
  ///
  /// In en, this message translates to:
  /// **'Iranian Toman'**
  String get currencyIranianToman;

  /// Localized display name for IRR
  ///
  /// In en, this message translates to:
  /// **'Iranian Rial'**
  String get currencyIranianRial;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
