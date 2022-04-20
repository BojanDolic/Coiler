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

  double getCoilHeight() {
    return turns * (wireSpacing + wireDiameter);
  }

  String toDatabaseString() => "$inductance,$wireDiameter,$wireSpacing,$turns";
}
