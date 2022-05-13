import 'package:coiler_app/util/ui_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtil {
  static void openHelicalCoilInfoDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.dialogTheme.backgroundColor,
          shape: roundedBorder16,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Image.asset(
                  "assets/formulas/helical_coil_formula_200.png",
                  color: theme.dialogTheme.contentTextStyle?.color,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Formulas used in this calculator are formulas derived by Harold A. Wheeler.\n"
                  "He proposed formula shown above to be used for determining inductance "
                  "of finite-length solenoid made of round wire."
                  "\nThe values entered must be in inches."
                  "\nResultant inductance is in microhenries (μH)"
                  "\n\nReference: Harold A. Wheeler, \"Simple Inductance Formulas for Radio Coils,\" Proceedings of the I.R.E., October 1928, pp. 1398-1400",
                  style: theme.dialogTheme.contentTextStyle,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  static void openFlatSpiralCoilInfoDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.dialogTheme.backgroundColor,
          shape: roundedBorder16,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Image.asset(
                  "assets/formulas/helical_coil_formula_200.png",
                  color: theme.dialogTheme.contentTextStyle?.color,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Formulas used in this calculator are formulas derived by Harold A. Wheeler.\n"
                  "He proposed formula shown above to be used for determining inductance "
                  "of finite-length solenoid made of round wire."
                  "\nThe values entered must be in inches."
                  "\nResultant inductance is in microhenries (μH)"
                  "\n\nReference: Harold A. Wheeler, \"Simple Inductance Formulas for Radio Coils,\" Proceedings of the I.R.E., October 1928, pp. 1398-1400",
                  style: theme.dialogTheme.contentTextStyle,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }
}
