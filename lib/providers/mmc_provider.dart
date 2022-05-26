import 'package:coiler_app/calculator/calculator.dart';
import 'package:coiler_app/entities/Validation.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:flutter/cupertino.dart';

class CapacitorBankProvider extends ChangeNotifier {
  final calculator = Calculator();
  final converter = Converter();

  InputValidation _capacitance = InputValidation(value: null, error: null);
  InputValidation _parallelCaps = InputValidation(value: null, error: null);
  InputValidation _seriesCaps = InputValidation(value: null, error: null);
  InputValidation _voltage = InputValidation(value: null, error: null);

  InputValidation get capacitance => _capacitance;
  InputValidation get parallelCapsNum => _parallelCaps;
  InputValidation get seriesCapsNum => _seriesCaps;
  InputValidation get voltage => _voltage;

  Units _capacitanceUnit = Units.NANO;
  Units _resultCapacitanceUnit = Units.MICRO;

  double capacitanceResult = 0.0;
  int voltageResult = 0;

  Units get capacitanceUnit => _capacitanceUnit;
  Units get resultCapacitanceUnit => _resultCapacitanceUnit;

  void calculateResult() {
    if (_validateVoltage()) {
      _calculateVoltage();
    }

    if (_validateCapacitance()) {
      _parseAndCalculate();
    }
    notifyListeners();
  }

  void _parseAndCalculate() {
    final capacitanceTemp = converter.convertToDefault(_capacitance.value, capacitanceUnit);

    final capacitance = calculator.calculateMMC(capacitanceTemp, _seriesCaps.value, _parallelCaps.value);
    final _capacitanceResult = converter.convertUnits(capacitance, Units.DEFAULT, _resultCapacitanceUnit);

    capacitanceResult = _capacitanceResult;
  }

  void _calculateVoltage() {
    final voltage = _seriesCaps.value * _voltage.value;
    voltageResult = voltage;
  }

  void validateCapacitance(double? capacitance) {
    if (capacitance != null && capacitance > 0) {
      _capacitance = InputValidation(value: capacitance, error: null);
    } else {
      _capacitance = InputValidation(value: null, error: "Invalid capacitance value!");
    }
    notifyListeners();
  }

  void validateParallelCaps(int? caps) {
    if (caps != null && caps > 0) {
      _parallelCaps = InputValidation(value: caps, error: null);
    } else {
      _parallelCaps = InputValidation(value: null, error: "Number of parallel capacitors must be greater than 0");
    }
    notifyListeners();
  }

  void validateSeriesCaps(int? caps) {
    if (caps != null && caps > 0) {
      _seriesCaps = InputValidation(value: caps, error: null);
    } else {
      _seriesCaps = InputValidation(value: null, error: "Number of parallel capacitors must be greater than 0");
    }
    notifyListeners();
  }

  void validateVoltage(int? voltage) {
    if (voltage != null && voltage > 0 && voltage < 20000) {
      _voltage = InputValidation(value: voltage, error: null);
    } else {
      _voltage = InputValidation(value: null, error: "Voltage must be greater than 0 and lower than 20kV");
    }
    notifyListeners();
  }

  void setCapacitanceUnit(Units unit) {
    _capacitanceUnit = unit;
    notifyListeners();
  }

  void setCapacitanceResultUnit(Units unit) {
    _resultCapacitanceUnit = unit;
    notifyListeners();
  }

  bool _validateCapacitance() {
    return (_capacitance.value != null && _seriesCaps.value != null && _parallelCaps.value != null && _voltage.value != null);
  }

  bool _validateVoltage() {
    return (_voltage.value != null && _seriesCaps.value != null);
  }
}
