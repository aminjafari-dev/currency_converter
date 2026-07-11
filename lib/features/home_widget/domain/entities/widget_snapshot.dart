import 'package:equatable/equatable.dart';

/// Snapshot prepared for a future native home-screen widget.
///
/// v1 is domain-ready only — native Android/iOS widget UI is deferred.
class WidgetCurrencyRate extends Equatable {
  final String code;
  final String name;
  final double rate;
  final double changePercent;

  const WidgetCurrencyRate({
    required this.code,
    required this.name,
    required this.rate,
    required this.changePercent,
  });

  @override
  List<Object> get props => [code, name, rate, changePercent];
}

class WidgetSnapshot extends Equatable {
  final String base;
  final List<WidgetCurrencyRate> rates;
  final DateTime updatedAt;

  const WidgetSnapshot({
    required this.base,
    required this.rates,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [base, rates, updatedAt];
}
