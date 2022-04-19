import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/util/conversion.dart';

import 'constants.dart';

class Util {
  static bool isSolidStateCoil(Coil coil) {
    return coil.coilInfo.coilType == Converter.getCoilType(CoilType.SSTC);
  }

  static bool isSparkGapCoil(Coil coil) {
    return coil.coilInfo.coilType == Converter.getCoilType(CoilType.SPARK_GAP);
  }

  static bool isDualResonantCoil(Coil coil) {
    return coil.coilInfo.coilType == Converter.getCoilType(CoilType.DRSSTC);
  }

  static bool hasPrimary(Coil coil) {
    return coil.primaryCoil != null;
  }

  static bool hasPrimaryComponents(Coil coil) {
    return (coil.primaryCoil != null);
  }

  static double getHeightToWidthRatio(double height, double width) {
    return height / width;
  }

  /*static bool hasSecondary(FullCoil coil) {
    return coil
  }*/
}
