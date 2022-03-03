import 'package:coiler_app/calculator/calculator.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/list_constants.dart';
import 'package:coiler_app/widgets/border_container.dart';
import 'package:coiler_app/widgets/dropdown_widget.dart';
import 'package:coiler_app/widgets/input_field.dart';
import 'package:coiler_app/widgets/input_field_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HelicalCoilCalculatorScreen extends StatefulWidget {
  const HelicalCoilCalculatorScreen({Key? key}) : super(key: key);

  static String id = "/calculators/helical_coil";

  @override
  State<HelicalCoilCalculatorScreen> createState() =>
      _HelicalCoilCalculatorScreenState();
}

class _HelicalCoilCalculatorScreenState
    extends State<HelicalCoilCalculatorScreen> {
  Units inductanceUnit = Units.MICRO;
  Units diameterUnit = Units.MILI;
  Units wireDiameterUnit = Units.MILI;
  Units wireSpacingUnit = Units.MILI;

  String inductance = "";
  String diameter = "";
  String wireDiameter = "";
  String wireSpacing = "";
  int turns = 0;

  final calculator = Calculator();
  final converter = Converter();

  final diameterController = TextEditingController();
  final spacingController = TextEditingController();
  final turnsController = TextEditingController();
  final wireDiameterController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void parseData() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    var _diameter = double.tryParse(diameter);
    var _wireDiameter = double.tryParse(wireDiameter);
    var _wireSpacing = double.tryParse(wireSpacing);

    if (_diameter != null && _wireDiameter != null && _wireSpacing != null) {
      _diameter =
          converter.convertUnits(_diameter, diameterUnit, Units.DEFAULT);
      _wireDiameter = converter.convertUnits(
          _wireDiameter, wireDiameterUnit, Units.DEFAULT);
      _wireSpacing =
          converter.convertUnits(_wireSpacing, wireSpacingUnit, Units.DEFAULT);

      calculateInductance(_diameter, _wireDiameter, _wireSpacing);
    }
  }

  void convertValues(
      double diameter, double wireDiameter, double wireSpacing) {}

  void calculateInductance(
      double diameter, double wireDiameter, double wireSpacing) {
    var tempInductance = calculator.calculateSpiralCoilInductance(
      turns,
      diameter,
      wireDiameter,
      wireSpacing,
      Units.DEFAULT,
    );

    var inductance =
        converter.convertUnits(tempInductance, Units.MICRO, inductanceUnit);

    print("Inductance: $inductance");

    setState(() {
      this.inductance = inductance.toStringAsFixed(7);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BorderContainer(
                    child: Column(
                      children: [
                        Image.asset("assets/helical_coil_transparent.png"),
                        const Text(
                          "Calculate inductance of your helical coil by entering values below.\n"
                          "Result is calculated automatically",
                          textAlign: TextAlign.center,
                          style: normalTextStyleOpenSans14,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BorderContainer(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            "Inductance: $inductance",
                            style: normalTextStyleOpenSans14,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        DropDownMenu<Units>(
                          value: inductanceUnit,
                          items: inductanceDropDownList,
                          onSelect: (newValue) {
                            setState(() {
                              inductanceUnit = newValue!;
                              parseData();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InputFieldDropDown(
                    controller: diameterController,
                    hintText: "Enter diameter of coil (D)",
                    labelText: "Coil diameter",
                    inputFormatters: [decimalOnlyTextFormatter],
                    onTextChanged: (text) {
                      setState(() {
                        diameter = text;
                        parseData();
                      });
                    },
                    validator: (text) {
                      if (text == null ||
                          text.isEmpty ||
                          double.tryParse(text) == 0) {
                        return "Invalid input";
                      } else {
                        return null;
                      }
                    },
                    dropDownValue: diameterUnit,
                    onDropDownChanged: (value) {
                      setState(() {
                        diameterUnit = value!;
                        parseData();
                      });
                    },
                    dropDownList: lengthDropDownList,
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  InputFieldDropDown(
                    controller: wireDiameterController,
                    hintText: "Enter wire diameter (W)",
                    labelText: "Wire diameter",
                    inputFormatters: [decimalOnlyTextFormatter],
                    onTextChanged: (text) {
                      setState(() {
                        wireDiameter = text;
                        parseData();
                      });
                    },
                    validator: (text) {
                      if (text == null ||
                          text.isEmpty ||
                          double.tryParse(text) == 0) {
                        return "Invalid input";
                      } else {
                        return null;
                      }
                    },
                    dropDownValue: wireDiameterUnit,
                    onDropDownChanged: (value) {
                      setState(() {
                        wireDiameterUnit = value!;
                        parseData();
                      });
                    },
                    dropDownList: lengthDropDownList,
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  InputFieldDropDown(
                    controller: spacingController,
                    hintText: "Enter wire spacing (S)",
                    labelText: "Wire spacing",
                    inputFormatters: [decimalOnlyTextFormatter],
                    onTextChanged: (text) {
                      setState(() {
                        wireSpacing = text;
                        parseData();
                      });
                    },
                    validator: (text) {
                      if (text == null ||
                          text.isEmpty ||
                          double.tryParse(text) == 0) {
                        return "Invalid input";
                      } else {
                        return null;
                      }
                    },
                    dropDownValue: wireSpacingUnit,
                    onDropDownChanged: (value) {
                      setState(() {
                        wireSpacingUnit = value!;
                        parseData();
                      });
                    },
                    dropDownList: lengthDropDownList,
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  InputField(
                    controller: turnsController,
                    hintText: "Enter number of turns",
                    labelText: "Coil turns",
                    unitText: "No.",
                    maxLength: 5,
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    onTextChanged: (text) {
                      setState(() {
                        turns = int.parse(text);
                        parseData();
                      });
                    },
                    validator: (text) {
                      if (text == null ||
                          text.isEmpty ||
                          double.tryParse(text) == 0) {
                        return "Invalid input";
                      } else {
                        return null;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
