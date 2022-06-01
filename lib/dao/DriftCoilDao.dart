import 'package:coiler_app/database/drift_coil_database.dart';
import 'package:coiler_app/entities/CapacitorBank.dart' as entities;
import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/entities/CoilInfo.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:drift/drift.dart';

part 'DriftCoilDao.g.dart';

@DriftAccessor(tables: [Coils, Teslacoils, CapacitorBank, Toploads])
class DriftCoilDao extends DatabaseAccessor<DriftCoilDatabase> with _$DriftCoilDaoMixin {
  DriftCoilDao(DriftCoilDatabase attachedDatabase) : super(attachedDatabase);

  Stream<List<CoilForm>> getCoilsStream() {
    return select((coils)).watch();
  }

  Future<void> insertCoil(Coil coil) async {
    into(teslacoils).insert(
      TeslaCoil(
        type: coil.coilInfo.coilType,
        name: coil.coilInfo.coilName,
        description: "",
        primaryFrequency: 0.0,
        secondaryFrequency: 0.0,
      ),
    );
  }

  Future deleteCoil(Coil coil) {
    return (delete(teslacoils)..where((tbl) => tbl.id.equals(coil.id))).go();
  }

  Future deletePrimary(Coil coil) {
    if (coil.primaryCoil == null) {
      return Future.value();
    }
    return (delete(coils)..where((tbl) => tbl.id.equals(coil.primaryCoil!.id))).go();
  }

  Future insertPrimary(Coil fullCoil) {
    return (into(coils).insert(
        CoilForm(
          primary_id: fullCoil.id,
          secondary_id: null,
          type: fullCoil.primaryCoil?.coilType ?? -1,
          turns: fullCoil.primaryCoil?.turns ?? 0,
          inductance: fullCoil.primaryCoil?.inductance ?? 0.0,
          wireDiameter: fullCoil.primaryCoil?.wireDiameter ?? 0.0,
          wireSpacing: fullCoil.primaryCoil?.turnSpacing ?? 0.0,
          coilDiameter: fullCoil.primaryCoil?.coilDiameter ?? 0.0,
          innerDiameter: fullCoil.primaryCoil?.innerDiameter ?? 0.0,
        ),
        mode: InsertMode.insertOrIgnore));
    //onConflict: DoUpdate((old) => );
  }

  Future updatePrimaryCoil(Coil coil) {
    print("COIL UPDATE:\n${coil.primaryCoil.toString()}");
    return (update(coils)
          ..where(
            (tbl) => tbl.primary_id.equals(coil.id),
          ))
        .write(
      CoilForm(
        type: coil.primaryCoil?.coilType ?? 0,
        turns: coil.primaryCoil?.turns ?? 0,
        inductance: coil.primaryCoil?.inductance ?? 0.0,
        wireDiameter: coil.primaryCoil?.wireDiameter ?? 0.0,
        wireSpacing: coil.primaryCoil?.turnSpacing ?? 0.0,
        coilDiameter: coil.primaryCoil?.coilDiameter ?? 0.0,
        innerDiameter: coil.primaryCoil?.innerDiameter ?? 0.0,
      ),
    );
  }

  Future insertCapacitorBank(Coil coil) {
    final capacitor = coil.mmc;
    if (capacitor == null) {
      return Future.error("Error inserting capacitor bank!");
    }
    return (into(capacitorBank).insert(
      CoilCapacitor(
        coilId: coil.id,
        capacitance: capacitor.capacitance,
        seriesCapacitorCount: capacitor.seriesCapacitorCount,
        parallelCapacitorCount: capacitor.parallelCapacitorCount,
        capacitorName: capacitor.capacitorName,
        bankVoltage: capacitor.bankVoltage,
        singleCapacitorCapacitance: capacitor.singleCapacitorCapacitance,
        singleCapVoltage: capacitor.singleCapacitorVoltage,
      ),
    ));
  }

  Future updateCapacitorBank(Coil coil) {
    final _capacitorBank = coil.mmc;
    if (_capacitorBank == null) {
      return Future.error("Capacitor bank value is null");
    }
    return (update(capacitorBank)..where((tbl) => tbl.coilId.equals(coil.id))).write(
      CoilCapacitor(
        capacitance: _capacitorBank.capacitance,
        singleCapacitorCapacitance: _capacitorBank.singleCapacitorCapacitance,
        bankVoltage: _capacitorBank.bankVoltage,
        singleCapVoltage: _capacitorBank.singleCapacitorVoltage,
        seriesCapacitorCount: _capacitorBank.seriesCapacitorCount,
        parallelCapacitorCount: _capacitorBank.parallelCapacitorCount,
        capacitorName: _capacitorBank.capacitorName,
      ),
    );
  }

  Future deleteCapacitorBank(Coil coil) {
    if (coil.mmc == null) {
      return Future.error("Unable to delete capacitor bank: bank is null");
    }
    return (delete(capacitorBank)..where((tbl) => tbl.coilId.equals(coil.id))).go();
  }

  Future insertTopload(Coil coil) {
    final topload = coil.topload;

    if (topload == null) {
      return Future.value();
    }

    return (into(toploads).insert(
      CoilTopload(
        type: topload.type,
        capacitance: topload.capacitance,
        sphereDiameter: topload.sphereDiameter,
        toroidMajorDiameter: topload.toroidMajorDiameter,
        toroidMinorDiameter: topload.toroidMinorDiameter,
      ),
    ));
  }

  Future updateCoilInfo(Coil coil) {
    return (update(teslacoils)..where((tbl) => tbl.id.equals(coil.id))).write(
      TeslaCoil(
        type: coil.coilInfo.coilType,
        name: coil.coilInfo.coilName,
        description: coil.coilInfo.coilDesc,
        primaryFrequency: coil.coilInfo.primaryResonantFrequency,
        secondaryFrequency: coil.coilInfo.secondaryResonantFrequency,
      ),
    );
  }

  Stream<List<Coil>> getCoils() {
    final primary_alias = alias(coils, 'p');
    final secondary_alias = alias(coils, 's');

    return select(teslacoils)
        .join([
          leftOuterJoin(primary_alias, primary_alias.primary_id.equalsExp(teslacoils.id)),
          leftOuterJoin(secondary_alias, secondary_alias.secondary_id.equalsExp(teslacoils.id)),
          leftOuterJoin(capacitorBank, capacitorBank.coilId.equalsExp(teslacoils.id))
        ])
        .watch()
        .map(
          (rows) {
            if (rows.isNotEmpty) {
              //print(rows.first.rawData.data);
            }
            return rows.map((e) {
              var fullCoil = Coil();

              var coilInfo = e.readTable(teslacoils);

              fullCoil.id = coilInfo.id;
              var coilInfoObj = CoilInfo(
                coilName: coilInfo.name,
                coilDesc: coilInfo.description,
                coilType: coilInfo.type,
                primaryResonantFrequency: coilInfo.primaryFrequency,
                secondaryResonantFrequency: coilInfo.secondaryFrequency,
              );

              fullCoil.coilInfo = coilInfoObj;

              var primary = e.readTableOrNull(primary_alias);
              var capBankTable = e.readTableOrNull(capacitorBank);

              // Primary coil information
              if (primary != null) {
                PrimaryCoil _primaryCoil = PrimaryCoil(
                  id: primary.id,
                  coilType: primary.type,
                  inductance: primary.inductance,
                  turns: primary.turns,
                  wireDiameter: primary.wireDiameter,
                  turnSpacing: primary.wireSpacing,
                  coilDiameter: primary.coilDiameter,
                  innerDiameter: primary.innerDiameter,
                );

                fullCoil.primaryCoil = _primaryCoil;
              }

              // MMC information
              if (capBankTable != null) {
                entities.CapacitorBank capacitorBank = entities.CapacitorBank(
                  id: capBankTable.id,
                  capacitance: capBankTable.capacitance,
                  bankVoltage: capBankTable.bankVoltage,
                  singleCapacitorVoltage: capBankTable.singleCapVoltage,
                  singleCapacitorCapacitance: capBankTable.singleCapacitorCapacitance,
                  seriesCapacitorCount: capBankTable.seriesCapacitorCount,
                  parallelCapacitorCount: capBankTable.parallelCapacitorCount,
                );

                fullCoil.mmc = capacitorBank;
              }

              return fullCoil;
            }).toList();
          },
        );
  }

  /*Future<void> insertCoil(Coil coil) {
    return into(coils).insert(coil);
  }*/
}
