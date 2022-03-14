// ignore_for_file: unused_import

import 'dart:async';

import 'package:coiler_app/dao/CoilDao.dart';
import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/type_converters/capacitor_bank_converter.dart';
import 'package:coiler_app/type_converters/helical_primary_converter.dart';
import 'package:coiler_app/type_converters/primary_coil_converter.dart';
import 'package:coiler_app/type_converters/secondary_coil_converter.dart';
import 'package:coiler_app/type_converters/spark_gap_converter.dart';
import 'package:coiler_app/type_converters/sphere_topload_converter.dart';
import 'package:coiler_app/type_converters/toroid_topload_converter.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'coil_database.g.dart'; // the generated code will be there

@TypeConverters([
  CapacitorBankConverter,
  PrimaryCoilConverter,
  HelicalPrimaryConverter,
  SecondaryCoilConverter,
  SparkgapConverter,
  ToroidToploadConverter,
  SphereToploadConverter,
])
@Database(version: 14, entities: [Coil])
abstract class CoilsDatabase extends FloorDatabase {
  CoilDao get coilDao;
}
