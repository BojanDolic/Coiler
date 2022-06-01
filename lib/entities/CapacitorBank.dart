/// This refers to MMC
class CapacitorBank {
  int? id;
  int seriesCapacitorCount;
  int parallelCapacitorCount;
  int bankVoltage;
  int singleCapacitorVoltage;
  double capacitance;
  double singleCapacitorCapacitance;
  String capacitorName;

  CapacitorBank({
    this.id,
    this.capacitance = 0.0,
    this.seriesCapacitorCount = 0,
    this.parallelCapacitorCount = 0,
    this.bankVoltage = 0,
    this.singleCapacitorCapacitance = 0.0,
    this.singleCapacitorVoltage = 0,
    this.capacitorName = "",
  });
}
