import 'package:currency_converter/features/rates/data/models/historical_series_model.dart';

/// Remote contract for free-market Iranian Rial rates (USD→IRR feed).
///
/// Implementations may load from a hosted JSON file (Google Drive), a CDN,
/// or any HTTP endpoint that exposes the same shape. Other FX pairs are
/// derived in the repository via Frankfurter triangulation.
///
/// Example:
/// ```dart
/// final map = await iranIrr.getForeignToIrrRates();
/// final usdIrr = map['USD']; // e.g. 1795000
/// ```
abstract class IranIrrRemoteDataSource {
  /// Returns ISO code → IRR for **1 unit** of that foreign currency.
  ///
  /// The Drive feed only publishes USD; the map is typically `{'USD': rate}`.
  Future<Map<String, double>> getForeignToIrrRates();

  /// Dated USD→IRR closes from the feed (other [foreignCode] values throw).
  ///
  /// [limit] caps how many calendar days are returned (newest first).
  Future<HistoricalSeriesModel> getForeignToIrrHistory({
    required String foreignCode,
    required int limit,
    required DateTime start,
    required DateTime end,
  });
}
