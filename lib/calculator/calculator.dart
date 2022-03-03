// ignore_for_file: slash_for_doc_comments

import 'dart:math' as math;

import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';

class Calculator {
  late Converter converter;

  Calculator() {
    converter = Converter();
  }

  double calculateMMC(double capacitance, int seriesCap, int parallelCap) {
    double? _capacitance = 0.0;

    try {
      var _cap = (capacitance * parallelCap) / seriesCap;
      _capacitance = double.parse(_cap.toStringAsFixed(7));
    } catch (e) {
      _capacitance = 0.0;
    }
    return _capacitance;
  }

  double calculateResFrequency(double inductance, double capacitance) {
    var sqrtCap = math.sqrt(capacitance);
    var sqrtInd = math.sqrt(inductance);

    var frequency = 1 / (2 * math.pi * sqrtInd * sqrtCap);

    return frequency;
  }

  /**
   * Function used to calculate inductance of single-layer helical round-wire coil
   *
   * [turns] turns of the coil
   * [diameter] diameter of the coil. Needs to be in mm
   * [wireDiameter] diameter of the wire used for winding the coil.
   * [turnSpacing] spacing between two adjacent turns of the wire.
   *
   * Function uses modified formula: L = (R * N)^2 / (9 * R + 10 * H) where:
   * L is the inductance in microhenrys
   * R is the radius of the coil in inches | ([diameter] / 2)
   * N is the number of turns the coil has.
   * H is height of the coil measured in inches | ([turns] * ([wireDiameter] + [turnSpacing]))
   *
   * Formula is modified such that it accepts default value of meter
   *
   * If values passed are not in meters, which is determined by parameter [units],
   * then function converts all values to default value of meter
   *
   * Function returns inductance of the coil in microhenrys
   */
  double calculateSpiralCoilInductance(int turns, double diameter,
      double wireDiameter, double turnSpacing, Units units) {
    // If passed units are not in meters
    if (units != Units.DEFAULT) {
      diameter = converter.convertUnits(diameter, units, Units.DEFAULT);
      wireDiameter = converter.convertUnits(wireDiameter, units, Units.DEFAULT);
      turnSpacing = converter.convertUnits(turnSpacing, units, Units.DEFAULT);
    }

    var radius = diameter / 2;
    var radiusInches = radius / 25.4;

    var coilHeight = turns * (turnSpacing + wireDiameter);
    var coilHeightInches = coilHeight / 25.4;

    var defaultInductance =
        math.pow(radius * turns, 2) / (0.2286 * radius + 0.254 * coilHeight);

    return defaultInductance;
  }
}
