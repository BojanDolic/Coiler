import 'package:coiler_app/arguments/HelicalCalculatorArgs.dart';
import 'package:coiler_app/dao/DriftCoilDao.dart';
import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/entities/ComponentData.dart';
import 'package:coiler_app/entities/HelicalCoil.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:coiler_app/providers/CoilProvider.dart';
import 'package:coiler_app/screens/calculators/helical_coil_screen.dart';
import 'package:coiler_app/util/DialogCallback.dart';
import 'package:coiler_app/util/SnackbarUtil.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/list_constants.dart';
import 'package:coiler_app/util/util_functions.dart';
import 'package:coiler_app/widgets/border_container.dart';
import 'package:coiler_app/widgets/component_info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoilInfoScreen extends StatefulWidget {
  const CoilInfoScreen({Key? key, required this.driftDao}) : super(key: key);

  static const String id = "/main/coils/coil_info";

  final DriftCoilDao driftDao;

  @override
  State<CoilInfoScreen> createState() => _CoilInfoScreenState();
}

class _CoilInfoScreenState extends State<CoilInfoScreen> {
  final converter = Converter();

  bool isEditingInfo = false;
  bool isInfoPanelExpanded = false;

  final coilDescController = TextEditingController();
  late FocusNode _descriptionFocusNode;

  final scrollController = ScrollController();

  void updateInfo() async {
    var coilName = coilDescController.text;
    if (coilName.isEmpty) {
      return;
    }

    Provider.of<CoilProvider>(context, listen: false).coil.coilInfo.coilDesc = coilName.trim();

    Provider.of<DriftCoilDao>(context, listen: false).updateCoilInfo(Provider.of<CoilProvider>(context, listen: false).coil);
  }

  @override
  void initState() {
    super.initState();
    _descriptionFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coilProvider = Provider.of<CoilProvider>(context, listen: true);

    coilDescController.text = coilProvider.coil.coilInfo.coilDesc; //= coil.coilDesc;
    return WillPopScope(
      onWillPop: () async {
        return await onWillPopScreen(context, isEditingInfo);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFf9fcff),
        body: SafeArea(
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverAppBar(
                shadowColor: Colors.black26,
                pinned: true,
                actions: [
                  !isEditingInfo
                      ? PopupMenuButton(
                          itemBuilder: (context) {
                            return popupCoilInfoScreenActions;
                          },
                          onSelected: (value) {
                            if (value == ACTION_EDIT_INFO) {
                              setState(() {
                                isEditingInfo = true;
                                if (scrollController.offset > 0.5) {
                                  scrollController.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.decelerate);
                                }
                                _descriptionFocusNode.requestFocus();
                              });
                            }
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        )
                      : IconButton(
                          onPressed: () async {
                            updateInfo();
                            setState(() {
                              _descriptionFocusNode.unfocus();
                              isEditingInfo = false;
                            });
                          },
                          icon: const Icon(Icons.check)),
                ],
                backgroundColor: const Color(0xFFf9fcff),
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 2,
                  title: Text(
                    Provider.of<CoilProvider>(context, listen: false).coil.coilInfo.coilName,
                    maxLines: 1,
                    style: boldCategoryTextStyle.copyWith(color: Colors.black87),
                  ),
                  background: Padding(
                    padding: const EdgeInsets.only(
                      bottom: kToolbarHeight,
                      top: kToolbarHeight,
                    ),
                    child: Image.asset(
                      "assets/teslacoil_image.png",
                      width: 100,
                      height: 100,
                    ),
                  ),
                  centerTitle: true,
                ),
                expandedHeight: 300,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BorderContainer(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Project description:",
                                  textAlign: TextAlign.start,
                                  style: normalTextStyleOpenSans14,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                TextField(
                                  controller: coilDescController,
                                  enabled: isEditingInfo,
                                  focusNode: _descriptionFocusNode,
                                  autofocus: true,
                                  autocorrect: false,
                                  maxLines: null,
                                  maxLength: isEditingInfo ? 130 : null,
                                  style: normalTextStyleOpenSans14,
                                  decoration: InputDecoration(
                                    hintText: (coilDescController.text.isEmpty && !isEditingInfo)
                                        ? "Project description not provided"
                                        : (coilDescController.text.isNotEmpty)
                                            ? Provider.of<CoilProvider>(context).coil.coilInfo.coilDesc
                                            : "Enter coil description",
                                    disabledBorder: InputBorder.none,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Coil specifications:",
                            style: boldCategoryTextStyle,
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          BorderContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Primary components:",
                                  style: boldCategoryTextStyle,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Visibility(
                                  visible: !coilProvider.isSolidStateCoil(),
                                  child: ListTile(
                                    leading: Image.asset(
                                      "assets/resfreq_icon.png",
                                      color: Colors.lightBlue,
                                      width: 42,
                                      height: 42,
                                    ),
                                    title: const Text("Primary frequency"),
                                    subtitle: Text(
                                      "Primary res freq",
                                      maxLines: 2,
                                    ),
                                    trailing: IconButton(
                                      onPressed: () async {},
                                      icon: const Icon(Icons.edit),
                                      //TODO add icon for calculating
                                      /*icon: hasSecondaryComponents(coil)
                                                  ? const Icon(
                                                      Icons.calculate_outlined,
                                                      color: Colors.lightBlue,
                                                    )
                                                  : const Icon(Icons.edit),*/
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible: !coilProvider.isSolidStateCoil(),
                                      child: Expanded(
                                        child: CoilComponent(
                                          title: "MMC",
                                          value: coilProvider.displayPrimaryCapacitance() ?? "Not added",
                                          componentAdded: coilProvider.hasCapacitorBank(),
                                          onTap: () {},
                                          componentType: ComponentType.capacitor,
                                          onActionSelected: (DialogAction action) {
                                            switch (action) {
                                              case DialogAction.onEdit:
                                                {
                                                  if (!coilProvider.hasCapacitorBank()) {
                                                    SnackbarUtil.showErrorSnackBar(context: context, errorText: "Capacitor bank is not added");
                                                    break;
                                                  }
                                                  break;
                                                }
                                              case DialogAction.onAdd:
                                                // TODO: Handle this case.
                                                break;
                                              case DialogAction.onInformation:
                                                // TODO: Handle this case.
                                                break;
                                              case DialogAction.onDelete:
                                                // TODO: Handle this case.
                                                break;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Expanded(
                                      child: CoilComponent(
                                        title: "Coil",
                                        value: coilProvider.displayPrimaryInductance() ?? "Not added",
                                        componentAdded: coilProvider.hasPrimaryCoil(),
                                        componentType: coilProvider.getPrimaryCoilComponentType(),
                                        onActionSelected: (action) async {
                                          if (action == DialogAction.onAdd) {
                                            if (coilProvider.hasPrimaryCoil()) {
                                              SnackbarUtil.showInfoSnackBar(
                                                context: context,
                                                text: "You have added the primary coil already.",
                                              );
                                              return;
                                            }

                                            openCoilSelectDialog();
                                          }

                                          if (action == DialogAction.onInformation) {
                                            if (!coilProvider.hasPrimaryCoil()) {
                                              SnackbarUtil.showInfoSnackBar(
                                                context: context,
                                                text: "Primary coil not added",
                                              );
                                              return;
                                            }
                                            openInformationDialog(context, coilProvider.coil, ComponentType.helicalCoil, true);
                                          } else if (action == DialogAction.onEdit) {
                                            if (!coilProvider.hasPrimaryCoil()) {
                                              SnackbarUtil.showInfoSnackBar(
                                                context: context,
                                                text: "Primary coil not added",
                                              );
                                              return;
                                            }

                                            //TODO navigate to edit screen

                                          } else if (action == DialogAction.onDelete) {
                                            if (!coilProvider.hasPrimaryCoil()) {
                                              SnackbarUtil.showErrorSnackBar(context: context, errorText: "Primary coil is not added");
                                              return;
                                            }

                                            await Provider.of<DriftCoilDao>(context, listen: false)
                                                .deletePrimary(coilProvider.coil)
                                                .catchError((err) {
                                              SnackbarUtil.showErrorSnackBar(context: context, errorText: "Error while deleting primary!");
                                              return;
                                            });

                                            coilProvider.removePrimaryCoil();
                                            SnackbarUtil.showInfoSnackBar(context: context, text: "Primary coil deleted");
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          BorderContainer(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Secondary components:",
                                  style: boldCategoryTextStyle,
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                ListTile(
                                  leading: Image.asset(
                                    "assets/resfreq_icon.png",
                                    color: Colors.lightBlue,
                                    width: 42,
                                    height: 42,
                                  ),
                                  title: const Text("Secondary frequency"),
                                  subtitle: Text(
                                    "Missing components!",
                                    maxLines: 2,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () async {},
                                    icon: const Icon(Icons.edit),
                                    //TODO add icon for calculating
                                    /*icon: hasSecondaryComponents(coil)
                                                ? const Icon(
                                                    Icons.calculate_outlined,
                                                    color: Colors.lightBlue,
                                                  )
                                                : const Icon(Icons.edit),*/
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: CoilComponent(
                                        title: "Topload",
                                        value: "1.12 pF",
                                        componentType: ComponentType.fullToroidTopload,
                                        componentAdded: coilProvider.hasTopload(),
                                        onActionSelected: (DialogAction action) {
                                          print("TAPPED at TOPLOAD $action");
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Expanded(
                                      child: CoilComponent(
                                        title: "Coil",
                                        value: "Not added",
                                        componentType: ComponentType.helicalCoil,
                                        componentAdded: coilProvider.hasSecondaryCoil(),
                                        onActionSelected: (DialogAction action) {
                                          print("TAPPED at SECONDARY COIL $action");
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: !Util.isSolidStateCoil(Provider.of<CoilProvider>(context, listen: false).coil),
                            child: CapBankContainer(),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: Util.isSparkGapCoil(Provider.of<CoilProvider>(context, listen: false).coil) ? true : false,
                      child: BorderContainer(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: TextButton(
                            child: Text("Calculate your spark gap distance\nTEST ADD HELICAL PRIMARY !"),
                            onPressed: () async {
                              final primary = PrimaryCoil(coilType: 2, turns: 10, inductance: 0.0000013);

                              coilProvider.setPrimaryCoil(primary);

                              await Provider.of<DriftCoilDao>(context, listen: false).insertPrimary(coilProvider.coil);
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openCoilSelectDialog({bool coilFromChange = false}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Center(
              child: Text(
                "Select coil type",
                style: normalTextStyleOpenSans14,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DialogCategoryWidget(
                  text: 'Flat coil',
                  imageAsset: 'assets/flat_coil_icon.png',
                  color: Colors.orangeAccent,
                  onTap: () {
                    Navigator.pop(context);
                    SnackbarUtil.showInfoSnackBar(context: context, text: "Currenty unavailable");
                  },
                ),
                const SizedBox(
                  height: 6,
                ),
                DialogCategoryWidget(
                  text: 'Helical coil',
                  imageAsset: 'assets/helical_coil_icon.png',
                  color: Colors.orangeAccent,
                  onTap: () {
                    Navigator.pop(context);

                    if (coilFromChange) {
                      if (Provider.of<CoilProvider>(context, listen: false).coil.primaryCoil?.coilType == ComponentType.helicalCoil.index) {
                        //TODO return message that current coil type is the same as selected type
                      } else {}
                    }

                    navigateToPrimaryCoilScreen();
                  },
                ),
              ],
            ),
          );
        });
  }

  void navigateToPrimaryCoilScreen() async {
    final HelicalCoil? helicalCoil = (await Navigator.pushNamed(
      context,
      HelicalCoilCalculatorScreen.id,
      arguments: HelicalCoilArgs(editing: true),
    )) as HelicalCoil;

    if (helicalCoil == null) {
      return;
    }

    final coilProvider = Provider.of<CoilProvider>(context, listen: false);

    final primaryCoil = PrimaryCoil(
      coilType: ComponentType.helicalCoil.index,
      turns: helicalCoil.turns,
      wireSpacing: helicalCoil.wireSpacing,
      wireDiameter: helicalCoil.wireDiameter,
      coilDiameter: helicalCoil.coilDiameter,
      inductance: helicalCoil.inductance,
    );

    coilProvider.setPrimaryCoil(primaryCoil);
    Provider.of<DriftCoilDao>(context, listen: false).insertPrimary(coilProvider.coil);
  }
}

class CoilComponent extends StatelessWidget implements DialogCallbacks {
  const CoilComponent({
    Key? key,
    required this.title,
    required this.value,
    required this.componentType,
    required this.componentAdded,
    required this.onActionSelected,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String value;
  final bool componentAdded;
  final ComponentType componentType;
  final VoidCallback? onTap;
  final void Function(DialogAction action) onActionSelected;

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      padding: EdgeInsets.zero,
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        leading: Image.asset(
          getComponentAssetImage(),
          color: componentAdded ? getComponentImageColor() : Colors.grey,
          width: 36,
          height: 36,
        ),
        title: Text(
          title,
          style: normalTextStyleOpenSans14,
        ),
        subtitle: Text(
          value,
          style: lightCategoryTextStyle,
        ),
        onTap: () {
          displayComponentActionDialog(context, this);
        },
      ),
    );
  }

  @override
  void onItemTap(DialogAction action) {
    onActionSelected(action);
  }

  String getComponentAssetImage() {
    String assetImage = "";
    switch (componentType) {
      case ComponentType.capacitor:
        assetImage = "assets/caps_icon.png";
        break;
      case ComponentType.flatCoil:
        assetImage = "assets/flat_coil_icon.png";
        break;
      case ComponentType.helicalCoil:
        assetImage = "assets/helical_coil_icon.png";
        break;
      case ComponentType.fullToroidTopload:
        assetImage = "assets/full_toroid_icon.png";
        break;
      case ComponentType.ringToroidTopload:
        assetImage = "assets/ring_toroid_icon.png";
        break;
      case ComponentType.sphereTopload:
        assetImage = "assets/sphere_icon.png";
        break;
    }
    return assetImage;
  }

  Color getComponentImageColor() {
    Color imageColor;

    if (componentType == ComponentType.capacitor) {
      imageColor = Colors.pinkAccent;
    } else if (componentType == ComponentType.flatCoil || componentType == ComponentType.helicalCoil) {
      imageColor = Colors.orangeAccent;
    } else {
      imageColor = Colors.lightBlueAccent;
    }

    return imageColor;
  }
}

class PrimaryFrequencyContainer extends StatelessWidget {
  const PrimaryFrequencyContainer({
    Key? key,
    required this.primaryCoilTap,
  }) : super(key: key);

  final VoidCallback primaryCoilTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<CoilProvider>(
      builder: (context, coilProvider, child) {
        return BorderContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Visibility(
                visible: !Util.isSolidStateCoil(Provider.of<CoilProvider>(context, listen: false).coil),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  leading: Image.asset(
                    "assets/resfreq_icon.png",
                    color: Colors.blue,
                    width: 42,
                    height: 42,
                  ),
                  title: const Text("Primary frequency"),
                  subtitle: Text(
                    "",
                    //displayResonantFrequency(coil.primary.frequency),
                    maxLines: 2,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      if (Util.hasPrimary(Provider.of<CoilProvider>(context, listen: false).coil)) {
                        //TODO NAVIGATE TO FREQUENCY CALCULATION
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "You need to add primary components to calculate resonant frequency",
                              style: normalTextStyleOpenSans14.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            duration: const Duration(seconds: 4),
                            backgroundColor: Colors.blue.shade800, //const Color(0xFFc9383b),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(9),
                            ),
                            action: SnackBarAction(
                                textColor: Colors.white,
                                label: "ADD",
                                onPressed: () {
                                  /*if (coil.primary.inductance == 0) {
                                  //TODO Navigate to secondary coil calculator
                                } else if (coil.mmcBank.capacitance == 0) {
                                  //TODO Navigate to calculating mmc
                                }*/
                                }),
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.edit),
                  ),
                ),
              ),
              Visibility(
                visible: !Util.isSolidStateCoil(Provider.of<CoilProvider>(context, listen: false).coil),
                child: const SizedBox(
                  height: 6,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !Util.isSolidStateCoil(Provider.of<CoilProvider>(context, listen: false).coil),
                    child: CoilComponentWidget(
                      assetName: "assets/caps_icon.png",
                      value: "", //getBankCapText(coil),
                      title: "MMC",
                      backgroundColor: Colors.blue,
                      isComponentAdded: true, //!(getBankCapText(coil) == "Not added"),
                      onTap: () {
                        //TODO Navigate to add or edit component
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 9,
                  ),
                  CoilComponentWidget(
                    title: "Primary coil",
                    value: hasHelicalCoil(Provider.of<CoilProvider>(context, listen: true).coil)
                        ? "${Converter().convertUnits(coilProvider.coil.primaryCoil?.inductance, Units.DEFAULT, Units.MICRO).toStringAsFixed(4)} uH"
                        : "Not added",
                    assetName: "assets/helical_coil_icon.png",
                    backgroundColor: Colors.orange,
                    isComponentAdded: hasHelicalCoil(Provider.of<CoilProvider>(context, listen: true).coil),
                    onTap: primaryCoilTap,
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class CoilComponentWidget extends StatelessWidget {
  const CoilComponentWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.assetName,
    this.backgroundColor,
    required this.isComponentAdded,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String value;
  final bool isComponentAdded;
  final String assetName;
  final Color? backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      padding: EdgeInsets.all(0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              isComponentAdded
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          assetName,
                          width: 36,
                          height: 36,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.add,
                          size: 36,
                          color: Colors.blue,
                        ),
                      ),
                    ),
              const SizedBox(
                height: 6,
              ),
              Text(
                "$title\n$value",
                style: normalTextStyleOpenSans14,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CapBankContainer extends StatelessWidget {
  const CapBankContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      child: ListTile(
        leading: Image.asset(
          "assets/caps_icon.png",
          color: Colors.orange,
          width: 42,
          height: 42,
        ),
        title: Text("MMC capacitance"),
        subtitle: Text("No data" //coil.mmcBank.capacitance.toStringAsFixed(4) + " nF",
            //TODO Add MMC capacitance
            ),
      ),
    );
  }
}

String displayResonantFrequency(double freq) {
  String resFreqText = "";

  if (freq > 0) {
    resFreqText = freq.toStringAsFixed(4) + " kHz";
  } else {
    resFreqText = "No data. Click edit to calculate the frequency !";
  }

  return resFreqText;
}

Future<bool> onWillPopScreen(BuildContext context, bool isEditing) async {
  bool _popScreen = true;

  if (isEditing) {
    _popScreen = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Leaving screen"),
          content:
              const Text("You are about to leave the screen but you haven't finished editing your coil info.\n\nDo you want to continue editing ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Leave"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                //_popScreen = false;
              },
              child: Text("Keep editing"),
            ),
          ],
        );
      },
    );
  }

  return Future.value(_popScreen);
}

void displayComponentActionDialog(BuildContext context, DialogCallbacks callbacks) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).backgroundColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            "Select option",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                tileColor: Theme.of(context).backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: const Icon(
                  Icons.add,
                  color: Colors.lightGreen,
                ),
                onTap: () {
                  Navigator.pop(context);
                  callbacks.onItemTap(DialogAction.onAdd);
                },
                title: const Text("Add component"),
              ),
              ListTile(
                tileColor: Theme.of(context).backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: const Icon(
                  Icons.edit,
                  color: Colors.lightBlueAccent,
                ),
                title: const Text("Edit component"),
                onTap: () {
                  Navigator.pop(context);
                  callbacks.onItemTap(DialogAction.onEdit);
                },
              ),
              ListTile(
                tileColor: Theme.of(context).backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: const Icon(
                  Icons.library_books_outlined,
                  color: Colors.orangeAccent,
                ),
                title: const Text("Component information"),
                onTap: () {
                  Navigator.pop(context);
                  callbacks.onItemTap(DialogAction.onInformation);
                },
              ),
              ListTile(
                tileColor: Theme.of(context).backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                leading: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
                title: const Text("Delete component"),
                onTap: () {
                  Navigator.pop(context);
                  callbacks.onItemTap(DialogAction.onDelete);
                },
              ),
            ],
          ),
        );
      });
}

void openInformationDialog(
  BuildContext context,
  Coil coil,
  ComponentType type,
  bool isPrimary,
) {
  showDialog(
    context: (context),
    builder: (context) {
      var dialog = ComponentInfoDialog(
        componentName: coil.coilInfo.coilName,
        assetImagePath: '',
        assetColor: Colors.blue,
        components: const [],
      );
      switch (type) {
        case ComponentType.capacitor:
          dialog = const ComponentInfoDialog(
            componentName: "Capacitor",
            assetImagePath: '',
            assetColor: Colors.blue,
            components: [],
          );
          break;
        case ComponentType.helicalCoil:
          dialog = ComponentInfoDialog(
            componentName: "Helical coil",
            assetImagePath: 'assets/helical_coil_icon.png',
            assetColor: Colors.orangeAccent,
            components: getComponentItems(coil, type, isPrimary),
          );
          break;
        case ComponentType.flatCoil:
          // TODO: Handle this case.
          break;
        case ComponentType.ringToroidTopload:
          // TODO: Handle this case.
          break;
        case ComponentType.fullToroidTopload:
          // TODO: Handle this case.
          break;
        case ComponentType.sphereTopload:
          // TODO: Handle this case.
          break;
      }
      return dialog;
    },
  );
}

List<ComponentData> getComponentItems(Coil coil, ComponentType type, bool isPrimary) {
  List<ComponentData> components = [];

  switch (type) {
    case ComponentType.capacitor:
      // TODO: Handle this case.
      break;
    case ComponentType.helicalCoil:
      {
        if (isPrimary) {
          final helicalCoil = coil.primaryCoil!;

          components = [
            ComponentData(
              name: "Inductance",
              value: Converter().convertToMicro(helicalCoil.inductance).toStringAsFixed(2) + " µH",
              imageAssetPath: "assets/icons/inductance_icon.png",
            ),
            ComponentData(
              name: "Wire diameter",
              value: Converter().convertFromDefaultToMili(helicalCoil.wireDiameter).toStringAsFixed(2) + " mm",
              imageAssetPath: "assets/icons/diameter_icon.png",
            ),
            ComponentData(
              name: "Wire spacing",
              value: helicalCoil.wireSpacing.toStringAsFixed(2) + " mm",
              imageAssetPath: "assets/icons/spacing_icon.png",
            ),
            ComponentData(
              name: "Turns",
              value: helicalCoil.turns.toString(),
              imageAssetPath: "assets/icons/quantity_icon.png",
            ),
          ];
        } else {
          final helicalCoil = coil.secondaryCoil!;

          final coilHeight = Converter().convertFromDefaultToMili(helicalCoil.getCoilHeight());
          final coilWidth = Converter().convertFromDefaultToMili(helicalCoil.coilDiameter);

          components = [
            ComponentData(
              name: "Inductance",
              value: Converter().convertToMicro(coil.primaryCoil?.inductance).toStringAsFixed(2) + " µH",
              imageAssetPath: "assets/icons/inductance_icon.png",
            ),
            ComponentData(
              name: "Wire diameter",
              value: Converter().convertFromDefaultToMili(coil.primaryCoil?.wireDiameter).toStringAsFixed(2) + " mm",
              imageAssetPath: "assets/icons/diameter_icon.png",
            ),
            ComponentData(
              name: "Turns",
              value: coil.primaryCoil?.turns.toString() ?? "No data",
              imageAssetPath: "assets/icons/quantity_icon.png",
            ),
            ComponentData(
              name: "H/W ratio",
              value: Util.getHeightToWidthRatio(coilHeight, coilWidth).toStringAsFixed(1),
              imageAssetPath: "assets/icons/quantity_icon.png",
            ),
          ];
        }

        break;
      }
    case ComponentType.flatCoil:
      // TODO: Handle this case.
      break;
    case ComponentType.ringToroidTopload:
      // TODO: Handle this case.
      break;
    case ComponentType.fullToroidTopload:
      // TODO: Handle this case.
      break;
    case ComponentType.sphereTopload:
      // TODO: Handle this case.
      break;
  }

  return components;
}

class DialogCategoryWidget extends StatelessWidget {
  const DialogCategoryWidget({
    Key? key,
    required this.imageAsset,
    required this.text,
    required this.onTap,
    this.color,
    this.size,
  }) : super(key: key);

  final String imageAsset;
  final String text;
  final Color? color;
  final double? size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: lightThemeBackgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Image.asset(
                imageAsset,
                width: size ?? 46,
                height: size ?? 46,
                color: color ?? Colors.blueAccent,
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                text,
                style: lightCategoryTextStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}

bool hasHelicalCoil(Coil coil) {
  return (coil.primaryCoil != null && coil.primaryCoil?.coilType == "HELICAL");
  //return (coil.helicalPrimary != null);
}
