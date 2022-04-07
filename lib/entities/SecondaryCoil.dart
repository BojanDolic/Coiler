class SecondaryCoil {
  int turns;
  double wireDiameter;
  double coilDiameter;
  double inductance;
  double wireSpacing;

  SecondaryCoil({
    this.inductance = 0.0,
    this.turns = 0,
    this.coilDiameter = 0.0,
    this.wireDiameter = 0.0,
    this.wireSpacing = 0.0,
  });

  factory SecondaryCoil.fromDatabase(String databaseValue) {
    var list = databaseValue.split(",");
    return SecondaryCoil(
      inductance: double.parse(list[0]),
      wireDiameter: double.parse(list[1]),
      wireSpacing: double.parse(list[2]),
      turns: int.parse(list[3]),
    );
  }

  String toDatabaseString() => "$inductance,$wireDiameter,$wireSpacing,$turns";
}
