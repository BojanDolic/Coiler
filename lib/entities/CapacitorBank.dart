/// This refers to MMC
class CapacitorBank {
  int seriesCapacitorCount;
  int parallelCapacitorCount;
  double capacitance;

  CapacitorBank({
    this.capacitance = 0.0,
    this.seriesCapacitorCount = 0,
    this.parallelCapacitorCount = 0,
  });

  /*CapacitorBank.empty2() {
    seriesCapacitorCount = 0;
    parallelCapacitorCount = 0;
    capacitance = 0;
  }*/

  factory CapacitorBank.fromDatabase(String databaseValue) {
    var valuesList = databaseValue.split(",");
    return CapacitorBank(
      capacitance: double.parse(
        valuesList.elementAt(0),
      ),
      seriesCapacitorCount: int.parse(
        valuesList.elementAt(1),
      ),
      parallelCapacitorCount: int.parse(
        valuesList.elementAt(2),
      ),
    );
  }

  String toDatabaseString() =>
      "$capacitance,$seriesCapacitorCount,$parallelCapacitorCount,";
}
