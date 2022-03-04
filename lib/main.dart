import 'package:coiler_app/dao/CoilDao.dart';
import 'package:coiler_app/database/coil_database.dart';
import 'package:coiler_app/screens/calculators/capacitor_screen.dart';
import 'package:coiler_app/screens/calculators/helical_coil_screen.dart';
import 'package:coiler_app/screens/calculators/resonant_freq_screen.dart';
import 'package:coiler_app/screens/calculators_screen.dart';
import 'package:coiler_app/screens/coils_list_screen.dart';
import 'package:coiler_app/screens/information_screen.dart';
import 'package:coiler_app/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database =
      await $FloorCoilsDatabase.databaseBuilder("coils_database.db").build();

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
        InformationScreen.id: (context) => const InformationScreen(),
      },
      initialRoute: MainScreen.id,
    );
  }
}
