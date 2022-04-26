import 'package:coiler_app/util/conversion.dart';

extension StringSuffix on double {
  /// Function used to format double values as string with correct SI prefixes
  ///
  /// Example:
  /// ```dart
  /// number = 0.014447
  /// number.toStringWithPrefix();
  ///
  /// Output: "14.45 m"
  /// ```
  /// In the above example, **m** at the end of the string denotes **mili** prefix
  ///
  /// **If [decimalPoints] value is negative integer, it is converted to it's absolute value**
  String toStringWithPrefix([int? decimalPoints]) {
    if (this == 0) {
      return toStringAsFixed(2);
    }

    int? decimal;

    if (decimalPoints != null && decimalPoints < 0) {
      decimal = decimalPoints.abs();
    }

    final converter = Converter();

    var zeros = 0;
    var number = this;
    while (number < 1) {
      number *= 10;
      zeros++;
    }

    zeros -= 1;

    if (zeros <= 0) {
      return toStringAsFixed(decimal ?? 2);
    } else if (zeros >= 1 && zeros < 3) {
      return converter.convertFromDefaultToMili(this).toStringAsFixed(decimal ?? 2) + " m";
    } else if (zeros >= 3 && zeros < 6) {
      return converter.convertFromDefaultToMicro(this).toStringAsFixed(decimal ?? 2) + " µ";
    } else if (zeros >= 6 && zeros < 9) {
      return converter.convertFromDefaultToNano(this).toStringAsFixed(decimal ?? 2) + " n";
    } else if (zeros >= 9) {
      return converter.convertFromDefaultToPico(this).toStringAsFixed(decimal ?? 2) + " p";
    } else {
      return "";
    }
  }
}

extension StringUnit on String {
  String toHenry() => this + "H";
  String toMeter() => this + "m";
  String toFarad() => this + "F";
}
