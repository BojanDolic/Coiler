import 'package:coiler_app/util/color_constants.dart' as ColorUtil;
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/ui_constants.dart';
import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    titleTextStyle: normalTextStyleOpenSans14.copyWith(color: Colors.black87),
    toolbarTextStyle: normalTextStyleOpenSans14.copyWith(color: Colors.black87),
    backgroundColor: lightThemeBackgroundColor,
    iconTheme: const IconThemeData(
      color: Colors.black87,
    ),
  ),
  canvasColor: Colors.white,
  backgroundColor: lightThemeBackgroundColor,
  listTileTheme: ListTileThemeData(
    tileColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Colors.grey.shade400),
    ),
  ),
  textTheme: TextTheme(
    headlineMedium: mediumHeadlineTextStyle,
    headlineSmall: mediumHeadlineTextStyle.copyWith(fontSize: 15, color: ColorUtil.blackHeadline),
    displaySmall: lightCategoryTextStyle.copyWith(
      color: Colors.black54,
      fontSize: 14,
    ),
    displayMedium: normalTextStyleOpenSans14,
    displayLarge: normalTextStyleOpenSans14.copyWith(fontSize: 16),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color(0xFF2e2e2e),
    contentTextStyle: normalSnackbarTextStyleOpenSans14,
  ),
  iconTheme: const IconThemeData(
    color: Colors.black87,
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.white,
  ),
  dialogTheme: DialogTheme(
    backgroundColor: lightThemeBackgroundColor,
    contentTextStyle: normalTextStyleOpenSans14,
    shape: roundedBorder16,
  ),
  inputDecorationTheme: InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
      borderRadius: BorderRadius.circular(9),
    ),
    labelStyle: normalTextStyleOpenSans14.copyWith(color: Colors.grey.shade600),
    floatingLabelStyle: lightCategoryTextStyle.copyWith(color: Colors.white54, fontWeight: FontWeight.bold),
  ),
);
