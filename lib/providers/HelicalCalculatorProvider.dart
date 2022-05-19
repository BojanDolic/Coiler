import 'package:coiler_app/calculator/calculator.dart';
import 'package:coiler_app/entities/HelicalCoil.dart';
import 'package:coiler_app/entities/Validation.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:flutter/cupertino.dart';

class HelicalProvider extends ChangeNotifier {
  InputValidation<int> _turns = InputValidation<int>(value: null, error: null);
  InputValidation<double> _wireDiameter = InputValidation<double>(value: null, error: null);
  InputValidation<double> _coilDiameter = InputValidation(value: null, error: null);
  InputValidation<double> _turnSpacing = InputValidation(value: null, error: null);

  Units _inductanceUnit = Units.MICRO;
  Units _coilDiameterUnit = Units.MILI;
  Units _wireDiameterUnit = Units.MILI;
  Units _turnSpacingUnit = Units.MILI;

  String inductance = "";

  InputValidation get turns => _turns;
  InputValidation get wireDiameter => _wireDiameter;
  InputValidation get coilDiameter => _coilDiameter;
  InputValidation get turnSpacing => _turnSpacing;

  Units get inductanceUnit => _inductanceUnit;
  Units get wireDiameterUnit => _wireDiameterUnit;
  Units get coilDiameterUnit => _coilDiameterUnit;
  Units get turnSpacingUnit => _turnSpacingUnit;

  bool _editing = false;

  set editing(bool value) {
    _editing = value;
    notifyListeners();
  }

  bool get editing => _editing;

  /// Performs data parsing and calculates inductance of the coil
  void calculateInductance() {
    if (!validate) {
      return;
    }
    parseAndCalculateResult();
    notifyListeners();
  }

  void parseAndCalculateResult() {
    final wireDiamTemp = Converter().convertToDefault(_wireDiameter.value, _wireDiameterUnit);
    final coilDiamTemp = Converter().convertToDefault(_coilDiameter.value, _coilDiameterUnit);
    final turnSpacingTemp = Converter().convertToDefault(_turnSpacing.value, _turnSpacingUnit);

    final tempInductance = Calculator().calculateSpiralCoilInductance(_turns.value!, coilDiamTemp, wireDiamTemp, turnSpacingTemp, Units.DEFAULT);

    final inductance = Converter().convertUnits(tempInductance, Units.MICRO, inductanceUnit);

    this.inductance = inductance.toStringAsFixed(7);
  }

  dynamic saveCoil() {
    return convertToDefaultValuesAndReturn();
  }

  dynamic convertToDefaultValuesAndReturn() {
    final wireDiamTemp = Converter().convertToDefault(_wireDiameter.value, _wireDiameterUnit);
    final coilDiamTemp = Converter().convertToDefault(_coilDiameter.value, _coilDiameterUnit);
    final turnSpacingTemp = Converter().convertToDefault(_turnSpacing.value, _turnSpacingUnit);

    final inductance = Converter().convertToDefault(double.parse(this.inductance), inductanceUnit);

    return HelicalCoil(
      turns: turns.value,
      inductance: inductance,
      coilDiameter: coilDiamTemp,
      wireDiameter: wireDiamTemp,
      turnSpacing: turnSpacingTemp,
    );
  }

  void calculateResult() {
    final tempInductance =
        Calculator().calculateSpiralCoilInductance(_turns.value!, _coilDiameter.value!, _wireDiameter.value!, _turnSpacing.value!, Units.DEFAULT);

    final inductance = Converter().convertUnits(tempInductance, Units.MICRO, inductanceUnit);

    this.inductance = inductance.toStringAsFixed(7);
  }

  void validateTurns(int? value) {
    if (value != null && value > 0 && value < 2501) {
      _turns = InputValidation<int>(value: value, error: null);
    } else {
      _turns = InputValidation(value: null, error: "Enter valid number of turns (1-2500)");
    }
    notifyListeners();
  }

  void validateWireDiameter(double? value) {
    if (value != null && value > 0) {
      _wireDiameter = InputValidation<double>(value: value, error: null);
    } else {
      _wireDiameter = InputValidation(value: null, error: "Enter valid wire diameter!");
    }
    notifyListeners();
  }

  void validateCoilDiameter(double? value) {
    if (value != null && value > 0) {
      _coilDiameter = InputValidation<double>(value: value, error: null);
    } else {
      _coilDiameter = InputValidation(value: null, error: "Enter valid coil diameter!");
    }
    notifyListeners();
  }

  void validateTurnSpacing(double? value) {
    if (value != null && value > -1) {
      _turnSpacing = InputValidation<double>(value: value, error: null);
    } else {
      _turnSpacing = InputValidation(value: null, error: "Enter valid turn spacing!");
    }
    notifyListeners();
  }

  void setTurns(int turns) {
    _turns = InputValidation<int>(value: turns, error: null);
    notifyListeners();
  }

  void setWireDiameter(double wireDiameter) {
    _wireDiameter = InputValidation<double>(value: wireDiameter, error: null);
    notifyListeners();
  }

  void setCoilDiameter(double diameter) {
    _coilDiameter = InputValidation<double>(value: diameter, error: null);
    notifyListeners();
  }

  void setTurnSpacing(double spacing) {
    _turnSpacing = InputValidation<double>(value: spacing, error: null);
    notifyListeners();
  }

  void setInductanceUnit(Units unit) {
    _inductanceUnit = unit;
    notifyListeners();
  }

  void setWireDiameterUnit(Units unit) {
    _wireDiameterUnit = unit;
    notifyListeners();
  }

  void setCoilDiameterUnit(Units unit) {
    _coilDiameterUnit = unit;
    notifyListeners();
  }

  void setTurnSpacingUnit(Units unit) {
    _turnSpacingUnit = unit;
    notifyListeners();
  }

  bool get validate {
    return (_turns.value != null && _wireDiameter.value != null && _turnSpacing.value != null && _coilDiameter.value != null);
  }
}
