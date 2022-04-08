import 'package:coiler_app/arguments/HelicalCalculatorArgs.dart';
import 'package:coiler_app/calculator/calculator.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';
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
  const HelicalCoilCalculatorScreen({Key? key, this.args}) : super(key: key);

  static String id = "/calculators/helical_coil";
  final HelicalCoilArgs? args;

  @override
  State<HelicalCoilCalculatorScreen> createState() => _HelicalCoilCalculatorScreenState();
}

class _HelicalCoilCalculatorScreenState extends State<HelicalCoilCalculatorScreen> {
  Units inductanceUnit = Units.MICRO;
  Units diameterUnit = Units.MILI;
  Units wireDiameterUnit = Units.MILI;
  Units wireSpacingUnit = Units.MILI;

  String inductance = "";
  String diameter = "";
  String wireDiameter = "";
  String wireSpacing = "";
  int turns = 0;

  bool editing = false;

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
      _diameter = converter.convertUnits(_diameter, diameterUnit, Units.DEFAULT);
      _wireDiameter = converter.convertUnits(_wireDiameter, wireDiameterUnit, Units.DEFAULT);
      _wireSpacing = converter.convertUnits(_wireSpacing, wireSpacingUnit, Units.DEFAULT);

      calculateInductance(_diameter, _wireDiameter, _wireSpacing);
    }
  }

  void convertValues(double diameter, double wireDiameter, double wireSpacing) {}

  void calculateInductance(double diameter, double wireDiameter, double wireSpacing) {
    var tempInductance = calculator.calculateSpiralCoilInductance(
      turns,
      diameter,
      wireDiameter,
      wireSpacing,
      Units.DEFAULT,
    );

    var inductance = converter.convertUnits(tempInductance, Units.MICRO, inductanceUnit);

    setState(() {
      this.inductance = inductance.toStringAsFixed(7);
    });
  }

  void loadCoilInfo(dynamic coil) {
    var _inductance = converter.convertUnits(coil.inductance, Units.DEFAULT, inductanceUnit);
    var _wireSpacing = converter.convertUnits(coil.wireSpacing, Units.DEFAULT, wireSpacingUnit);
    var _coilDiameter = converter.convertUnits(coil.coilDiameter, Units.DEFAULT, diameterUnit);
    var _wireDiameter = converter.convertUnits(coil.wireDiameter, Units.DEFAULT, wireDiameterUnit);

    turnsController.text = coil.turns.toString();
    turns = coil.turns;

    diameterController.text = _coilDiameter.toString();
    diameter = _coilDiameter.toString();

    spacingController.text = _wireSpacing.toString();
    wireSpacing = _wireSpacing.toString();

    inductance = _inductance.toString();

    wireDiameter = _wireDiameter.toString();
    wireDiameterController.text = _wireDiameter.toString();
  }

  void saveCoil() {
    var _inductance = double.tryParse(inductance);
    var _diameter = double.tryParse(diameter);
    var _wireDiameter = double.tryParse(wireDiameter);
    var _wireSpacing = double.tryParse(wireSpacing);

    if (validateInput() && formKey.currentState!.validate()) {
      var inductanceTemp = converter.convertUnits(_inductance, inductanceUnit, Units.DEFAULT);
      var wireSpacingTemp = converter.convertUnits(_wireSpacing, wireSpacingUnit, Units.DEFAULT);
      var coilDiameterTemp = converter.convertUnits(_diameter, diameterUnit, Units.DEFAULT);
      var wireDiameterTemp = converter.convertUnits(_wireDiameter, wireDiameterUnit, Units.DEFAULT);

      final primaryCoil = PrimaryCoil(
        coilType: ComponentType.helicalCoil.index,
        turns: turns,
        inductance: inductanceTemp,
        wireSpacing: wireSpacingTemp,
        coilDiameter: coilDiameterTemp,
        wireDiameter: wireDiameterTemp,
      );

      Navigator.pop(context, primaryCoil);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Check your input fields !",
            style: normalTextStyleOpenSans14.copyWith(
              color: Colors.white,
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade800,
          duration: const Duration(milliseconds: 1500),
        ),
      );
    }
  }

  bool validateInput() {
    var _inductance = double.tryParse(inductance);
    var _diameter = double.tryParse(diameter);
    var _wireDiameter = double.tryParse(wireDiameter);
    var _wireSpacing = double.tryParse(wireSpacing);

    return (_diameter != null && _wireDiameter != null && _wireSpacing != null && _inductance != null && turns != 0);
  }

  @override
  void initState() {
    super.initState();
    //print(widget.args);

    var helicalCoilArgs = widget.args;

    if (helicalCoilArgs != null) {
      editing = helicalCoilArgs.editing;

      if (editing) {
        final _primaryCoil = helicalCoilArgs.primaryCoil;
        final _secondaryCoil = helicalCoilArgs.secondaryCoil;
        if (_primaryCoil != null) {
          loadCoilInfo(_primaryCoil);
        } else if (_secondaryCoil != null) {
          loadCoilInfo(_secondaryCoil);
        }
      }
    }
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      if (text == null || text.isEmpty || double.tryParse(text) == 0) {
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
                      if (text == null || text.isEmpty || double.tryParse(text) == 0) {
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
                      if (text == null || text.isEmpty || double.tryParse(text) == 0) {
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
                      if (text == null || text.isEmpty || double.tryParse(text) == 0) {
                        return "Invalid input";
                      } else {
                        return null;
                      }
                    },
                  ),
                  Visibility(
                    visible: editing,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: TextButton(
                        onPressed: () {
                          saveCoil();
                        },
                        child: const Text("SAVE COIL INFO"),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
