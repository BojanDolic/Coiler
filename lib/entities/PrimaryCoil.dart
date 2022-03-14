class PrimaryCoil {
  String coilType;
  int turns;
  double frequency;
  double inductance;
  double coilDiameter;
  double wireDiameter;
  double wireSpacing;

  ///For flat coil
  double innerDiameter;

  PrimaryCoil({
    this.coilType = "",
    this.turns = 0,
    this.frequency = 0.0,
    this.inductance = 0.0,
    this.coilDiameter = 0.0,
    this.wireDiameter = 0.0,
    this.wireSpacing = 0.0,
    this.innerDiameter = 0.0,
  });

  factory PrimaryCoil.fromDatabase(String databaseValue) {
    var list = databaseValue.split(",");
    return PrimaryCoil(
      frequency: double.parse(list[0]),
      turns: int.parse(list[1]),
      inductance: double.parse(list[2]),
      coilType: list[3],
    );
  }

  String toDatabaseString() => "$frequency,$turns,$inductance,$coilType";
}
