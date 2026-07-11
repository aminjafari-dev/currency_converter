import 'package:equatable/equatable.dart';

/// A currency the user has pinned on the Home list.
///
/// [isBase] marks the editable amount row (lime border in the design).
class SelectedCurrency extends Equatable {
  final String code;
  final bool isBase;

  const SelectedCurrency({
    required this.code,
    this.isBase = false,
  });

  SelectedCurrency copyWith({String? code, bool? isBase}) {
    return SelectedCurrency(
      code: code ?? this.code,
      isBase: isBase ?? this.isBase,
    );
  }

  @override
  List<Object> get props => [code, isBase];
}
