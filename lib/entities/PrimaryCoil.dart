import 'package:coiler_app/entities/FlatCoil.dart';
import 'package:coiler_app/entities/HelicalCoil.dart';
import 'package:coiler_app/entities/mixins/BaseCoil.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';

class PrimaryCoil with BaseCoil {
  int? id;
  int coilType;
  double frequency; // Use maybe when calculating coil self-capacitance

  @override
  double inductance = 0.0;
  @override
  int turns = 0;
  @override
  double wireDiameter = 0.0;
  @override
  double turnSpacing = 0.0;

  /// For helical coil
  double coilDiameter;

  /// For flat coil
  double innerDiameter;

  PrimaryCoil({
    this.id,
    this.coilType = 0,
    this.frequency = 0.0,
    this.wireDiameter = 0.0,
    this.inductance = 0.0,
    this.turns = 0,
    this.turnSpacing = 0.0,
    this.coilDiameter = 0.0,
    this.innerDiameter = 0.0,
  });

  HelicalCoil toHelicalCoil() {
    return HelicalCoil(
      inductance: inductance,
      coilDiameter: coilDiameter,
      turnSpacing: turnSpacing,
      wireDiameter: wireDiameter,
      turns: turns,
    );
  }

  FlatCoil toFlatCoil() {
    return FlatCoil(
      inductance: inductance,
      turns: turns,
      innerDiameter: innerDiameter,
      wireDiameter: wireDiameter,
      turnSpacing: turnSpacing,
    );
  }

  @override
  String toString() {
    final converter = Converter();

    return "== PRIMARY COIL INFO =="
        "\nCoil type: ${Converter.getCoilComponentType(ComponentType.values[coilType])}"
        "\nNumber of turns: $turns"
        "\nInductance: $inductance H"
        "\nWire diameter: ${converter.convertFromDefaultToMili(wireDiameter)}mm"
        "${turnSpacing != 0 ? "\nWire spacing: ${converter.convertFromDefaultToMili(turnSpacing)}mm" : ""}"
        "\nCoil diameter: ${converter.convertFromDefaultToMili(coilDiameter)}mm"
        "${innerDiameter != 0 ? "\n${converter.convertFromDefaultToMili(innerDiameter)}mm" : ""}";
  }

  @override
  bool operator ==(Object other) {
    return (other is PrimaryCoil &&
        other.inductance == inductance &&
        other.coilDiameter == coilDiameter &&
        other.turns == turns &&
        other.turnSpacing == turnSpacing &&
        other.wireDiameter == wireDiameter &&
        other.innerDiameter == innerDiameter);
  }

  String toDatabaseString() => "$frequency,$turns,$inductance,$coilType";
}
