import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/extension_functions.dart';
import 'package:flutter/cupertino.dart';

/// Provider for single selected coil
class CoilProvider extends ChangeNotifier {
  late Coil _coil;

  set coil(Coil value) {
    _coil = value;
  }

  Coil get coil => _coil;

  void setDescription(String desc) {
    _coil.coilInfo.coilDesc = desc;
    notifyListeners();
  }

  void setPrimaryResFrequency(double frequency) {
    _coil.coilInfo.primaryResonantFrequency = frequency;
    notifyListeners();
  }

  void setPrimaryCoil(PrimaryCoil primaryCoil) {
    _coil.primaryCoil = primaryCoil;
    notifyListeners();
  }

  void removePrimaryCoil() {
    _coil.primaryCoil = null;
    notifyListeners();
  }

  bool hasPrimaryCoil() => _coil.primaryCoil != null;

  bool hasSecondaryCoil() => _coil.secondaryCoil != null;

  String? displayPrimaryInductance() {
    final value = _coil.primaryCoil?.inductance;
    if (value == null) {
      return null;
    }
    return (value > 0) ? value.toStringWithPrefix(3).toHenry() : null;
  }

  String? displayPrimaryResonantFrequency() {
    final frequency = _coil.coilInfo.primaryResonantFrequency;

    if (frequency == 0) {
      return null;
    }

    return frequency.toStringAsFixed(4);
  }

  String? displayPrimaryCapacitance() {
    final capacitance = Converter().convertUnits(_coil.mmc?.capacitance, Units.DEFAULT, Units.NANO);
    return (capacitance > 0) ? capacitance.toStringAsFixed(3) + " nF" : null;
  }

  ComponentType getPrimaryCoilComponentType() => ComponentType.values[_coil.primaryCoil?.coilType ?? 1];
  bool hasCapacitorBank() => _coil.mmc != null;

  bool hasTopload() => _coil.topload != null;

  bool hasPrimaryComponents() {
    return (isSolidStateCoil()) ? (_coil.primaryCoil != null) : (_coil.primaryCoil != null && _coil.mmc != null);
  }

  bool isSolidStateCoil() => _coil.coilInfo.coilType == Converter.getCoilType(CoilType.SSTC);
}
