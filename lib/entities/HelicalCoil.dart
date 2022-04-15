/// Wrapper class for PrimaryCoil.dart and SecondaryCoil.dart
class HelicalCoil {
  double inductance;
  int turns;
  double coilDiameter;
  double wireDiameter;
  double wireSpacing;

  HelicalCoil({
    this.inductance = 0.0,
    this.turns = 0,
    this.coilDiameter = 0.0,
    this.wireDiameter = 0.0,
    this.wireSpacing = 0.0,
  });
}
