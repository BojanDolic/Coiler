import 'package:coiler_app/entities/Primary.dart';

/// Helical coil used for primary of the tesla coil
class HelicalCoil extends Primary {
  /* double inductance;
  int turns;
  double wireSpacing;*/
  //double wireDiameter;
  double coilDiameter;

  HelicalCoil({
    /*this.inductance = 0.0,
    this.turns = 0,
    this.wireSpacing = 0.0,
    this.wireDiameter = 0.0,*/
    this.coilDiameter = 0.0,
  });

  //HelicalCoil.fromJson(Map<String, dynamic> json)

  /*{
    super.inductance = json["inductance"];
    coilDiameter = json["coilDiameter"];
  }*/
  /*: superinductance = json["inductance"],
        turns = json["turns"],
        wireSpacing = json["wireSpacing"],
        wireDiameter = json["wireDiameter"],
        coilDiameter = json["coilDiameter"];*/

  static Map<String, dynamic> toJson(HelicalCoil coil) {
    return {
      "inductance": coil.inductance,
      "turns": coil.turns,
      "wireSpacing": coil.wireSpacing,
      "wireDiameter": coil.wireDiameter,
      "coilDiameter": coil.coilDiameter,
    };
  }
}
