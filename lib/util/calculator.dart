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
}
