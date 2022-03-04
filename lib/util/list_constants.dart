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

const inductanceDropDownList = [
  DropdownMenuItem(
    child: Text("H"),
    value: Units.DEFAULT,
  ),
  DropdownMenuItem(
    child: Text("mH"),
    value: Units.MILI,
  ),
  DropdownMenuItem(
    child: Text("uH"),
    value: Units.MICRO,
  ),
  DropdownMenuItem(
    child: Text("nH"),
    value: Units.NANO,
  ),
];

const frequencyDropDownList = [
  DropdownMenuItem(
    child: Text("Hz"),
    value: Units.DEFAULT,
  ),
  DropdownMenuItem(
    child: Text("kHz"),
    value: Units.KILO,
  ),
  DropdownMenuItem(
    child: Text("MHz"),
    value: Units.MEGA,
  ),
  DropdownMenuItem(
    child: Text("GHz"),
    value: Units.GIGA,
  ),
];

const lengthDropDownList = [
  DropdownMenuItem(
    child: Text("m"),
    value: Units.DEFAULT,
  ),
  DropdownMenuItem(
    child: Text("cm"),
    value: Units.CENTI,
  ),
  DropdownMenuItem(
    child: Text("mm"),
    value: Units.MILI,
  ),
];
