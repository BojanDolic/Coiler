import 'package:coiler_app/database/drift_coil_database.dart';
import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/entities/CoilInfo.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:drift/drift.dart';

part 'DriftCoilDao.g.dart';

@DriftAccessor(tables: [Coils, Teslacoils])
class DriftCoilDao extends DatabaseAccessor<DriftCoilDatabase>
    with _$DriftCoilDaoMixin {
  DriftCoilDao(DriftCoilDatabase attachedDatabase) : super(attachedDatabase);

  Stream<List<CoilForm>> getCoilsStream() {
    return select((coils)).watch();
  }

  Future<void> insertCoil(Coil coil) async {
    transaction(() async {
      var coilId = await into(teslacoils).insert(
        TeslaCoil(
          type: coil.coilInfo.coilType,
          name: coil.coilInfo.coilName,
          description: "",
          primaryFrequency: 0.0,
          secondaryFrequency: 0.0,
        ),
      );
    });
  }

  Future insertPrimary(Coil fullCoil) {
    return (into(coils).insert(
      CoilForm(
        primary_id: fullCoil.id,
        secondary_id: null,
        type: 'HELICAL',
        inductance: fullCoil.primaryCoil?.inductance ?? 0.0,
        wireDiamter: fullCoil.primaryCoil?.wireDiameter ?? 0.0,
        wireSpacing: fullCoil.primaryCoil?.wireSpacing ?? 0.0,
        coilDiameter: fullCoil.primaryCoil?.coilDiameter ?? 0.0,
      ),
    ));
    //onConflict: DoUpdate((old) => );
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
          leftOuterJoin(
              primary_alias, primary_alias.primary_id.equalsExp(teslacoils.id)),
          leftOuterJoin(secondary_alias,
              secondary_alias.secondary_id.equalsExp(teslacoils.id))
        ])
        .watch()
        .map(
          (rows) {
            if (rows.isNotEmpty) {
              print(rows.first.rawData.data);
            }
            return rows.map((e) {
              var fullCoil = Coil();

              var coilInfo = e.readTable(teslacoils);

              fullCoil.id = coilInfo.id;
              var coilInfoObj = CoilInfo(
                coilName: coilInfo.name,
                coilDesc: coilInfo.description,
                coilType: coilInfo.type,
              );

              fullCoil.coilInfo = coilInfoObj;

              var primary = e.readTableOrNull(primary_alias);
              print("Primary coil value from DB: $primary");

              if (primary != null) {
                PrimaryCoil _primaryCoil = PrimaryCoil(
                  id: primary.id,
                  coilType: primary.type,
                  inductance: primary.inductance,
                );

                fullCoil.primaryCoil = _primaryCoil;
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
