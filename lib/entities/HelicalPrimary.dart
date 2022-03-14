class HelicalPrimaryCoil {
  double inductance;
  int turns;
  double wireSpacing;
  double wireDiameter;
  double coilDiameter;

  HelicalPrimaryCoil({
    this.inductance = 0.0,
    this.turns = 0,
    this.wireSpacing = 0.0,
    this.wireDiameter = 0.0,
    this.coilDiameter = 0.0,
  });

  HelicalPrimaryCoil.fromJson(Map<String, dynamic> json)
      : inductance = json["inductance"],
        turns = json["turns"],
        wireSpacing = json["wireSpacing"],
        wireDiameter = json["wireDiameter"],
        coilDiameter = json["coilDiameter"];

  static Map<String, dynamic> toJson(HelicalPrimaryCoil coil) {
    return {
      "inductance": coil.inductance,
      "turns": coil.turns,
      "wireSpacing": coil.wireSpacing,
      "wireDiameter": coil.wireDiameter,
      "coilDiameter": coil.coilDiameter,
    };
  }
}
