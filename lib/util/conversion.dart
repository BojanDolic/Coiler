import 'package:coiler_app/util/constants.dart';

class Converter {
  static const Map<Units, double> unitsMap = {
    Units.DEFAULT: 1.0,
    Units.CENTI: 0.01,
    Units.MILI: 0.001,
    Units.MICRO: 0.000001,
    Units.NANO: 0.000000001,
    Units.PICO: 0.000000000001,
    Units.KILO: 1000,
    Units.MEGA: 1000000,
    Units.GIGA: 1000000000,
  };

  double getCapMultiplier(Units unit) => unitsMap[unit]!;

  /// Function used to convert different units
  /// [value] value to be converted
  /// [from] from which unit we need to convert
  /// [to] unit which we will convert to
  ///
  /// Example:
  ///
  /// ```dart
  ///  result = convertUnits(22, Units.MICRO, Units.NANO) -> 22000.0
  ///  result = convertUnits(2, Units.DEFAULT, Units.MICRO) -> 2000000.0
  ///  result = convertUnits(13.4, Units.PICO, Units.NANO) -> 0.0134
  ///  ```
  ///
  double convertUnits(dynamic value, Units from, Units to) {
    double result = 0.0;
    try {
      var multiplier = getCapMultiplier(from) / getCapMultiplier(to);
      double tempResult = value * multiplier;
      result = tempResult; //double.parse(tempResult.toStringAsFixed(7));
    } catch (e) {
      print(e);
    }
    return result;
  }

  static String getCoilType(CoilType coilType) {
    switch (coilType) {
      case CoilType.SPARK_GAP:
        return "SPARK_GAP";
      case CoilType.DRSSTC:
        return "DRSSTC";
      case CoilType.SSTC:
        return "SSTC";
    }
  }
}
