import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:coiler_app/util/constants.dart';

class FlatCoil {
  final coilType = ComponentType.flatCoil.index;
  double inductance = 0.0;
  int turns = 0;
  double innerDiameter = 0.0;
  double wireDiameter = 0.0;
  double turnSpacing = 0.0;

  FlatCoil({
    this.inductance = 0.0,
    this.turns = 0,
    this.innerDiameter = 0.0,
    this.wireDiameter = 0.0,
    this.turnSpacing = 0.0,
  });

  PrimaryCoil toPrimaryCoil() {
    return PrimaryCoil(
      inductance: inductance,
      innerDiameter: innerDiameter,
      coilType: coilType,
      turnSpacing: turnSpacing,
      turns: turns,
      wireDiameter: wireDiameter,
    );
  }
}
