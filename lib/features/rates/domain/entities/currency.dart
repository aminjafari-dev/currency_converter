import 'package:equatable/equatable.dart';

/// Pure domain representation of a currency.
///
/// Free of Flutter / JSON concerns — map from DTOs in the data layer.
///
/// Example:
/// ```dart
/// const Currency(code: 'EUR', name: 'Euro');
/// ```
class Currency extends Equatable {
  /// ISO 4217 code (e.g. USD).
  final String code;

  /// Human-readable name from Frankfurter (e.g. US Dollar).
  final String name;

  const Currency({
    required this.code,
    required this.name,
  });

  @override
  List<Object> get props => [code, name];
}
