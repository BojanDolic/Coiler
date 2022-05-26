// ignore_for_file: slash_for_doc_comments

import 'dart:math' as math;

import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';

class Calculator {
  late Converter converter;

  Calculator() {
    converter = Converter();
  }

  /**
   * Function used to calculate capacitor bank capacitance.
   *
   * Capacitor bank can be represented as a string of capacitors connected in series and parallel to achieve
   * desired capacitance and voltage rating.
   *
   *
   * String of capacitors could look something like this:
   * ```dart
   * |--| |---| |---| |--|
   * |                   |
   * |--| |---| |---| |--|
   * ```
   *
   * Illustration above represents MMC bank which consists of three capacitors in series
   * and two capacitors in parallel
   *
   * - [capacitance] represents single capacitor capacitance
   * - [seriesCapNum] is the number of capacitors in series
   * - [parallelCapNum] is the number of capacitors in parallel
   */
  double calculateMMC(double capacitance, int seriesCapNum, int parallelCapNum) {
    double? _capacitance = 0.0;

    try {
      var _cap = (capacitance * parallelCapNum) / seriesCapNum;
      _capacitance = _cap;
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
   * [diameter] diameter of the coil.
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
  double calculateSpiralCoilInductance(int turns, double diameter, double wireDiameter, double turnSpacing, Units units) {
    // If passed units are not in meters
    if (units != Units.DEFAULT) {
      diameter = converter.convertUnits(diameter, units, Units.DEFAULT);
      wireDiameter = converter.convertUnits(wireDiameter, units, Units.DEFAULT);
      turnSpacing = converter.convertUnits(turnSpacing, units, Units.DEFAULT);
    }

    var radius = diameter / 2;
    //var radiusInches = radius / 25.4;

    var coilHeight = turns * (turnSpacing + wireDiameter);
    //var coilHeightInches = coilHeight / 25.4;

    var defaultInductance = math.pow(radius * turns, 2) / (0.2286 * radius + 0.254 * coilHeight);

    return defaultInductance;
  }

  /**
   * Function used to calculate inductance of single-layer flat spiral round-wire coil
   *
   * [turns] turns of the coil
   * [innerDiameter] inner diameter of the coil.
   * [wireDiameter] diameter of the wire used for winding the coil.
   * [turnSpacing] spacing between two adjacent turns of the wire.
   *
   * Function uses Harold A. Wheeler formula:
   *
   * **L = (R * N)^2 / (8 * R + 11 * W)** where:
   * - L is the inductance in microhenrys
   * - R is the average radius of the coil in inches
   * - N is the number of turns the coil has.
   * - W is the width of the coil measured in inches | ([turns] * ([wireDiameter] + [turnSpacing]))
   *
   *
   * If values passed are not in meters, which is determined by parameter [units],
   * then function converts all values to default value of meter
   *
   * Function returns inductance of the coil in henries
   */

  double calculateFlatCoilInductance(int turns, double innerDiameter, double wireDiameter, double turnSpacing, Units units) {
    // If passed units are not in meters
    if (units != Units.DEFAULT) {
      innerDiameter = converter.convertToDefault(innerDiameter, units);
      wireDiameter = converter.convertToDefault(wireDiameter, units);
      turnSpacing = converter.convertToDefault(turnSpacing, units);
    }

    var wireDiameterInches = wireDiameter * 39.37;
    var innerDiameterInches = innerDiameter * 39.37;
    var turnSpacingInches = turnSpacing * 39.37;

    var coilWidth = turns * (wireDiameterInches + turnSpacingInches);

    var innerRadius = innerDiameterInches / 2;

    var halfWidth = coilWidth / 2;

    var radius = halfWidth + innerRadius;

    var inductance = math.pow(radius * turns, 2) / (8 * radius + 11 * coilWidth);

    // Convert to default because formula used above returns inductance in microhenries
    return converter.convertToDefault(inductance, Units.MICRO);
  }
}
