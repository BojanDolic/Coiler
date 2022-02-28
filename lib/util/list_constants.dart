import 'package:coiler_app/util/constants.dart';
import 'package:flutter/material.dart';

const capacitanceDropDownList = [
  DropdownMenuItem(
    child: Text("F"),
    value: Units.DEFAULT,
  ),
  DropdownMenuItem(
    child: Text("uF"),
    value: Units.MICRO,
  ),
  DropdownMenuItem(
    child: Text("nF"),
    value: Units.NANO,
  ),
  DropdownMenuItem(
    child: Text("pF"),
    value: Units.PICO,
  ),
];
