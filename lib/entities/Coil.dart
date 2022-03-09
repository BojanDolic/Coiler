import 'package:coiler_app/entities/CapacitorBank.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:floor/floor.dart';

@entity
class Coil {
  @primaryKey
  final int? id;

  String coilName;
  String coilDesc;
  CapacitorBank mmcBank;
  final String coilType;
  PrimaryCoil primary;

  Coil({
    this.id,
    this.coilName = "",
    this.coilDesc = "",
    this.coilType = "",
    required this.mmcBank,
    required this.primary,
  });
}
