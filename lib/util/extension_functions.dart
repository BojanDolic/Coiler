import 'package:coiler_app/util/conversion.dart';

extension StringSuffix on double {
  /// Function used to format double values as string with correct prefix units
  ///
  /// Example:
  /// ```dart
  /// number = 0.014447
  /// number.toStringWithPrefix();
  ///
  /// Output: "14.45 m"
  /// ```
  /// In the above example, **m** at the end of the string denotes **mili** prefix unit
  String toStringWithPrefix([int? decimalPoints]) {
    if (this == 0) {
      return this.toString();
    }

    var zeros = 0;
    var number = this;
    while (number < 1) {
      number *= 10;
      zeros++;
    }

    zeros -= 1;

    /*if (zeros < 1) {
      return toStringAsFixed(2);
    } else */
    if (zeros >= 4) {
      //  && zeros >= 3
      return Converter().convertToMicro(this).toStringAsFixed(decimalPoints ?? 2) + " µ";
    } else if (zeros < 4) {
      return Converter().convertFromDefaultToMili(this).toStringAsFixed(decimalPoints ?? 2) + " m";
    }

    return "";
  }
}

extension StringUnit on String {
  String toHenry() => this + "H";
  String toMeter() => this + "m";
}
