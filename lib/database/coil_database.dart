import 'dart:async';

import 'package:coiler_app/dao/CoilDao.dart';
import 'package:coiler_app/entities/Coil.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'coil_database.g.dart'; // the generated code will be there

@Database(version: 7, entities: [Coil])
abstract class CoilsDatabase extends FloorDatabase {
  CoilDao get coilDao;
}
