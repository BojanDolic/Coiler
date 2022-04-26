import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/ui_constants.dart';
import 'package:flutter/material.dart';

final darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    titleTextStyle: normalTextStyleOpenSans14.copyWith(color: Colors.black87),
    toolbarTextStyle: normalTextStyleOpenSans14.copyWith(color: Colors.black87),
    backgroundColor: darkAppBarBackgroundColor,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  ),
  popupMenuTheme: PopupMenuThemeData(
    color: darkThemeBackgroundColor,
    textStyle: normalTextStyleOpenSans14.copyWith(
      color: Colors.white,
    ),
  ),
  primaryIconTheme: const IconThemeData(
    color: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: Colors.white70,
  ),
  textTheme: TextTheme(
    headlineMedium: mediumHeadlineTextStyle.copyWith(color: Colors.white),
    displaySmall: lightCategoryTextStyle.copyWith(
      color: Colors.white54,
      fontSize: 14,
    ),
    displayMedium: normalTextStyleOpenSans14.copyWith(color: Colors.white),
  ),
  listTileTheme: ListTileThemeData(
    textColor: Colors.white,
    tileColor: Colors.grey.shade900,
    iconColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: Colors.white12),
    ),
  ),
  backgroundColor: darkThemeBackgroundColor,
  dialogTheme: DialogTheme(
    backgroundColor: darkThemeBackgroundColor,
    contentTextStyle: normalTextStyleOpenSans14.copyWith(color: Colors.white),
    shape: roundedBorder16,
  ),
);
