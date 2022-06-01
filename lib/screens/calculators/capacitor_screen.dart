import 'package:coiler_app/calculator/calculator.dart';
import 'package:coiler_app/entities/CapacitorBank.dart';
import 'package:coiler_app/entities/args/CapacitorBankArgs.dart';
import 'package:coiler_app/providers/mmc_provider.dart';
import 'package:coiler_app/util/SnackbarUtil.dart';
import 'package:coiler_app/util/color_constants.dart' as ColorUtil;
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/extensions/theme_extension.dart';
import 'package:coiler_app/util/list_constants.dart';
import 'package:coiler_app/util/ui_constants.dart';
import 'package:coiler_app/widgets/border_container.dart';
import 'package:coiler_app/widgets/input_field.dart';
import 'package:coiler_app/widgets/input_field_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CapacitorScreen extends StatefulWidget {
  const CapacitorScreen({
    Key? key,
    this.args,
  }) : super(key: key);

  static const String id = "/calculators/mmc";

  final CapacitorBankArgs? args;

  @override
  _CapacitorScreenState createState() => _CapacitorScreenState();
}

class _CapacitorScreenState extends State<CapacitorScreen> {
  Calculator calculator = Calculator();
  Converter converter = Converter();

  TextEditingController capacitanceController = TextEditingController();
  TextEditingController voltageController = TextEditingController();
  TextEditingController seriesCapNumController = TextEditingController();
  TextEditingController parallelCapNumController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  late CapacitorBankProvider provider;

  void loadCoilInfo(CapacitorBank capacitorBank) {
    final _provider = Provider.of<CapacitorBankProvider>(context, listen: false);

    _provider.loadCapBankInformation(capacitorBank);

    capacitanceController.text = _provider.capacitance.value.toString();
    voltageController.text = _provider.voltage.value.toString();
    seriesCapNumController.text = _provider.seriesCapsNum.value.toString();
    parallelCapNumController.text = _provider.parallelCapsNum.value.toString();
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      var args = widget.args;

      if (args != null) {
        var editing = args.editing;

        provider.isEditing(editing);

        if (editing) {
          final capBank = args.capBank;
          if (capBank != null) {
            loadCoilInfo(capBank);
          }
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    provider = Provider.of<CapacitorBankProvider>(context);
    return Scaffold(
      backgroundColor: theme.canvasColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  BorderContainer(
                    child: Text(
                      "MMC calculator can help you calculate your capacitor bank capacitance and voltage easily."
                      "\n\n Enter values below and result is calculated automatically.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayMedium,
                    ),
                    elevated: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  BorderContainer(
                    elevated: false,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Final capacitance: ${provider.capacitanceResult.toStringAsFixed(8)}",
                              style: theme.textTheme.headlineSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                              ),
                              decoration: BoxDecoration(
                                color: context.getDropDownColor(),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: DropdownButton<Units>(
                                style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                                borderRadius: BorderRadius.circular(9),
                                value: provider.resultCapacitanceUnit,
                                underline: Container(),
                                items: capacitanceDropDownList,
                                onChanged: (value) {
                                  provider.setCapacitanceResultUnit(value!);
                                  provider.calculateResult();
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
                              "MMC Voltage: ${provider.voltageResult}",
                              style: theme.textTheme.headlineSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: context.getDropDownColor(),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Text(
                                "V",
                                style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
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
                    controller: capacitanceController,
                    onTextChanged: (text) {
                      var capacitance = double.tryParse(text);
                      provider.validateCapacitance(capacitance);
                      provider.calculateResult();
                    },
                    validator: (text) => null,
                    errorText: provider.capacitance.error,
                    dropDownValue: provider.capacitanceUnit,
                    onDropDownChanged: (value) {
                      provider.setCapacitanceUnit(value!);
                      provider.calculateResult();
                    },
                    dropDownList: capacitanceDropDownList,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InputField(
                    controller: voltageController,
                    unitText: voltageUnitText,
                    inputType: const TextInputType.numberWithOptions(signed: true),
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 6,
                    hintText: "Enter single capacitor voltage",
                    labelText: "Voltage",
                    onTextChanged: (text) {
                      int? voltage = int.tryParse(text);
                      provider.validateVoltage(voltage);
                      provider.calculateResult();
                    },
                    validator: (text) => null,
                    errorText: provider.voltage.error,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InputField(
                    controller: seriesCapNumController,
                    hintText: "Capacitors in series",
                    labelText: "Series capacitor count",
                    onTextChanged: (text) {
                      int? seriesNum = int.tryParse(text);
                      provider.validateSeriesCaps(seriesNum);
                      provider.calculateResult();
                    },
                    validator: (text) => null,
                    errorText: provider.seriesCapsNum.error,
                    maxLength: 2,
                    unitText: "No.",
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InputField(
                    controller: parallelCapNumController,
                    hintText: "Capacitors in parallel",
                    labelText: "Parallel capacitor count",
                    onTextChanged: (text) {
                      int? parallelCapsNum = int.tryParse(text);
                      provider.validateParallelCaps(parallelCapsNum);
                      provider.calculateResult();
                    },
                    validator: (text) => null,
                    errorText: provider.parallelCapsNum.error,
                    maxLength: 2,
                    unitText: "No.",
                    inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  Visibility(
                    visible: provider.editing,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: MaterialButton(
                        elevation: 3,
                        focusElevation: 0,
                        highlightElevation: 0,
                        splashColor: Colors.lightBlueAccent,
                        color: ColorUtil.lightestBlue,
                        shape: roundedBorder16,
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

  void saveCoil() {
    if (!provider.validate()) {
      SnackbarUtil.showErrorSnackBar(context: context, errorText: "Check your input fields!");
      return;
    }

    final coil = provider.getCapacitorBank();
    Navigator.pop(context, coil);
  }
}
