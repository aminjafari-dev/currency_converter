// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appName => 'اوربیت';

  @override
  String get addCurrencyTitle => 'افزودن ارز';

  @override
  String get searchCurrencyHint => 'جستجوی ارز یا کشور';

  @override
  String get popularSection => 'محبوب';

  @override
  String get trendingBadge => 'پرطرفدار';

  @override
  String ratesUpdated(String time) {
    return 'نرخ‌ها به‌روز شد $time';
  }

  @override
  String get ratesUpdatedJustNow => 'همین الان';

  @override
  String ratesUpdatedMinutesAgo(int minutes) {
    return '$minutes دقیقه پیش';
  }

  @override
  String ratesUpdatedHoursAgo(int hours) {
    return '$hours ساعت پیش';
  }

  @override
  String get liveRate => 'نرخ زنده';

  @override
  String conversionLine(String base) {
    return '۱ $base =';
  }

  @override
  String percentToday(String sign, String value) {
    return '$sign$value٪ امروز';
  }

  @override
  String get rangeOneDay => '۱ر';

  @override
  String get rangeOneWeek => '۱ه';

  @override
  String get rangeOneMonth => '۱م';

  @override
  String get rangeSixMonths => '۶م';

  @override
  String get rangeOneYear => '۱س';

  @override
  String get rangeAll => 'همه';

  @override
  String get statHigh => 'بیشینه';

  @override
  String get statLow => 'کمینه';

  @override
  String get statPercentChange => 'درصد تغییر';

  @override
  String get orbitInsightTitle => 'بینش اوربیت';

  @override
  String orbitInsightBody(String currency) {
    return '$currency در برابر پایه انتخاب‌شده فعال است. نرخ‌های مرجع روزانه از منابع رسمی به‌روز می‌شوند.';
  }

  @override
  String get settingsTitle => 'تنظیمات';

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get settingsEnglish => 'انگلیسی';

  @override
  String get settingsPersian => 'فارسی';

  @override
  String get settingsPlaceholder => 'تنظیمات بیشتر به‌زودی.';

  @override
  String get navConvert => 'تبدیل';

  @override
  String get navChart => 'نمودار';

  @override
  String get navSettings => 'تنظیمات';

  @override
  String get errorGeneric => 'مشکلی پیش آمد. لطفاً دوباره تلاش کنید.';

  @override
  String get errorNetwork =>
      'اتصال اینترنت نیست. در صورت وجود، نرخ‌های ذخیره‌شده نمایش داده می‌شود.';

  @override
  String get errorServer => 'دسترسی به سرویس نرخ‌ها ممکن نیست.';

  @override
  String get errorCache =>
      'نرخ ذخیره‌شده‌ای یافت نشد. برای به‌روزرسانی به اینترنت متصل شوید.';

  @override
  String get retry => 'تلاش مجدد';

  @override
  String get emptyCurrencies =>
      'هنوز ارزی انتخاب نشده. برای افزودن روی + بزنید.';

  @override
  String get emptySearch => 'ارزی با این جستجو پیدا نشد.';

  @override
  String get editList => 'ویرایش فهرست';

  @override
  String get doneEditing => 'پایان ویرایش';

  @override
  String get removeCurrency => 'حذف ارز';

  @override
  String get reorderCurrency => 'جابه‌جایی ارز';

  @override
  String get addCurrencyAction => 'افزودن ارز';

  @override
  String baseCurrency(String code) {
    return 'پایه: $code';
  }

  @override
  String get details => 'جزئیات';

  @override
  String get indicativeRatesDisclaimer =>
      'نرخ‌ها مرجع تقریبی هستند و نرخ نقدی بانک نیستند.';

  @override
  String get currencyIranianToman => 'تومان ایران';

  @override
  String get currencyIranianRial => 'ریال ایران';
}
