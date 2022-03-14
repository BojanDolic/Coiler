import 'package:coiler_app/entities/CapacitorBank.dart';
import 'package:coiler_app/entities/HelicalPrimary.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:coiler_app/entities/SecondaryCoil.dart';
import 'package:coiler_app/entities/Sparkgap.dart';
import 'package:coiler_app/entities/SphereTopload.dart';
import 'package:coiler_app/entities/ToroidTopload.dart';
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
  HelicalPrimaryCoil? helicalPrimary;
  SecondaryCoil secondary;
  Sparkgap sparkGap;
  SphereTopload? sphereTopload;
  ToroidTopload? toroidTopload;

  Coil({
    this.id,
    this.coilName = "",
    this.coilDesc = "",
    this.coilType = "",
    required this.mmcBank,
    required this.primary,
    this.helicalPrimary,
    required this.secondary,
    this.toroidTopload,
    this.sphereTopload,
    required this.sparkGap,
  });

  void setSphereTopLoad(SphereTopload topload) {
    sphereTopload = topload;
    toroidTopload = null;
  }

  void setToroidTopLoad(ToroidTopload topload) {
    toroidTopload = topload;
    sphereTopload = null;
  }
}
