import 'package:coiler_app/screens/calculators/capacitor_screen.dart';
import 'package:coiler_app/screens/calculators/resonant_freq_screen.dart';
import 'package:coiler_app/screens/calculators_screen.dart';
import 'package:coiler_app/screens/information_screen.dart';
import 'package:coiler_app/screens/main_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        MainScreen.id: (context) => const MainScreen(),
        CalculatorsScreen.id: (context) => const CalculatorsScreen(),
        CapacitorScreen.id: (context) => const CapacitorScreen(),
        ResonantFrequencyScreen.id: (context) =>
            const ResonantFrequencyScreen(),
        InformationScreen.id: (context) => const InformationScreen(),
      },
      initialRoute: MainScreen.id,
    );
  }
}
