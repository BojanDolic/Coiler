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
    final converter = Converter();

    return "== PRIMARY COIL INFO =="
        "\nCoil type: ${Converter.getCoilComponentType(ComponentType.values[coilType])}"
        "\nNumber of turns: $turns"
        "\nInductance: $inductance H"
        "\nWire diameter: ${converter.convertFromDefaultToMili(wireDiameter)}mm"
        "${wireSpacing != 0 ? "\nWire spacing: ${converter.convertFromDefaultToMili(wireSpacing)}mm" : ""}"
        "\nCoil diameter: ${converter.convertFromDefaultToMili(coilDiameter)}mm"
        "${innerDiameter != 0 ? "\n${converter.convertFromDefaultToMili(innerDiameter)}mm" : ""}";
  }

  double getCoilHeight() {
    return turns * (wireSpacing + wireDiameter);
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
