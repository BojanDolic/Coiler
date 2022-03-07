import 'package:floor/floor.dart';

@entity
class Coil {
  @primaryKey
  final int? id;

  final String coilName;
  final String coilDesc;
  final String coilType;

  double resonantFrequency;

  Coil(this.id, this.coilName, this.coilDesc, this.coilType,
      this.resonantFrequency);
}
