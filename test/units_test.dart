import 'package:coiler_app/util/extension_functions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("VALUE UNIT TESTS", () {
    test("UNIT TEST 1 | 55.00 p", () {
      const double testValue1 = 0.000000000055;
      var result = testValue1.toStringWithPrefix();

      expect(result, "55.00 p");
    });

    test("UNIT TEST 2 | 550.00 p", () {
      const double testValue2 = 0.00000000055;
      var result = testValue2.toStringWithPrefix();

      expect(result, "550.00 p");
    });

    test("UNIT TEST 3 | 5.50 n", () {
      const double testValue3 = 0.0000000055;
      var result = testValue3.toStringWithPrefix();

      expect(result, "5.50 n");
    });

    test("UNIT TEST 4 | 55.00 n", () {
      const double testValue4 = 0.000000055;
      var result = testValue4.toStringWithPrefix();

      expect(result, "55.00 n");
    });

    test("UNIT TEST 5 | 550.00 n", () {
      const double testValue5 = 0.00000055;
      var result = testValue5.toStringWithPrefix();

      expect(result, "550.00 n");
    });

    test("UNIT TEST 6 | 5.50 µ", () {
      const double testValue6 = 0.0000055;
      var result = testValue6.toStringWithPrefix();

      expect(result, "5.50 µ");
    });

    test("UNIT TEST 7 | 55.00 µ", () {
      const double testValue7 = 0.000055;
      var result = testValue7.toStringWithPrefix();

      expect(result, "55.00 µ");
    });

    test("UNIT TEST 8 | 0.55 m", () {
      const double testValue8 = 0.00055;
      var result = testValue8.toStringWithPrefix();

      expect(result, "0.55 m");
    });

    test("UNIT TEST 9 | 5.50 m", () {
      const double testValue9 = 0.0055;
      var result = testValue9.toStringWithPrefix();

      expect(result, "5.50 m");
    });

    test("UNIT TEST 10 | empty value", () {
      double emptyValue = 0.0;
      var result = emptyValue.toStringWithPrefix();

      expect(result, "0.00");
    });

    test("UNIT TEST 11 | Negative decimal", () {
      double emptyValue = 1.0;
      var result = emptyValue.toStringWithPrefix(-1);

      expect(result, "1.0");
    });
  });
}
