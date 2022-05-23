import 'package:coiler_app/util/color_constants.dart' as ColorUtil;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension ThemeCheck on BuildContext {
  bool isDarkTheme() {
    final bright = MediaQuery.of(this).platformBrightness;
    return bright == Brightness.dark;
  }

  Color getDropDownColor() {
    return (isDarkTheme()) ? Colors.grey.shade800 : ColorUtil.lightestBlue;
  }
}
