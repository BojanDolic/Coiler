import 'package:coiler_app/screens/calculators/capacitor_screen.dart';
import 'package:coiler_app/screens/calculators/flat_coil_screen.dart';
import 'package:coiler_app/screens/calculators/helical_coil_screen.dart';
import 'package:coiler_app/screens/calculators/resonant_freq_screen.dart';
import 'package:coiler_app/util/color_constants.dart' as ColorUtil;
import 'package:flutter/material.dart';

class CalculatorsScreen extends StatelessWidget {
  const CalculatorsScreen({Key? key}) : super(key: key);

  static const String id = "/calculators";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Calculators",
          style: theme.textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /*const SizedBox(
                height: 12,
              ),*/
              CalculatorItem(
                title: "MMC (Multi-Mini-Capacitor)",
                gradientColor: ColorUtil.blueGradient,
                icon: Image.asset(
                  "assets/caps_icon.png",
                  color: Colors.blue,
                  width: 32,
                  height: 32,
                ),
                onTap: () {
                  Navigator.pushNamed(context, CapacitorScreen.id);
                },
              ),
              CalculatorItem(
                title: "Resonant frequency",
                gradientColor: ColorUtil.orangeGradient,
                icon: Image.asset(
                  "assets/resfreq_icon.png",
                  color: Colors.orangeAccent,
                  width: 32,
                  height: 32,
                ),
                onTap: () {
                  Navigator.pushNamed(context, ResonantFrequencyScreen.id);
                },
              ),
              CalculatorItem(
                title: "Inductance of helical coil",
                gradientColor: ColorUtil.greenGradient,
                icon: Image.asset(
                  "assets/helical_coil_icon.png",
                  color: Colors.green,
                  width: 32,
                  height: 32,
                ),
                onTap: () {
                  Navigator.pushNamed(context, HelicalCoilCalculatorScreen.id);
                },
              ),
              CalculatorItem(
                title: "Inductance of flat coil",
                gradientColor: ColorUtil.pinkGradient,
                icon: Image.asset(
                  "assets/flat_coil_icon.png",
                  color: Colors.pinkAccent,
                  width: 32,
                  height: 32,
                ),
                onTap: () {
                  Navigator.pushNamed(context, FlatCoilScreen.id);
                },
              ),
              CalculatorItem(
                title: "Sphere topload capacitance",
                gradientColor: ColorUtil.tealGradient,
                icon: Image.asset(
                  "assets/sphere_icon.png",
                  color: ColorUtil.teal,
                  width: 32,
                  height: 32,
                ),
                onTap: () {
                  //TODO add navigation to flat coil calculation
                },
              ),
              CalculatorItem(
                title: "Toroid topload capacitance",
                gradientColor: ColorUtil.purpleGradient,
                icon: Image.asset(
                  "assets/full_toroid_icon.png",
                  color: ColorUtil.purple,
                  width: 32,
                  height: 32,
                ),
                onTap: () {
                  //TODO add navigation to flat coil calculation
                },
              ),
              CalculatorItem(
                title: "Ring toroid topload capacitance",
                gradientColor: ColorUtil.lightOrangeGradient,
                icon: Image.asset(
                  "assets/ring_toroid_icon.png",
                  color: ColorUtil.lightOrange,
                  width: 32,
                  height: 32,
                ),
                onTap: () {
                  //TODO add navigation to flat coil calculation
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalculatorItem extends StatelessWidget {
  const CalculatorItem({
    Key? key,
    required this.gradientColor,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final Color gradientColor;
  final Image icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(-0.60, 1),
            tileMode: TileMode.clamp,
            colors: [
              gradientColor.withOpacity(.25),
              theme.backgroundColor,
            ],
          ),
        ),
        child: InkWell(
          splashColor: gradientColor.withOpacity(.45),
          splashFactory: InkRipple.splashFactory,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: icon,
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      title,
                      style: theme.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
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
*/
