import 'package:coiler_app/entities/CapacitorBank.dart';
import 'package:coiler_app/entities/CoilInfo.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:coiler_app/entities/SecondaryCoil.dart';
import 'package:coiler_app/entities/Topload.dart';

class Coil {
  int? id;
  CoilInfo coilInfo;
  PrimaryCoil? primaryCoil;
  SecondaryCoil? secondaryCoil;
  CapacitorBank? mmc;
  Topload? topload;

  Coil({this.id, this.primaryCoil, this.secondaryCoil, this.mmc, this.topload}) : coilInfo = CoilInfo();

  @override
  String toString() {
    return 'COIL SPECIFICATIONS\n\n'
        '${coilInfo.toString()}\n\n'
        '${primaryCoil.toString()}';
  }
}
