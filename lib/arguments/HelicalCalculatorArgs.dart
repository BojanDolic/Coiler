import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:coiler_app/entities/SecondaryCoil.dart';

class HelicalCoilArgs {
  final PrimaryCoil? primaryCoil;
  final SecondaryCoil? secondaryCoil;
  final bool editing;

  HelicalCoilArgs.primary({this.primaryCoil, this.editing = false}) : secondaryCoil = null;
  HelicalCoilArgs.secondary(this.secondaryCoil, this.editing) : primaryCoil = null;
}
