import 'package:coiler_app/entities/mixins/BaseCoil.dart';

class SecondaryCoil with BaseCoil {
  int? id;
  int coilType;
  double coilDiameter;

  SecondaryCoil({
    this.id,
    this.coilType = 1,
    this.coilDiameter = 0.0,
  });
}
