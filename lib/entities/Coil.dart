import 'package:floor/floor.dart';

@entity
class Coil {
  @primaryKey
  final int? id;

  final String coilName;
  final String coilDesc;

  double resonantFrequency;

  Coil(this.id, this.coilName, this.coilDesc, this.resonantFrequency);
}
