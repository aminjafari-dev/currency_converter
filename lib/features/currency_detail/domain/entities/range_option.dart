/// Chart range chips matching the Stitch detail screen.
///
/// Maps each option to a [start] date relative to [now].
///
/// Example:
/// ```dart
/// final start = RangeOption.oneMonth.startDate();
/// ```
enum RangeOption {
  oneDay,
  oneWeek,
  oneMonth,
  sixMonths,
  oneYear;

  /// Start date for the historical series request.
  DateTime startDate({DateTime? now}) {
    final n = now ?? DateTime.now();
    switch (this) {
      case RangeOption.oneDay:
        // Frankfurter is daily — use ~7 days so 1D still has points.
        return n.subtract(const Duration(days: 7));
      case RangeOption.oneWeek:
        return n.subtract(const Duration(days: 7));
      case RangeOption.oneMonth:
        return n.subtract(const Duration(days: 30));
      case RangeOption.sixMonths:
        return n.subtract(const Duration(days: 182));
      case RangeOption.oneYear:
        return n.subtract(const Duration(days: 365));
    }
  }
}
