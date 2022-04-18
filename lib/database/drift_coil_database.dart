import 'dart:io';

import 'package:coiler_app/dao/DriftCoilDao.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'drift_coil_database.g.dart';

@DataClassName("TeslaCoil")
class Teslacoils extends Table {
  IntColumn get id => integer().nullable().autoIncrement().customConstraint("UNIQUE")();
  TextColumn get type => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  RealColumn get primaryFrequency => real()();
  RealColumn get secondaryFrequency => real()();
}

@DataClassName("CoilForm")
class Coils extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  IntColumn get primary_id => integer().nullable().customConstraint("NULL UNIQUE REFERENCES teslacoils(id) ON DELETE CASCADE")();
  IntColumn get secondary_id => integer().nullable().customConstraint("NULL UNIQUE REFERENCES teslacoils(id) ON DELETE CASCADE")();
  IntColumn get type => integer()();
  IntColumn get turns => integer()();
  RealColumn get inductance => real()();
  RealColumn get wireDiameter => real()();
  RealColumn get wireSpacing => real()();
  RealColumn get coilDiameter => real()();
  RealColumn get innerDiameter => real()();
}

class CapacitorBank extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
  IntColumn get coil_id => integer().nullable().customConstraint("NULL UNIQUE REFERENCES teslacoils(id) ON DELETE CASCADE")();
  RealColumn get capacitance => real()();
  IntColumn get voltage => integer()();
  IntColumn get seriesCapacitorCount => integer()();
  IntColumn get parallelCapacitorCount => integer()();
  TextColumn get capacitorName => text().withDefault(const Constant(""))();
}

class Toploads extends Table {
  IntColumn get id => integer().nullable().autoIncrement()();
}

@DriftDatabase(tables: [Teslacoils, Coils], daos: [DriftCoilDao])
class DriftCoilDatabase extends _$DriftCoilDatabase {
  DriftCoilDatabase(QueryExecutor e) : super(_openConnection());

  //DriftCoilDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON;');
      });
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, "drift_coil_database.db"));
    final database = NativeDatabase(file);
    return database;
  });
}
