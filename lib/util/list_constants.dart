import 'package:coiler_app/util/constants.dart' as Constants;
import 'package:flutter/material.dart';

const capacitanceDropDownList = [
  DropdownMenuItem(
    child: Text("F"),
    value: Constants.Units.DEFAULT,
  ),
  DropdownMenuItem(
    child: Text("µF"),
    value: Constants.Units.MICRO,
  ),
  DropdownMenuItem(
    child: Text("nF"),
    value: Constants.Units.NANO,
  ),
  DropdownMenuItem(
    child: Text("pF"),
    value: Constants.Units.PICO,
  ),
];

const inductanceDropDownList = [
  DropdownMenuItem(
    child: Text("H"),
    value: Constants.Units.DEFAULT,
  ),
  DropdownMenuItem(
    child: Text("mH"),
    value: Constants.Units.MILI,
  ),
  DropdownMenuItem(
    child: Text("µH"),
    value: Constants.Units.MICRO,
  ),
  DropdownMenuItem(
    child: Text("nH"),
    value: Constants.Units.NANO,
  ),
];

const frequencyDropDownList = [
  DropdownMenuItem(
    child: Text("Hz"),
    value: Constants.Units.DEFAULT,
  ),
  DropdownMenuItem(
    child: Text("kHz"),
    value: Constants.Units.KILO,
  ),
  DropdownMenuItem(
    child: Text("MHz"),
    value: Constants.Units.MEGA,
  ),
  DropdownMenuItem(
    child: Text("GHz"),
    value: Constants.Units.GIGA,
  ),
];

const lengthDropDownList = [
  DropdownMenuItem(
    child: Text("m"),
    value: Constants.Units.DEFAULT,
  ),
  DropdownMenuItem(
    child: Text("cm"),
    value: Constants.Units.CENTI,
  ),
  DropdownMenuItem(
    child: Text("mm"),
    value: Constants.Units.MILI,
  ),
];

const coilTypeDropDownList = [
  DropdownMenuItem(
    child: Text("SGTC"),
    value: Constants.CoilType.SPARK_GAP,
  ),
  DropdownMenuItem(
    child: Text("SSTC"),
    value: Constants.CoilType.SSTC,
  ),
  DropdownMenuItem(
    child: Text("DRSSTC"),
    value: Constants.CoilType.DRSSTC,
  ),
];

List<PopupMenuItem> popupCoilButtonActions(BuildContext context) {
  return [
    PopupMenuItem(
      value: Constants.ACTION_COPY_INFO,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Copy information"),
          Icon(
            Icons.copy,
            color: Theme.of(context).iconTheme.color,
          ),
        ],
      ),
    ),
    PopupMenuItem(
      value: Constants.ACTION_DELETE,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Delete",
          ),
          Icon(
            Icons.highlight_remove_outlined,
            color: Colors.red,
          ),
        ],
      ),
    ),
  ];
}

/*final popupCoilButtonActions = [
  PopupMenuItem(
    value: Constants.ACTION_COPY_INFO,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text("Copy information"),
        Icon(
          Icons.copy,
        ),
      ],
    ),
  ),
  PopupMenuItem(
    value: Constants.ACTION_DELETE,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          "Delete",
        ),
        Icon(
          Icons.highlight_remove_outlined,
          color: Colors.red,
        ),
      ],
    ),
  ),
];*/

final popupCoilInfoScreenActions = [
  PopupMenuItem(
    value: Constants.ACTION_EDIT_INFO,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text("Edit information"),
        Icon(
          Icons.edit,
          color: Colors.blue,
        ),
      ],
    ),
  ),
];

final popupCalculatorScreenInfo = [
  PopupMenuItem(
    value: Constants.actionInformation,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text("Information"),
        Icon(
          Icons.info_outline_rounded,
          color: Colors.blue,
        ),
      ],
    ),
  ),
];
