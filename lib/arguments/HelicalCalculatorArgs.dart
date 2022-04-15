import 'package:coiler_app/entities/HelicalCoil.dart';

class HelicalCoilArgs {
  final HelicalCoil? coil;
  final bool editing;

  HelicalCoilArgs({this.coil, this.editing = false});

  /*HelicalCoilArgs.primary({this.primaryCoil, this.editing = false}) : secondaryCoil = null;
  HelicalCoilArgs.secondary(this.secondaryCoil, this.editing) : primaryCoil = null;*/
}
