import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
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
    final value = Converter().convertToMicro(_coil.primaryCoil?.inductance);
    return (value > 0) ? value.toStringAsFixed(3) + " μH" : null;
  }

  ComponentType getPrimaryCoilComponentType() => ComponentType.values[_coil.primaryCoil?.coilType ?? 1];
  bool hasCapacitorBank() => _coil.mmc != null;

  bool hasTopload() => _coil.topload != null;

  bool hasPrimaryComponents() {
    return (isSolidStateCoil()) ? (_coil.primaryCoil != null) : (_coil.primaryCoil != null && _coil.mmc != null);
  }

  bool isSolidStateCoil() => _coil.coilInfo.coilType == Converter.getCoilType(CoilType.SSTC);
}
