import 'package:currency_converter/features/rates/domain/entities/currency.dart';

/// DTO for a single currency in the supported catalog.
///
/// Frankfurter **v2** `/v2/currencies` returns objects like:
/// `{ "iso_code": "USD", "name": "United States Dollar", "symbol": "$", ... }`
///
/// Local cache stores the slim `{ "code", "name" }` shape via [toJson].
class CurrencyModel {
  final String code;
  final String name;

  const CurrencyModel({required this.code, required this.name});

  Currency toDomain() => Currency(code: code, name: name);

  Map<String, dynamic> toJson() => {'code': code, 'name': name};

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }

  /// Builds a sorted catalog from Frankfurter v2 currency objects.
  ///
  /// Example:
  /// ```dart
  /// final list = CurrencyModel.listFromV2List(response.data as List);
  /// // → AMD, IRR, OMR, … (~165 active ISO codes)
  /// ```
  static List<CurrencyModel> listFromV2List(List<dynamic> list) {
    return list
        .whereType<Map>()
        .map((row) {
          final map = Map<String, dynamic>.from(row);
          final code = (map['iso_code'] as String? ?? '').toUpperCase();
          final name = map['name'] as String? ?? code;
          return CurrencyModel(code: code, name: name);
        })
        // Drop rows without an ISO code so the Add Currency search stays clean.
        .where((c) => c.code.isNotEmpty)
        .toList()
      ..sort((a, b) => a.code.compareTo(b.code));
  }

  /// Builds a list from the legacy v1 `{ "USD": "United States Dollar" }` map.
  ///
  /// Kept for unit tests and any leftover cache/fixtures during migration.
  static List<CurrencyModel> listFromCurrenciesMap(Map<String, dynamic> map) {
    return map.entries
        .map((e) => CurrencyModel(code: e.key, name: e.value.toString()))
        .toList()
      ..sort((a, b) => a.code.compareTo(b.code));
  }
}
