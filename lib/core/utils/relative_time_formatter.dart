import 'package:flutter/widgets.dart';
import 'package:currency_converter/l10n/app_localizations.dart';

/// Builds a localized relative-time string for the "Rates updated …" footer.
///
/// Example:
/// ```dart
/// final label = RelativeTimeFormatter.format(context, lastUpdated);
/// ```
abstract final class RelativeTimeFormatter {
  /// Returns a short relative string for [updatedAt] relative to now.
  static String format(BuildContext context, DateTime? updatedAt) {
    final l10n = AppLocalizations.of(context);
    if (updatedAt == null) {
      return l10n.ratesUpdatedJustNow;
    }
    final diff = DateTime.now().difference(updatedAt);
    // Under a minute → "just now".
    if (diff.inMinutes < 1) {
      return l10n.ratesUpdatedJustNow;
    }
    // Under an hour → "N min ago".
    if (diff.inHours < 1) {
      return l10n.ratesUpdatedMinutesAgo(diff.inMinutes);
    }
    return l10n.ratesUpdatedHoursAgo(diff.inHours);
  }
}
