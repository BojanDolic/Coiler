class ToroidTopload {
  double capacitance;
  double innerDiameter;
  double outerDiameter;

  ToroidTopload({
    this.capacitance = 0.0,
    this.innerDiameter = 0.0,
    this.outerDiameter = 0.0,
  });

  static ToroidTopload? fromDatabase(String? databaseValue) {
    if (databaseValue == null) {
      return null;
    } else {
      var list = databaseValue.split(",");
      return ToroidTopload(
        capacitance: double.parse(list[0]),
        innerDiameter: double.parse(list[1]),
        outerDiameter: double.parse(list[2]),
      );
    }
  }

  static String? toDatabaseString(ToroidTopload? value) {
    if (value == null) {
      return null;
    }
    return "${value.capacitance},${value.innerDiameter},${value.outerDiameter}";
  }
}
