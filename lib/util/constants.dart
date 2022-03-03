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

const biggerTextStyleOpenSans15 = TextStyle(
  fontFamily: "OpenSans",
  fontWeight: FontWeight.w500,
  fontSize: 16,
);

final decimalOnlyTextFormatter = FilteringTextInputFormatter.allow(
  RegExp("(^(\\d*)((\\.{1})(\\d*))?)"),
);

const lightBlueColor = Color(0xffe1efff);

enum Units { DEFAULT, CENTI, MILI, MICRO, NANO, PICO, KILO, MEGA, GIGA }

const voltageUnitText = "V";
