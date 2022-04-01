import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:flutter/cupertino.dart';

/// Provider for single selected coil
class CoilProvider extends ChangeNotifier {
  late Coil coil;

  void setDescription(String desc) {
    coil.coilInfo.coilDesc = desc;
    notifyListeners();
  }

  void setPrimaryResFrequency(double frequency) {
    coil.coilInfo.primaryResonantFrequency = frequency;
    notifyListeners();
  }

  void setPrimaryCoil(PrimaryCoil primaryCoil) {
    coil.primaryCoil = primaryCoil;
    notifyListeners();
  }
}
