import 'package:coiler_app/arguments/HelicalCalculatorArgs.dart';
import 'package:coiler_app/calculator/calculator.dart';
import 'package:coiler_app/dialogs/DialogUtil.dart';
import 'package:coiler_app/entities/HelicalCoil.dart';
import 'package:coiler_app/providers/HelicalCalculatorProvider.dart';
import 'package:coiler_app/util/SnackbarUtil.dart';
import 'package:coiler_app/util/color_constants.dart' as ColorUtil;
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/list_constants.dart';
import 'package:coiler_app/util/ui_constants.dart';
import 'package:coiler_app/widgets/border_container.dart';
import 'package:coiler_app/widgets/dropdown_widget.dart';
import 'package:coiler_app/widgets/input_field.dart';
import 'package:coiler_app/widgets/input_field_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HelicalCoilCalculatorScreen extends StatefulWidget {
  const HelicalCoilCalculatorScreen({Key? key, this.args}) : super(key: key);

  static String id = "/calculators/helical_coil";
  final HelicalCoilArgs? args;

  @override
  State<HelicalCoilCalculatorScreen> createState() => _HelicalCoilCalculatorScreenState();
}

class _HelicalCoilCalculatorScreenState extends State<HelicalCoilCalculatorScreen> {
  bool editing = false;

  final calculator = Calculator();
  final converter = Converter();

  final diameterController = TextEditingController();
  final spacingController = TextEditingController();
  final turnsController = TextEditingController();
  final wireDiameterController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void loadCoilInfo(HelicalCoil coil) {
    final _provider = Provider.of<HelicalProvider>(context, listen: false);

    provider.editing = true;

    var _inductance = converter.convertUnits(coil.inductance, Units.DEFAULT, _provider.inductanceUnit);
    var _turnSpacing = converter.convertUnits(coil.wireSpacing, Units.DEFAULT, _provider.turnSpacingUnit);
    var _coilDiameter = converter.convertUnits(coil.coilDiameter, Units.DEFAULT, _provider.coilDiameterUnit);
    var _wireDiameter = converter.convertUnits(coil.wireDiameter, Units.DEFAULT, _provider.wireDiameterUnit);

    _provider.setTurns(coil.turns);
    turnsController.text = _provider.turns.value.toString();

    _provider.setWireDiameter(_wireDiameter);
    wireDiameterController.text = _provider.wireDiameter.value.toString();

    _provider.setCoilDiameter(_coilDiameter);
    diameterController.text = _provider.coilDiameter.value.toString();

    _provider.setTurnSpacing(_turnSpacing);
    spacingController.text = _provider.turnSpacing.value.toString();

    _provider.inductance = _inductance.toString();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      var helicalCoilArgs = widget.args;

      if (helicalCoilArgs != null) {
        editing = helicalCoilArgs.editing;

        provider.editing = true;

        if (editing) {
          final coil = helicalCoilArgs.coil;
          if (coil != null) {
            loadCoilInfo(coil);
          }
        }
      }
    });
  }

  late HelicalProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HelicalProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Helical coil",
          style: boldTextStyleOpenSans15,
        ),
        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            itemBuilder: (context) {
              return popupCalculatorScreenInfo;
            },
            onSelected: (value) {
              if (value == actionInformation) {
                DialogUtil.openHelicalCoilInfoDialog(context);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.disabled,
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
                            "Inductance: ${provider.inductance}",
                            style: normalTextStyleOpenSans14,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        DropDownMenu<Units>(
                          value: provider.inductanceUnit,
                          items: inductanceDropDownList,
                          onSelect: (newValue) {
                            provider.setInductanceUnit(newValue!);
                            provider.calculateInductance();
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
                      provider.validateCoilDiameter(double.tryParse(text));
                      provider.calculateInductance();
                    },
                    errorText: provider.coilDiameter.error,
                    validator: (text) => null,
                    dropDownValue: provider.coilDiameterUnit,
                    onDropDownChanged: (value) {
                      provider.setCoilDiameterUnit(value!);
                      provider.calculateInductance();
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
                    errorText: provider.wireDiameter.error,
                    onTextChanged: (text) {
                      print("WIRE DIAMETER TEXT $text");
                      provider.validateWireDiameter(double.tryParse(text));
                      provider.calculateInductance();
                    },
                    validator: (text) => null,
                    dropDownValue: provider.wireDiameterUnit,
                    onDropDownChanged: (value) {
                      provider.setWireDiameterUnit(value!);
                      provider.calculateInductance();
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
                    errorText: provider.turnSpacing.error,
                    onTextChanged: (text) {
                      provider.validateTurnSpacing(double.tryParse(text));
                      provider.calculateInductance();
                    },
                    validator: (text) => null,
                    dropDownValue: provider.turnSpacingUnit,
                    onDropDownChanged: (value) {
                      provider.setTurnSpacingUnit(value!);
                      provider.calculateInductance();
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
                      provider.validateTurns(int.tryParse(text));
                      provider.calculateInductance();
                    },
                    errorText: provider.turns.error,
                    validator: (text) => null,
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
    if (!provider.validate) {
      SnackbarUtil.showErrorSnackBar(context: context, errorText: "Check your input fields!");
    }

    final coil = provider.saveCoil();
    Navigator.pop(context, coil);
  }
}
