import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:coiler_app/util/constants.dart';

/// Wrapper class for PrimaryCoil.dart and SecondaryCoil.dart
class HelicalCoil {
  final coilType = ComponentType.helicalCoil.index;
  double inductance = 0.0;
  int turns = 0;
  double coilDiameter = 0.0;
  double wireDiameter = 0.0;
  double turnSpacing = 0.0;

  HelicalCoil({
    this.inductance = 0.0,
    this.coilDiameter = 0.0,
    this.turnSpacing = 0.0,
    this.wireDiameter = 0.0,
    this.turns = 0,
  });

  PrimaryCoil toPrimaryCoil() {
    return PrimaryCoil(
      coilType: coilType,
      wireDiameter: wireDiameter,
      inductance: inductance,
      turns: turns,
      turnSpacing: turnSpacing,
      coilDiameter: coilDiameter,
    );
  }
}
