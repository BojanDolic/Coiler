import 'package:coiler_app/arguments/HelicalCalculatorArgs.dart';
import 'package:coiler_app/dao/DriftCoilDao.dart';
import 'package:coiler_app/database/drift_coil_database.dart';
import 'package:coiler_app/providers/CoilProvider.dart';
import 'package:coiler_app/providers/HelicalCalculatorProvider.dart';
import 'package:coiler_app/screens/calculators/capacitor_screen.dart';
import 'package:coiler_app/screens/calculators/helical_coil_screen.dart';
import 'package:coiler_app/screens/calculators/resonant_freq_screen.dart';
import 'package:coiler_app/screens/calculators_screen.dart';
import 'package:coiler_app/screens/coil_info_screen.dart';
import 'package:coiler_app/screens/coils_list_screen.dart';
import 'package:coiler_app/screens/information_screen.dart';
import 'package:coiler_app/screens/main_screen.dart';
import 'package:coiler_app/theme/darkTheme.dart';
import 'package:coiler_app/theme/lightTheme.dart';
import 'package:drift/native.dart';
import 'package:drift_local_storage_inspector/drift_local_storage_inspector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storage_inspector/storage_inspector.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //final driftDao = DriftCoilDatabase();

  final driver = StorageServerDriver(bundleId: 'com.electrocoder.coiler.coiler_app', port: 0);

  final db = NativeDatabase.memory();
  final driftDb = DriftCoilDatabase(db);

  await driftDb.customSelect("SELECT sql FROM sqlite_schema").get();

  final sqlServer = DriftSQLDatabaseServer(id: "1", name: "SQL Server", database: driftDb);

  driver.addSQLServer(sqlServer);

  await driver.start();

  //driftDb.driftCoilDao;

  runApp(MultiProvider(
    providers: [
      Provider<DriftCoilDao>(
        create: (context) => driftDb.driftCoilDao,
      ),
      ChangeNotifierProvider<CoilProvider>(
        create: (context) => CoilProvider(),
      ),
    ],
    child: MyApp(
      driftDao: driftDb.driftCoilDao,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.driftDao}) : super(key: key);

  final DriftCoilDao driftDao;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      routes: {
        MainScreen.id: (context) => const MainScreen(
            // dao: driftDao,
            ),
        CalculatorsScreen.id: (context) => const CalculatorsScreen(),
        CapacitorScreen.id: (context) => const CapacitorScreen(),
        ResonantFrequencyScreen.id: (context) => const ResonantFrequencyScreen(),
        /*HelicalCoilCalculatorScreen.id: (context) =>
            const HelicalCoilCalculatorScreen(),*/
        CoilsListScreen.id: (context) => const CoilsListScreen(),
        CoilInfoScreen.id: (context) => CoilInfoScreen(
              driftDao: driftDao,
            ),
        InformationScreen.id: (context) => const InformationScreen(),
      },
      initialRoute: MainScreen.id,
      onGenerateRoute: (settings) {
        if (settings.name == HelicalCoilCalculatorScreen.id) {
          final args = settings.arguments as HelicalCoilArgs?;

          return MaterialPageRoute(builder: (context) {
            return ChangeNotifierProvider<HelicalProvider>(
              create: (context) => HelicalProvider(),
              child: HelicalCoilCalculatorScreen(
                args: args,
              ),
            );
          });
        }
      },
    );
  }
}
