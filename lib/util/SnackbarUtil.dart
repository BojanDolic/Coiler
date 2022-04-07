import 'package:flutter/material.dart';

class SnackbarUtil {
  static void showInfoSnackBar({
    required BuildContext context,
    required String text,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
        elevation: 6,
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static void showInfoSnackBarWithButton({
    required BuildContext context,
    required String text,
    required String buttonText,
    required VoidCallback onButtonPressed,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
        elevation: 6,
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(label: buttonText, onPressed: onButtonPressed),
      ),
    );
  }
}
