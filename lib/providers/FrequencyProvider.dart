import 'package:coiler_app/calculator/calculator.dart';
import 'package:coiler_app/entities/Validation.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:flutter/cupertino.dart';

class ResonantFrequencyProvider extends ChangeNotifier {
  var _inductanceValidation = InputValidation<double>(value: null, error: null);
  var _capacitanceValidation = InputValidation<double>(value: null, error: null);

  InputValidation get inductance => _inductanceValidation;
  InputValidation get capacitance => _capacitanceValidation;

  Units _inductanceUnit = Units.MICRO;
  Units _capacitanceUnit = Units.MICRO;
  Units _frequencyUnit = Units.KILO;

  Units get capacitanceUnit => _capacitanceUnit;

  Units get frequencyUnit => _frequencyUnit;

  Units get inductanceUnit => _inductanceUnit;

  double _frequency = 0.0;
  String frequencyText = "";

  void calculateFrequency() {
    if (!validate()) {
      return;
    }
    parseResultAndCalculate();
    notifyListeners();
  }

  void parseResultAndCalculate() {
    final inductanceTemp = Converter().convertToDefault(_inductanceValidation.value, _inductanceUnit);
    final capacitanceTemp = Converter().convertToDefault(_capacitanceValidation.value, _capacitanceUnit);

    final tempFreq = Calculator().calculateResFrequency(inductanceTemp, capacitanceTemp);

    _frequency = tempFreq;

    frequencyText = Converter().convertUnits(tempFreq, Units.DEFAULT, _frequencyUnit).toStringAsFixed(7);
  }

  void setFrequencyUnit(Units unit) {
    _frequencyUnit = unit;
    notifyListeners();
  }

  void setInductanceUnit(Units unit) {
    _inductanceUnit = unit;
    notifyListeners();
  }

  void setCapacitanceUnit(Units unit) {
    _capacitanceUnit = unit;
    notifyListeners();
  }

  void validateInductance(double? inductance) {
    if (inductance != null && inductance > 0) {
      _inductanceValidation = InputValidation(value: inductance, error: null);
    } else {
      _inductanceValidation = InputValidation(value: null, error: "Invalid inductance value.");
    }
    notifyListeners();
  }

  void validateCapacitance(double? capacitance) {
    if (capacitance == null || capacitance <= 0) {
      _capacitanceValidation = InputValidation(value: null, error: "Invalid capacitance value.");
    } else {
      _capacitanceValidation = InputValidation(value: capacitance, error: null);
    }
    notifyListeners();
  }

  bool validate() {
    return (_inductanceValidation.value != null && _capacitanceValidation.value != null);
  }
}
