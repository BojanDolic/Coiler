import 'package:coiler_app/calculator/calculator.dart';
import 'package:coiler_app/entities/FlatCoil.dart';
import 'package:coiler_app/entities/Validation.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:flutter/cupertino.dart';

class FlatCoilProvider extends ChangeNotifier {
  final converter = Converter();
  final calculator = Calculator();

  InputValidation _innerDiameter = InputValidation(value: null, error: null);
  InputValidation _wireDiameter = InputValidation(value: null, error: null);
  InputValidation _turnSpacing = InputValidation(value: null, error: null);
  InputValidation _turns = InputValidation(value: null, error: null);

  bool editing = false;

  double inductance = 0.0;

  InputValidation get innerDiameter => _innerDiameter;
  InputValidation get wireDiameter => _wireDiameter;
  InputValidation get turnSpacing => _turnSpacing;
  InputValidation get turns => _turns;

  Units _inductanceUnit = Units.MILI;
  Units _innerDiameterUnit = Units.MILI;
  Units _wireDiameterUnit = Units.MILI;
  Units _turnSpacingUnit = Units.MILI;

  Units get inductanceUnit => _inductanceUnit;
  Units get innerDiameterUnit => _innerDiameterUnit;
  Units get wireDiameterUnit => _wireDiameterUnit;
  Units get wireSpacingUnit => _turnSpacingUnit;

  void calculateInductance() {
    if (!validate()) {
      return;
    }
    _parseValues();
    notifyListeners();
  }

  void _parseValues() {
    double innerDiameter = converter.convertToDefault(_innerDiameter.value, _innerDiameterUnit);
    double wireDiameter = converter.convertToDefault(_wireDiameter.value, _wireDiameterUnit);
    double turnSpacing = converter.convertToDefault(_turnSpacing.value, _turnSpacingUnit);
    int turns = _turns.value;

    _calculateResult(innerDiameter, wireDiameter, turnSpacing, turns);
  }

  void _calculateResult(double innerDiameter, double wireDiameter, double turnSpacing, int turns) {
    final value = calculator.calculateFlatCoilInductance(turns, innerDiameter, wireDiameter, turnSpacing, Units.DEFAULT);
    inductance = converter.convertUnits(value, Units.DEFAULT, _inductanceUnit);
  }

  void setInductanceUnit(Units unit) {
    _inductanceUnit = unit;
    notifyListeners();
  }

  void setInnerDiameterUnit(Units unit) {
    _innerDiameterUnit = unit;
    notifyListeners();
  }

  void setWireDiameterUnit(Units unit) {
    _wireDiameterUnit = unit;
    notifyListeners();
  }

  void setTurnSpacingUnit(Units unit) {
    _turnSpacingUnit = unit;
    notifyListeners();
  }

  void validateInnerDiameter(double? value) {
    if (value != null && value > 0.0) {
      _innerDiameter = InputValidation(value: value, error: null);
    } else {
      _innerDiameter = InputValidation(value: null, error: "Inner diameter value invalid!");
    }
    notifyListeners();
  }

  void validateWireDiameter(double? diameter) {
    if (diameter != null && diameter > 0.0) {
      _wireDiameter = InputValidation(value: diameter, error: null);
    } else if (diameter == 0) {
      _wireDiameter = InputValidation(value: null, error: "Wire diameter can't be 0");
    } else {
      _wireDiameter = InputValidation(value: null, error: "Invalid wire diameter value!");
    }
    notifyListeners();
  }

  void validateTurnSpacing(double? spacing) {
    if (spacing != null && spacing >= 0.0) {
      _turnSpacing = InputValidation(value: spacing, error: null);
    } else if (spacing != null && spacing < 0) {
      _turnSpacing = InputValidation(value: null, error: "Turn spacing can't be negative!");
    } else {
      _turnSpacing = InputValidation(value: null, error: "Invalid turn spacing value!");
    }
    notifyListeners();
  }

  void validateTurns(int? turns) {
    if (turns != null && turns > 0) {
      _turns = InputValidation(value: turns, error: null);
    } else if (turns != null && turns == 0) {
      _turns = InputValidation(value: null, error: "Coil can't have 0 turns");
    } else {
      _turns = InputValidation(value: null, error: "Invalid turns value!");
    }
    notifyListeners();
  }

  FlatCoil getCoil() {
    //Convert to default units
    final wireDiam = converter.convertToDefault(_wireDiameter.value, _wireDiameterUnit);
    final coilInnerDiam = converter.convertToDefault(_innerDiameter.value, _innerDiameterUnit);
    final turnSpacing = converter.convertToDefault(_turnSpacing.value, _turnSpacingUnit);
    final inductanceTemp = converter.convertToDefault(inductance, inductanceUnit);

    return FlatCoil(
      turns: _turns.value,
      inductance: inductanceTemp,
      innerDiameter: coilInnerDiam,
      turnSpacing: turnSpacing,
      wireDiameter: wireDiam,
    );
  }

  bool validate() {
    return (_innerDiameter.error == null && _wireDiameter.error == null && _turnSpacing.error == null && _turns.error == null);
  }

  void setTurns(int turns) {
    _turns.value = turns;
    notifyListeners();
  }

  void setWireDiameter(double wireDiameter) {
    _wireDiameter.value = wireDiameter;
    notifyListeners();
  }

  void setInnerDiameter(double innerDiameter) {
    _innerDiameter.value = innerDiameter;
    notifyListeners();
  }

  void setTurnSpacing(double spacing) {
    _turnSpacing.value = spacing;
    notifyListeners();
  }
}
