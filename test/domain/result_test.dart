import 'package:flutter_test/flutter_test.dart';
import 'package:smart_executer/smart_executer.dart';

void main() {
  group('Result', () {
    test('Success exposes and transforms data', () {
      const result = Success<int>(2);

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, 2);
      expect(result.map((value) => value * 3), const Success<int>(6));
      expect(result.getOrElse(0), 2);
    });

    test('Failure preserves the SmartException', () {
      const exception = UnknownException('failed');
      const result = Failure<int>(exception);

      expect(result.isFailure, isTrue);
      expect(result.exceptionOrNull, same(exception));
      expect(result.getOrElse(7), 7);
      expect(() => result.dataOrThrow, throwsA(same(exception)));
    });
  });
}
