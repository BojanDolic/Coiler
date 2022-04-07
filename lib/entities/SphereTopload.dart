class SphereTopload {
  double capacitance;
  double radius;

  SphereTopload({
    this.radius = 0.0,
    this.capacitance = 0.0,
  });

  static SphereTopload? fromDatabase(String? databaseValue) {
    if (databaseValue == null) {
      return null;
    } else {
      var list = databaseValue.split(",");
      return SphereTopload(
        capacitance: double.parse(list[0]),
        radius: double.parse(list[1]),
      );
    }
  }

  static String? toDatabaseString(SphereTopload? value) {
    if (value == null) {
      return null;
    }
    return "${value.capacitance},${value.radius}";
  }
}
