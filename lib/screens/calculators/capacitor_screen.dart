import 'package:coiler_app/util/calculator.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/list_constants.dart';
import 'package:coiler_app/widgets/border_container.dart';
import 'package:coiler_app/widgets/input_field.dart';
import 'package:coiler_app/widgets/input_field_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CapacitorScreen extends StatefulWidget {
  const CapacitorScreen({Key? key}) : super(key: key);

  static const String id = "/calculators/mmc";

  @override
  _CapacitorScreenState createState() => _CapacitorScreenState();
}

class _CapacitorScreenState extends State<CapacitorScreen> {
  Calculator calculator = Calculator();

  double capacitance = 0.0;
  int seriesCapNum = 0;
  int parallelCapNum = 0;
  int voltage = 0;

  double _finalCapacitance = 0.0;

  Units _capacitance = Units.MICRO;
  Units unitsToConvertTo = Units.MICRO;

  TextEditingController controller = TextEditingController();
  TextEditingController voltageController = TextEditingController();
  TextEditingController seriesCapNumController = TextEditingController();
  TextEditingController parallelCapNumController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void submitValues() {
    if (capacitance != 0) {
      if (parallelCapNum > 0 && seriesCapNum < 1) {
        seriesCapNum = 1;
      }
      if (seriesCapNum > 1 && parallelCapNum < 1) {
        parallelCapNum = 1;
      } else if (parallelCapNum < 1 && seriesCapNum < 1) {
        parallelCapNum = 1;
        seriesCapNum = 1;
      }
      calculateResult();
    }
  }

  void calculateResult() {
    double capacitance = calculator.calculateMMC(
      this.capacitance,
      seriesCapNum,
      parallelCapNum,
    );
    setState(() {
      _finalCapacitance = capacitance;
      convertUnits();
    });
  }

  void convertUnits() {
    setState(() {
      _finalCapacitance = Converter()
          .convertUnits(_finalCapacitance, _capacitance, unitsToConvertTo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const BorderContainer(
                    child: Text(
                      "MMC calculator can help you calculate your capacitor bank capacitance and voltage easily."
                      "\n\n Enter values below and result is calculated automatically.",
                      textAlign: TextAlign.center,
                      style: normalTextStyleOpenSans14,
                    ),
                    elevated: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BorderContainer(
                    elevated: true,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Final capacitance: $_finalCapacitance",
                              style: biggerTextStyleOpenSans15,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                              ),
                              decoration: BoxDecoration(
                                color: lightBlueColor,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: DropdownButton<Units>(
                                borderRadius: BorderRadius.circular(9),
                                value: unitsToConvertTo,
                                underline: Container(),
                                items: capacitanceDropDownList,
                                onChanged: (value) {
                                  setState(() {
                                    unitsToConvertTo = value!;
                                    calculateResult();
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "MMC Voltage: ${seriesCapNum * voltage}",
                              style: biggerTextStyleOpenSans15,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: lightBlueColor,
                                  borderRadius: BorderRadius.circular(9)),
                              child: Text("V"),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InputFieldDropDown(
                    hintText: "Single capacitor capacitance",
                    labelText: "Capacitance",
                    controller: controller,
                    onTextChanged: (text) {
                      var capacitance = double.tryParse(text);

                      if (capacitance != null) {
                        setState(() {
                          this.capacitance = capacitance;
                          submitValues();
                        });
                      }
                    },
                    validator: (text) {
                      if (text == null ||
                          text.isEmpty ||
                          double.tryParse(text) == 0) {
                        return "Capacitance not valid";
                      } else {
                        return null;
                      }
                    },
                    dropDownValue: _capacitance,
                    onDropDownChanged: (value) {
                      setState(() {
                        _capacitance = value!;
                        submitValues();
                      });
                    },
                    dropDownList: capacitanceDropDownList,
                  ),
                  InputField(
                    controller: voltageController,
                    unitText: voltageUnitText,
                    inputType:
                        const TextInputType.numberWithOptions(signed: true),
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 6,
                    hintText: "Enter single capacitor voltage",
                    labelText: "Voltage",
                    onTextChanged: (text) {
                      setState(() {
                        voltage = int.parse(text);
                      });
                    },
                    validator: (text) {
                      if (text == null || double.tryParse(text) == 0) {
                        return "Invalid input";
                      } else {
                        return null;
                      }
                    },
                  ),
                  InputField(
                    controller: seriesCapNumController,
                    hintText: "Capacitors in series",
                    labelText: "Series capacitor count",
                    onTextChanged: (text) {
                      int? seriesNum = int.tryParse(text);
                      setState(() {
                        if (seriesNum != null) {
                          seriesCapNum = seriesNum;
                        } else {
                          seriesCapNum = 1;
                        }
                        submitValues();
                      });
                    },
                    validator: (text) {
                      if (text == null || double.tryParse(text) == 0) {
                        return "Invalid input";
                      } else {
                        return null;
                      }
                    },
                    maxLength: 4,
                    unitText: "No.",
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  InputField(
                    controller: parallelCapNumController,
                    hintText: "Capacitors in parallel",
                    labelText: "Parallel capacitor count",
                    onTextChanged: (text) {
                      int? parallelNum = int.tryParse(text);
                      setState(() {
                        if (parallelNum != null) {
                          parallelCapNum = parallelNum;
                        } else {
                          parallelCapNum = 1;
                        }
                        submitValues();
                      });
                    },
                    validator: (text) {
                      if (text == null || double.tryParse(text) == 0) {
                        return "Invalid input";
                      } else {
                        return null;
                      }
                    },
                    maxLength: 4,
                    unitText: "No.",
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
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
