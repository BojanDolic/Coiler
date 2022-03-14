import 'package:coiler_app/dao/CoilDao.dart';
import 'package:coiler_app/database/coil_database.dart';
import 'package:coiler_app/screens/calculators/capacitor_screen.dart';
import 'package:coiler_app/screens/calculators/helical_coil_screen.dart';
import 'package:coiler_app/screens/calculators/resonant_freq_screen.dart';
import 'package:coiler_app/screens/calculators_screen.dart';
import 'package:coiler_app/screens/coil_info_screen.dart';
import 'package:coiler_app/screens/coils_list_screen.dart';
import 'package:coiler_app/screens/information_screen.dart';
import 'package:coiler_app/screens/main_screen.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await $FloorCoilsDatabase
      .databaseBuilder("coils_database.db")
      .addMigrations(
    [
      Migration(
        6,
        7,
        (db) {
          return db.update("Coil", {"coilType": ""});
        },
      ),
      Migration(
        7,
        8,
        (db) {
          return db.execute(
              "ALTER TABLE Coil ADD COLUMN mmcBank TEXT NOT NULL DEFAULT \'0,0,\'");
        },
      ),
      Migration(
        8,
        9,
        (db) {
          return db.setVersion(9);
        },
      ),
      Migration(
        9,
        10,
        (db) {
          return db.setVersion(10);
        },
      ),
      Migration(
        10,
        11,
        (db) async {
          await db.execute("DROP TABLE Coil");
        },
      ),
      Migration(
        11,
        12,
        (db) async {
          await db.setVersion(12);
        },
      ),
      Migration(12, 13, (db) async {
        return db.execute(
            'CREATE TABLE IF NOT EXISTS `Coil` (`id` INTEGER, `coilName` TEXT NOT NULL, `coilDesc` TEXT NOT NULL, `mmcBank` TEXT NOT NULL, `coilType` TEXT NOT NULL, `primary` TEXT NOT NULL, PRIMARY KEY (`id`))');
      }),
      Migration(13, 14, (db) async {
        return db.execute("DROP TABLE Coil");
      }),
      //$frequency,$turns,$inductance,$coilType
    ],
  ).build();

  final coilsDao = database.coilDao;

  runApp(MyApp(
    dao: coilsDao,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.dao}) : super(key: key);

  final CoilDao dao;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle:
              normalTextStyleOpenSans14.copyWith(color: Colors.black87),
          toolbarTextStyle:
              normalTextStyleOpenSans14.copyWith(color: Colors.black87),
          iconTheme: IconThemeData(
            color: Colors.black87,
          ),
        ),
      ),
      routes: {
        MainScreen.id: (context) => const MainScreen(),
        CalculatorsScreen.id: (context) => const CalculatorsScreen(),
        CapacitorScreen.id: (context) => const CapacitorScreen(),
        ResonantFrequencyScreen.id: (context) =>
            const ResonantFrequencyScreen(),
        HelicalCoilCalculatorScreen.id: (context) =>
            const HelicalCoilCalculatorScreen(),
        CoilsListScreen.id: (context) => CoilsListScreen(
              coilDao: dao,
            ),
        CoilInfoScreen.id: (context) => CoilInfoScreen(
              coilDao: dao,
            ),
        InformationScreen.id: (context) => const InformationScreen(),
      },
      initialRoute: MainScreen.id,
    );
  }
}
