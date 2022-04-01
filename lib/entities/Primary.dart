class Primary {
  String type;
  double inductance;
  int turns;
  double capacitance;
  double wireDiameter;
  double wireSpacing;
  double coilDiameter;
  double innerCoilDiameter;

  Primary({
    this.type = "",
    this.inductance = 0.0,
    this.turns = 0,
    this.capacitance = 0.0,
    this.wireDiameter = 0.0,
    this.wireSpacing = 0.0,
    this.coilDiameter = 0.0,
    this.innerCoilDiameter = 0.0,
  });

  /*factory Primary.fromJson(Map<String, dynamic> json) {
    if (json["type"] == COIL_TYPE.HELICAL_COIL) {
      return FlatCoil();
      //return HelicalCoil.fromJson(json);
    } else {
      return FlatCoil();
    }
  }*/
  /* : superinductance = json["inductance"],
  turns = json["turns"],
  wireSpacing = json["wireSpacing"],
  wireDiameter = json["wireDiameter"],
  coilDiameter = json["coilDiameter"];
*/
  static Map<String, dynamic> toJson(Primary coil) {
    return {
      "inductance": coil.inductance,
      "turns": coil.turns,
      "wireSpacing": coil.wireSpacing,
      "wireDiameter": coil.wireDiameter,
      //"coilDiameter": coil.coilDiameter,
    };
  }
}
