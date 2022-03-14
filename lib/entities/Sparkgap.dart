class Sparkgap {
  double distance;

  Sparkgap({
    this.distance = 0.0,
  });

  factory Sparkgap.fromDatabase(String databaseValue) {
    var list = databaseValue.split(",");
    return Sparkgap(
      distance: double.parse(list[0]),
    );
  }

  String toDatabaseString() => "$distance,";
}
