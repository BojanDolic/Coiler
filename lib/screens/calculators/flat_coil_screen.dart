import 'package:coiler_app/dialogs/DialogUtil.dart';
import 'package:coiler_app/entities/FlatCoil.dart';
import 'package:coiler_app/entities/args/FlatCoilArgs.dart';
import 'package:coiler_app/providers/FlatCoilProvider.dart';
import 'package:coiler_app/util/SnackbarUtil.dart';
import 'package:coiler_app/util/color_constants.dart' as ColorUtil;
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/extensions/theme_extension.dart';
import 'package:coiler_app/util/list_constants.dart';
import 'package:coiler_app/util/ui_constants.dart';
import 'package:coiler_app/widgets/border_container.dart';
import 'package:coiler_app/widgets/dropdown_widget.dart';
import 'package:coiler_app/widgets/input_field.dart';
import 'package:coiler_app/widgets/input_field_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FlatCoilScreen extends StatefulWidget {
  const FlatCoilScreen({
    Key? key,
    this.args,
  }) : super(key: key);

  final FlatCoilArgs? args;

  static const String id = "flat_coil_screen";

  @override
  State<FlatCoilScreen> createState() => _FlatCoilScreenState();
}

class _FlatCoilScreenState extends State<FlatCoilScreen> {
  TextEditingController innerDiameterTextController = TextEditingController();
  TextEditingController wireDiameterTextController = TextEditingController();
  TextEditingController turnSpacingTextController = TextEditingController();
  TextEditingController turnsTextController = TextEditingController();

  final converter = Converter();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      var args = widget.args;

      if (args != null) {
        var editing = args.editing;

        provider.editing = true;

        if (editing) {
          final coil = args.coil;
          if (coil != null) {
            loadCoilInfo(coil);
          }
        }
      }
    });
    super.initState();
  }

  void loadCoilInfo(FlatCoil coil) {
    final _provider = Provider.of<FlatCoilProvider>(context, listen: false);

    provider.editing = true;

    var _inductance = converter.convertUnits(coil.inductance, Units.DEFAULT, _provider.inductanceUnit);
    var _turnSpacing = converter.convertUnits(coil.turnSpacing, Units.DEFAULT, _provider.wireSpacingUnit);
    var _coilDiameter = converter.convertUnits(coil.innerDiameter, Units.DEFAULT, _provider.innerDiameterUnit);
    var _wireDiameter = converter.convertUnits(coil.wireDiameter, Units.DEFAULT, _provider.wireDiameterUnit);

    _provider.setTurns(coil.turns);
    turnsTextController.text = _provider.turns.value.toString();

    _provider.setWireDiameter(_wireDiameter);
    wireDiameterTextController.text = _provider.wireDiameter.value.toString();

    _provider.setInnerDiameter(_coilDiameter);
    innerDiameterTextController.text = _provider.innerDiameter.value.toString();

    _provider.setTurnSpacing(_turnSpacing);
    turnSpacingTextController.text = _provider.turnSpacing.value.toString();

    _provider.inductance = _inductance;
  }

  late FlatCoilProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    provider = Provider.of<FlatCoilProvider>(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          "Flat coil",
          style: theme.textTheme.headlineMedium,
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
                DialogUtil.openFlatSpiralCoilInfoDialog(context);
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // TODO Add flat spiral coil image
                const CalculatorDescription(
                  imagePath: "assets/flat_spiral_coil.png",
                  description: "Calculate inductance of flat spiral coil using this calculator. Result is calculated automatically.",
                  width: double.infinity,
                  height: 130,
                ),
                const SizedBox(
                  height: 9,
                ),
                BorderContainer(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Inductance: ${provider.inductance.toStringAsFixed(7)}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.displayMedium,
                        ),
                      ),
                      DropDownMenu<Units>(
                        value: provider.inductanceUnit,
                        items: inductanceDropDownList,
                        onSelect: (unit) {
                          provider.setInductanceUnit(unit!);
                          provider.calculateInductance();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                InputFieldDropDown(
                  controller: innerDiameterTextController,
                  hintText: "Inner diameter of the coil",
                  labelText: "Inner diameter (Di)",
                  onTextChanged: (newText) {
                    provider.validateInnerDiameter(double.tryParse(newText));
                    provider.calculateInductance();
                  },
                  validator: (value) => null,
                  errorText: provider.innerDiameter.error,
                  dropDownValue: provider.innerDiameterUnit,
                  onDropDownChanged: (value) {
                    provider.setInnerDiameterUnit(value!);
                    provider.calculateInductance();
                  },
                  dropDownList: lengthDropDownList,
                ),
                const SizedBox(
                  height: 9,
                ),
                InputFieldDropDown(
                  controller: wireDiameterTextController,
                  hintText: "Wire diameter of the coil",
                  labelText: "Wire diameter (W)",
                  onTextChanged: (newText) {
                    provider.validateWireDiameter(double.tryParse(newText));
                    provider.calculateInductance();
                  },
                  validator: (value) => null,
                  errorText: provider.wireDiameter.error,
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
                  controller: turnSpacingTextController,
                  hintText: "Turn spacing of the coil",
                  labelText: "Turn spacing (S)",
                  onTextChanged: (newText) {
                    provider.validateTurnSpacing(double.tryParse(newText));
                    provider.calculateInductance();
                  },
                  validator: (value) => null,
                  errorText: provider.turnSpacing.error,
                  dropDownValue: provider.wireSpacingUnit,
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
                  controller: turnsTextController,
                  onTextChanged: (text) {
                    provider.validateTurns(int.tryParse(text));
                    provider.calculateInductance();
                  },
                  validator: (text) => null,
                  hintText: "Enter number of turns",
                  labelText: "Turns",
                  errorText: provider.turns.error,
                  unitText: "No",
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
    );
  }

  void saveCoil() {
    if (!provider.validate()) {
      SnackbarUtil.showErrorSnackBar(context: context, errorText: "Check your input fields!");
      return;
    }

    final coil = provider.getCoil();
    Navigator.pop(context, coil);
  }
}

class CalculatorDescription extends StatelessWidget {
  const CalculatorDescription({
    Key? key,
    required this.imagePath,
    required this.description,
    this.width,
    this.height,
  }) : super(key: key);

  final String imagePath;
  final String description;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkTheme();
    final theme = Theme.of(context);

    return BorderContainer(
      child: Column(
        children: [
          Image.asset(
            imagePath,
            color: isDark ? Colors.grey.shade400 : Colors.black,
            width: (width != null) ? width : 150,
            height: (height != null) ? height : 250,
            fit: BoxFit.fill,
          ), //"assets/helical_coil_transparent.png"
          Text(
            description,
            textAlign: TextAlign.center,
            style: theme.textTheme.displayMedium,
          ),
        ],
      ),
    );
  }
}
