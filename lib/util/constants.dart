import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const boldCategoryTextStyle = TextStyle(
  fontFamily: "OpenSans",
  fontWeight: FontWeight.w800,
  fontSize: 16,
);

const lightCategoryTextStyle = TextStyle(
  fontFamily: "OpenSans",
  color: Colors.black54,
);

const normalTextStyleOpenSans14 = TextStyle(
  fontFamily: "OpenSans",
  fontWeight: FontWeight.normal,
  fontSize: 15,
  color: Colors.black87,
);

const normalSnackbarTextStyleOpenSans14 = TextStyle(
  fontFamily: "OpenSans",
  fontWeight: FontWeight.normal,
  fontSize: 15,
  color: Colors.white,
);

const boldTextStyleOpenSans15 = TextStyle(
  fontFamily: "OpenSans",
  fontWeight: FontWeight.bold,
  fontSize: 15,
  color: Colors.black87,
);

const biggerTextStyleOpenSans15 = TextStyle(
  fontFamily: "OpenSans",
  fontWeight: FontWeight.w500,
  fontSize: 16,
);

const lightThemeBackgroundColor = Color(0xFFf9fcff);

final decimalOnlyTextFormatter = FilteringTextInputFormatter.allow(
  RegExp("(^(\\d*)((\\.{1})(\\d*))?)"),
);

const lightBlueColor = Color(0xffe1efff);

enum Units { DEFAULT, CENTI, MILI, MICRO, NANO, PICO, KILO, MEGA, GIGA }
enum CoilType { SPARK_GAP, SSTC, DRSSTC }
enum INDUCTOR_TYPE {
  HELICAL,
  FLAT,
}

enum ComponentType {
  capacitor,
  helicalCoil,
  flatCoil,
  ringToroidTopload,
  fullToroidTopload,
  sphereTopload,
}

enum DialogAction {
  onAdd,
  onEdit,
  onInformation,
  onDelete,
}

const ACTION_DELETE = "delete";
const ACTION_COPY_INFO = "copy";
const ACTION_EDIT_INFO = "edit";
const actionInformation = "info";

const voltageUnitText = "V";
