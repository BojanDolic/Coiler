import 'package:coiler_app/screens/calculators/capacitor_screen.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:flutter/material.dart';

class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({Key? key}) : super(key: key);

  static const String id = "/calculators";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Calculators available:",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: "OpenSans",
                  ),
                ),
              ),
            ),
            CalculatorItem(
              title: "MMC (Multi-Mini-Capacitor)",
              backColor: Colors.blue,
              icon: Image.asset(
                "assets/caps_icon.png",
                color: Colors.white,
                width: 26,
                height: 26,
              ),
              onTap: () {
                Navigator.pushNamed(context, CapacitorScreen.id);
              },
            ),
            CalculatorItem(
              title: "Resonant frequency",
              backColor: Colors.orangeAccent,
              icon: Image.asset(
                "assets/resfreq_icon.png",
                color: Colors.white,
                width: 26,
                height: 26,
              ),
              onTap: () {
                //TODO Navigate
              },
            ),
            CalculatorItem(
              title: "Inductance of helical coil",
              backColor: Colors.green,
              icon: Image.asset(
                "assets/helical_coil_icon.png",
                color: Colors.white,
                width: 26,
                height: 26,
              ),
              onTap: () {
                //TODO Navigate
              },
            ),
            CalculatorItem(
              title: "Inductance of flat coil",
              backColor: Colors.pinkAccent,
              icon: Image.asset(
                "assets/flat_coil_icon.png",
                color: Colors.white,
                width: 26,
                height: 26,
              ),
              onTap: () {
                //TODO Navigate
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorItem extends StatelessWidget {
  const CalculatorItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.backColor,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final Image icon;
  final Color backColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: icon,
      ),
      title: Text(
        title,
        style: lightCategoryTextStyle,
      ),
    );
  }
}
