import 'package:currency_converter/features/rates/domain/entities/currency.dart';

/// DTO for a single currency from Frankfurter `/v1/currencies`.
///
/// The endpoint returns `{ "USD": "United States Dollar", ... }`.
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

  /// Builds a list of models from the Frankfurter currencies map.
  static List<CurrencyModel> listFromCurrenciesMap(Map<String, dynamic> map) {
    return map.entries
        .map((e) => CurrencyModel(code: e.key, name: e.value.toString()))
        .toList()
      ..sort((a, b) => a.code.compareTo(b.code));
  }
}
