import 'package:coiler_app/calculator/calculator.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:test/test.dart';

void main() {
  final calculator = Calculator();
  final converter = Converter();

  group("FLAT COIL INDUCTANCE TEST", () {
    test("INDUCTANCE | TEST 1", () {
      const wireDiameter = 4.0;
      const innerDiameter = 250.0;
      const spacing = 10.0;
      const turns = 6;

      var inductance = calculator.calculateFlatCoilInductance(turns, innerDiameter, wireDiameter, spacing, Units.MILI);

      expect(inductance.toStringAsFixed(8), "0.00001749");
    });

    test("INDUCTANCE | TEST 2", () {
      const wireDiameter = 4.0 / 1000;
      const innerDiameter = 250.0 / 1000;
      const spacing = 10.0 / 1000;
      const turns = 6;

      var inductance = calculator.calculateFlatCoilInductance(turns, innerDiameter, wireDiameter, spacing, Units.DEFAULT);

      expect(inductance.toStringAsFixed(8), "0.00001749");
    });

    test("INDUCTANCE | TEST 2", () {
      const wireDiameter = 4.0 / 1000;
      const innerDiameter = 250.0 / 1000;
      const spacing = 0.0;
      const turns = 6;

      var inductance = calculator.calculateFlatCoilInductance(turns, innerDiameter, wireDiameter, spacing, Units.DEFAULT);

      expect(inductance.toStringAsFixed(8), "0.00001956");
    });
  });
}
