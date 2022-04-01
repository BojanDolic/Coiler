import 'package:coiler_app/entities/CoilInfo.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';

class Coil {
  int? id;
  CoilInfo coilInfo;
  PrimaryCoil? primaryCoil;
  //PrimaryComponents? primaryComponents;
  //PrimaryCoilTable? primary;

  Coil({this.id, this.primaryCoil}) : coilInfo = CoilInfo();
}
