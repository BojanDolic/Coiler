import 'package:flutter/cupertino.dart';

extension ThemeCheck on BuildContext {
  bool isDarkTheme() {
    final bright = MediaQuery.of(this).platformBrightness;
    return bright == Brightness.dark;
  }
}
