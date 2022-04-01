import 'dart:io';

import 'package:coiler_app/dao/DriftCoilDao.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_coil_database.g.dart';

@DataClassName("TeslaCoil")
class Teslacoils extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  RealColumn get primaryFrequency => real()();
  RealColumn get secondaryFrequency => real()();
}

@DataClassName("CoilForm")
class Coils extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  IntColumn get primary_id => integer()
      .customConstraint("UNIQUE")
      .nullable()
      .references(Teslacoils, #id)(); //.references(Teslacoils, #id)();
  IntColumn get secondary_id => integer()
      .customConstraint("UNIQUE")
      .nullable()
      .references(Teslacoils, #id)(); //.references(Teslacoils, #id)();
  TextColumn get type => text()();
  RealColumn get inductance => real()();
  RealColumn get wireDiamter => real()();
  RealColumn get wireSpacing => real()();
  RealColumn get coilDiameter => real()();
}

@DriftDatabase(tables: [Teslacoils, Coils], daos: [DriftCoilDao])
class DriftCoilDatabase extends _$DriftCoilDatabase {
  DriftCoilDatabase(QueryExecutor e) : super(_openConnection());

  //DriftCoilDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, "drift_coil_database.db"));
    return NativeDatabase(file);
  });
}
