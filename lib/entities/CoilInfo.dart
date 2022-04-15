class CoilInfo {
  String coilName;
  String coilDesc;
  String coilType;
  double primaryResonantFrequency;
  double secondaryResonantFrequency;

  CoilInfo({
    this.coilName = "",
    this.coilDesc = "",
    this.coilType = "",
    this.primaryResonantFrequency = 0.0,
    this.secondaryResonantFrequency = 0.0,
  });

  @override
  String toString() {
    return '== COIL INFO ==\n'
        'Coil type: $coilType\n'
        'Coil name: $coilName\n'
        'Coil description: $coilDesc\n'
        'Primary resonant frequency: ${primaryResonantFrequency != 0 ? "$primaryResonantFrequency Hz" : "Not calculated"}\n'
        'Secondary resonant frequency: ${secondaryResonantFrequency != 0 ? "$secondaryResonantFrequency Hz" : "Not calculated"}\n'
        '==            ==';
  }
}
