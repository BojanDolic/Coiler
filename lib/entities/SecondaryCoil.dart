class SecondaryCoil {
  double frequency;
  int turns;
  double wireDiameter;
  double inductance;
  double wireSpacing;

  SecondaryCoil({
    this.frequency = 0.0,
    this.inductance = 0.0,
    this.turns = 0,
    this.wireDiameter = 0.0,
    this.wireSpacing = 0.0,
  });

  factory SecondaryCoil.fromDatabase(String databaseValue) {
    var list = databaseValue.split(",");
    return SecondaryCoil(
      frequency: double.parse(list[0]),
      inductance: double.parse(list[1]),
      wireDiameter: double.parse(list[2]),
      wireSpacing: double.parse(list[3]),
      turns: int.parse(list[4]),
    );
  }

  String toDatabaseString() =>
      "$frequency,$inductance,$wireDiameter,$wireSpacing,$turns";
}
