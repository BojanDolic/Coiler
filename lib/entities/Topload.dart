class Topload {
  int type;
  double capacitance;
  double sphereDiameter;
  double toroidMajorDiameter;
  double toroidMinorDiameter;

  Topload({
    this.type = 0,
    this.capacitance = 0.0,
    this.sphereDiameter = 0.0,
    this.toroidMajorDiameter = 0.0,
    this.toroidMinorDiameter = 0.0,
  });

  @override
  String toString() {
    return "\n\nTOPLOAD INFO\n\nCapacitance: $capacitance\n";
  }
}
