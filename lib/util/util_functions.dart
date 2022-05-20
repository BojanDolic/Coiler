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

  /// Function used to return component name based on [type] passed
  ///
  /// **[type]** - Type of the component
  static String getComponentName(ComponentType type) {
    String name = "";

    switch (type) {
      case ComponentType.capacitor:
        name = "MMC";
        break;
      case ComponentType.helicalCoil:
        name = "Helical coil";
        break;
      case ComponentType.flatCoil:
        name = "Flat coil";
        break;
      case ComponentType.ringToroidTopload:
        name = "Ring topload";
        break;
      case ComponentType.fullToroidTopload:
        name = "Toroid topload";
        break;
      case ComponentType.sphereTopload:
        name = "Sphere topload";
        break;
    }
    return name;
  }
}
