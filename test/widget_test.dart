import 'package:flutter_test/flutter_test.dart';

import 'package:currency_converter/core/usecase/usecase.dart';
import 'package:currency_converter/features/rates/domain/usecases/convert_amount.dart';

void main() {
  group('ConvertAmount', () {
    final useCase = ConvertAmount();

    test('returns identity when from == to', () async {
      final result = await useCase(
        const ConvertAmountParams(
          amount: 100,
          fromCode: 'USD',
          toCode: 'USD',
          base: 'USD',
          rates: {'EUR': 0.9},
        ),
      );
      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected Right'), (v) => expect(v, 100));
    });

    test('converts via base triangular rates', () async {
      // Snapshot base USD: 1 USD = 0.9 EUR, 1 USD = 150 JPY
      final result = await useCase(
        const ConvertAmountParams(
          amount: 90,
          fromCode: 'EUR',
          toCode: 'JPY',
          base: 'USD',
          rates: {'EUR': 0.9, 'JPY': 150},
        ),
      );
      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected Right'), (v) {
        // 90 EUR → 100 USD → 15000 JPY
        expect(v, closeTo(15000, 0.01));
      });
    });

    test('returns ValidationFailure when rate missing', () async {
      final result = await useCase(
        const ConvertAmountParams(
          amount: 10,
          fromCode: 'USD',
          toCode: 'XYZ',
          base: 'USD',
          rates: {'EUR': 0.9},
        ),
      );
      expect(result.isLeft(), isTrue);
    });
  });

  test('NoParams can be constructed', () {
    expect(const NoParams(), isA<NoParams>());
  });
}
