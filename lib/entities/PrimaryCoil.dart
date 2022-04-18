import 'package:coiler_app/entities/HelicalCoil.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';

class PrimaryCoil extends HelicalCoil {
  int? id;
  int coilType;
  int turns;
  double frequency;
  double inductance;
  double coilDiameter;
  double wireDiameter;
  double wireSpacing;

  ///For flat coil
  double innerDiameter;

  PrimaryCoil({
    this.id,
    this.coilType = 0,
    this.turns = 0,
    this.frequency = 0.0,
    this.inductance = 0.0,
    this.coilDiameter = 0.0,
    this.wireDiameter = 0.0,
    this.wireSpacing = 0.0,
    this.innerDiameter = 0.0,
  });

  @override
  String toString() {
    return "== PRIMARY COIL INFO ==\n"
        "Coil type: ${Converter.getCoilComponentType(ComponentType.values[coilType])}\n"
        "Number of turns: $turns \n"
        "Inductance: $inductance H\n"
        "==                   ==";
  }

  bool operator ==(Object other) {
    return (other is PrimaryCoil &&
        other.inductance == inductance &&
        other.coilDiameter == coilDiameter &&
        other.turns == turns &&
        other.wireSpacing == wireSpacing &&
        other.wireDiameter == wireDiameter &&
        other.innerDiameter == innerDiameter);
  }

  String toDatabaseString() => "$frequency,$turns,$inductance,$coilType";
}
