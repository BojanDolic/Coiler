import 'package:coiler_app/providers/FrequencyProvider.dart';
import 'package:coiler_app/util/color_constants.dart' as ColorUtil;
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/extensions/theme_extension.dart';
import 'package:coiler_app/util/list_constants.dart';
import 'package:coiler_app/widgets/border_container.dart';
import 'package:coiler_app/widgets/input_field_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResonantFrequencyScreen extends StatefulWidget {
  const ResonantFrequencyScreen({Key? key}) : super(key: key);

  static const String id = "/calculators/resfreq";

  @override
  _ResonantFrequencyScreenState createState() => _ResonantFrequencyScreenState();
}

class _ResonantFrequencyScreenState extends State<ResonantFrequencyScreen> {
  final _formKey = GlobalKey<FormState>();

  /*String inductance = "";
  String capacitance = "";
  String frequency = "";

  Units inductanceUnit = Units.MICRO;
  Units capacitanceUnit = Units.MICRO;
  Units frequencyUnit = Units.KILO;*/

  TextEditingController inductanceController = TextEditingController();
  TextEditingController capacitanceController = TextEditingController();

  /*void calculateFrequency() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    var inductanceTemp = double.tryParse(inductance);
    var capacitanceTemp = double.tryParse(capacitance);

    if (inductanceTemp != 0 && capacitanceTemp != 0) {
      var inductance = Converter().convertUnits(inductanceTemp, inductanceUnit, Units.DEFAULT);
      var capacitance = Converter().convertUnits(capacitanceTemp, capacitanceUnit, Units.DEFAULT);

      var frequencyTemp = Calculator().calculateResFrequency(inductance, capacitance);
      var frequency = Converter().convertUnits(frequencyTemp, Units.DEFAULT, frequencyUnit);

      setState(() {
        this.frequency = frequency.toStringAsFixed(4);
      });
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: BorderContainer(
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/lc_circuit.png",
                            height: 200,
                            color: context.isDarkTheme() ? Colors.white : Colors.black87,
                          ),
                          Text(
                            "Calculate resonant frequency of your LC circuit by entering values below.",
                            style: theme.textTheme.displayMedium,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BorderContainer(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Frequency: ${Provider.of<ResonantFrequencyProvider>(context).frequencyText}",
                          style: theme.textTheme.displaySmall,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                          ),
                          decoration: BoxDecoration(
                            color: context.isDarkTheme() ? Colors.grey.shade800 : ColorUtil.lightestBlue,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Consumer<ResonantFrequencyProvider>(
                            builder: (context, provider, child) {
                              return DropdownButton<Units>(
                                value: provider.frequencyUnit,
                                items: frequencyDropDownList,
                                style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                                borderRadius: BorderRadius.circular(9),
                                underline: Container(),
                                onChanged: (unitValue) {
                                  provider.setFrequencyUnit(unitValue!);
                                  provider.calculateFrequency();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 9,
                    ),
                    child: Consumer<ResonantFrequencyProvider>(
                      builder: (context, provider, child) {
                        return InputFieldDropDown(
                          hintText: "Enter inductance",
                          labelText: "Inductance",
                          controller: inductanceController,
                          onTextChanged: (text) {
                            provider.validateInductance(double.tryParse(text));
                            provider.calculateFrequency();
                          },
                          validator: (text) => null,
                          errorText: provider.inductance.error,
                          dropDownValue: provider.inductanceUnit,
                          onDropDownChanged: (value) {
                            provider.setInductanceUnit(value!);
                            provider.calculateFrequency();
                          },
                          dropDownList: inductanceDropDownList,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 9,
                    ),
                    child: Consumer<ResonantFrequencyProvider>(
                      builder: (context, provider, child) {
                        return InputFieldDropDown(
                          hintText: "Enter capacitance",
                          labelText: "Capacitance",
                          controller: capacitanceController,
                          onTextChanged: (text) {
                            provider.validateCapacitance(double.tryParse(text));
                            provider.calculateFrequency();
                          },
                          validator: (text) => null,
                          errorText: provider.capacitance.error,
                          dropDownValue: provider.capacitanceUnit,
                          onDropDownChanged: (value) {
                            provider.setCapacitanceUnit(value!);
                            provider.calculateFrequency();
                          },
                          dropDownList: capacitanceDropDownList,
                        );
                      },
                    ),
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
