import 'package:coiler_app/arguments/HelicalCalculatorArgs.dart';
import 'package:coiler_app/entities/args/FlatCoilArgs.dart';
import 'package:coiler_app/providers/FlatCoilProvider.dart';
import 'package:coiler_app/providers/FrequencyProvider.dart';
import 'package:coiler_app/providers/HelicalCalculatorProvider.dart';
import 'package:coiler_app/screens/calculators/capacitor_screen.dart';
import 'package:coiler_app/screens/calculators/flat_coil_screen.dart';
import 'package:coiler_app/screens/calculators/helical_coil_screen.dart';
import 'package:coiler_app/screens/calculators/resonant_freq_screen.dart';
import 'package:coiler_app/screens/calculators_screen.dart';
import 'package:coiler_app/screens/coil_info_screen.dart';
import 'package:coiler_app/screens/coils_list_screen.dart';
import 'package:coiler_app/screens/information_screen.dart';
import 'package:coiler_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HelicalCoilCalculatorScreen.id:
        {
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
      case FlatCoilScreen.id:
        {
          final args = settings.arguments as FlatCoilArgs?;
          return MaterialPageRoute(
            builder: (context) {
              return ChangeNotifierProvider<FlatCoilProvider>(
                create: (context) => FlatCoilProvider(),
                child: FlatCoilScreen(
                  args: args,
                ),
              );
            },
          );
        }

      case MainScreen.id:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case CalculatorsScreen.id:
        return MaterialPageRoute(builder: (_) => const CalculatorsScreen());
      case CapacitorScreen.id:
        return MaterialPageRoute(builder: (_) => const CapacitorScreen());
      case ResonantFrequencyScreen.id:
        {
          return MaterialPageRoute(builder: (context) {
            return ChangeNotifierProvider<ResonantFrequencyProvider>(
              create: (context) => ResonantFrequencyProvider(),
              child: const ResonantFrequencyScreen(),
            );
          });
        }
      case CoilsListScreen.id:
        return MaterialPageRoute(builder: (_) => const CoilsListScreen());
      case CoilInfoScreen.id:
        return MaterialPageRoute(builder: (_) => const CoilInfoScreen());
      case InformationScreen.id:
        return MaterialPageRoute(builder: (_) => const InformationScreen());
      default:
        {
          return MaterialPageRoute(builder: (context) {
            return Scaffold(
              body: Center(
                child: Text("No route to display for ${settings.name}"),
              ),
            );
          });
        }
    }
  }
}
