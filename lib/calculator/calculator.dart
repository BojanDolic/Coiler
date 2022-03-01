import 'dart:math' as math;

class Calculator {
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
    double resFreqResult = 0.0;

    var sqrtCap = math.sqrt(capacitance);
    var sqrtInd = math.sqrt(inductance);

    var frequency = 1 / (2 * math.pi * sqrtInd * sqrtCap);

    /*try {
      resFreqResult = double.parse(frequency.toStringAsFixed(2));
    } catch (e) {
      resFreqResult = 0.0;
    }*/
    return frequency;
  }
}
