import 'package:coiler_app/calculator/calculator.dart';
import 'package:coiler_app/dao/DriftCoilDao.dart';
import 'package:coiler_app/entities/CapacitorBank.dart';
import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/extension_functions.dart';
import 'package:flutter/cupertino.dart';

/// Provider for single selected coil
class CoilProvider extends ChangeNotifier {
  late Coil _coil;
  final calculator = Calculator();
  final converter = Converter();

  final DriftCoilDao _driftCoilDao;

  CoilProvider(this._driftCoilDao);

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
    primaryCoil.id = _coil.primaryCoil?.id; // Setting id
    _coil.primaryCoil = primaryCoil;
    _checkPrimaryComponents();
    notifyListeners();
  }

  void _checkPrimaryComponents() {
    //Check if components are present
    if (!hasPrimaryComponents()) {
      _removePrimaryFrequency();
      //Clear errors
      return;
    }
    //Calculate resonant frequency
    _calculatePrimaryResonantFrequency();
    notifyListeners();
    // Check for primary errors
  }

  void _removePrimaryFrequency() {
    _coil.coilInfo.primaryResonantFrequency = 0;
    _driftCoilDao.updateCoilInfo(_coil);
    notifyListeners();
  }

  void _calculatePrimaryResonantFrequency() {
    final primaryCoil = _coil.primaryCoil!;
    final capBank = _coil.mmc!;
    final frequency = calculator.calculateResFrequency(primaryCoil.inductance, capBank.capacitance);

    _coil.coilInfo.primaryResonantFrequency = frequency;
    setPrimaryResFrequency(frequency);

    _driftCoilDao.updateCoilInfo(_coil);

    notifyListeners();
  }

  void setCapacitorBank(CapacitorBank? bank) {
    if (bank != null) {
      bank.id = _coil.mmc?.id;
    }
    _coil.mmc = bank;
    _checkPrimaryComponents();
    notifyListeners();
  }

  void removeCapacitorBank() {
    _coil.mmc = null;
    _checkPrimaryComponents();
    notifyListeners();
  }

  void removePrimaryCoil() {
    _coil.primaryCoil = null;
    _checkPrimaryComponents();
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
    final finalFreq = converter.convertUnits(frequency, Units.DEFAULT, Units.KILO);

    return finalFreq.toStringAsFixed(3) + "kHz";
  }

  String? displaySecondaryResonantFrequency() {
    final freq = _coil.coilInfo.secondaryResonantFrequency;

    if (freq == 0) {
      return null;
    }
    return freq.toStringAsFixed(4);
  }

  String? displayPrimaryCapacitance() {
    final _capacitance = _coil.mmc?.capacitance;

    if (_capacitance == null) {
      return null;
    }
    return (_capacitance > 0) ? _capacitance.toStringWithPrefix(2).toFarad() : null;
  }

  String? getToploadCapacitance() {
    final capacitance = _coil.topload?.capacitance;
    if (capacitance == null) {
      return null;
    }

    return (capacitance > 0) ? capacitance.toStringWithPrefix(3).toFarad() : null;
  }

  ComponentType getToploadComponentType() {
    final topload = _coil.topload;

    if (topload == null) {
      return ComponentType.values[4]; // Default to toroid topload
    }

    return ComponentType.values[topload.type];
  }

  ComponentType getPrimaryCoilComponentType() => ComponentType.values[_coil.primaryCoil?.coilType ?? 1];
  bool hasCapacitorBank() => _coil.mmc != null;

  bool hasTopload() => _coil.topload != null;

  bool hasPrimaryComponents() {
    return (isSolidStateCoil()) ? (_coil.primaryCoil != null) : (_coil.primaryCoil != null && _coil.mmc != null);
  }

  bool isSolidStateCoil() => _coil.coilInfo.coilType == Converter.getCoilType(CoilType.SSTC);
}
