class PrimaryCoil {
  String coilType;
  int turns;
  double frequency;
  double inductance;

  PrimaryCoil({
    this.coilType = "",
    this.turns = 0,
    this.frequency = 0.0,
    this.inductance = 0.0,
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
