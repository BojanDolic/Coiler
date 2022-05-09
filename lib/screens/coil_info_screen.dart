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
import 'package:coiler_app/util/extension_functions.dart';
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
                                      coilProvider.displayPrimaryResonantFrequency() ?? "Missing primary components",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: IconButton(
                                      onPressed: () async {},
                                      icon: const Icon(Icons.edit),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
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

                                            navigateToPrimaryCoilScreen(ComponentType.helicalCoil, false);

                                            //TODO navigate to edit screen

                                          } else if (action == DialogAction.onDelete) {
                                            if (!coilProvider.hasPrimaryCoil()) {
                                              SnackbarUtil.showErrorSnackBar(context: context, errorText: "Primary coil is not added");
                                              return;
                                            }

                                            await Provider.of<DriftCoilDao>(context, listen: false).deletePrimary(coilProvider.coil).then(
                                              (value) {
                                                coilProvider.removePrimaryCoil();
                                                SnackbarUtil.showInfoSnackBar(context: context, text: "Primary coil deleted");
                                              },
                                            ).catchError(
                                              (err) {
                                                SnackbarUtil.showErrorSnackBar(context: context, errorText: "Error while deleting primary!");
                                                return;
                                              },
                                            );
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
                                  subtitle: const Text(
                                    "Missing components!",
                                    maxLines: 2,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () async {},
                                    icon: const Icon(Icons.edit),
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
                                        value: coilProvider.getToploadCapacitance() ?? "Not added",
                                        componentType: ComponentType.fullToroidTopload,
                                        componentAdded: coilProvider.hasTopload(),
                                        onActionSelected: (DialogAction action) {
                                          switch (action) {
                                            case DialogAction.onAdd:
                                              {
                                                if (coilProvider.coil.topload != null) {
                                                  SnackbarUtil.showInfoSnackBar(context: context, text: "Topload is already added.");
                                                  return;
                                                }
                                                openToploadSelectDialog();
                                                // TODO: Add topload addition
                                              }
                                              break;
                                            case DialogAction.onEdit:
                                              if (coilProvider.coil.topload == null) {
                                                SnackbarUtil.showInfoSnackBar(context: context, text: "Topload is not added.");
                                                return;
                                              }
                                              // TODO: Handle this case.
                                              break;
                                            case DialogAction.onInformation:
                                              if (coilProvider.coil.topload == null) {
                                                SnackbarUtil.showInfoSnackBar(context: context, text: "Topload is not added.");
                                                return;
                                              }
                                              openInformationDialog(context, coilProvider.coil, coilProvider.getToploadComponentType(), true);
                                              break;
                                            case DialogAction.onDelete:
                                              if (coilProvider.coil.topload == null) {
                                                SnackbarUtil.showInfoSnackBar(context: context, text: "Topload is not added.");
                                                return;
                                              }
                                              // TODO: Handle this case.
                                              break;
                                          }
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
                                        onActionSelected: (DialogAction action) {},
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                    SnackbarUtil.showInfoSnackBar(context: context, text: "Currently unavailable");
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

                    navigateToPrimaryCoilScreen(ComponentType.helicalCoil, true);
                  },
                ),
              ],
            ),
          );
        });
  }

  void openToploadSelectDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);

        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: Text(
              "Select topload type",
              style: theme.textTheme.headlineMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Close",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.blueAccent),
              ),
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DialogCategoryWidget(
                text: 'Sphere topload',
                imageAsset: 'assets/sphere_icon.png',
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.pop(context);
                  SnackbarUtil.showInfoSnackBar(context: context, text: "Currently unavailable");
                },
              ),
              const SizedBox(
                height: 6,
              ),
              DialogCategoryWidget(
                text: 'Toroid topload',
                imageAsset: 'assets/toroid_icon.png',
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.pop(context);
/*
                  if (coilFromChange) {
                    if (Provider.of<CoilProvider>(context, listen: false).coil.primaryCoil?.coilType == ComponentType.helicalCoil.index) {
                      //TODO return message that current coil type is the same as selected type
                    } else {}
                  }

                  navigateToPrimaryCoilScreen();*/
                },
              ),
              const SizedBox(
                height: 6,
              ),
              DialogCategoryWidget(
                text: 'Ring topload',
                imageAsset: 'assets/ring_toroid_icon.png',
                color: Colors.blueAccent,
                onTap: () {
                  Navigator.pop(context);
                  SnackbarUtil.showInfoSnackBar(context: context, text: "Currently unavailable");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void navigateToPrimaryCoilScreen(ComponentType type, bool addingComponent) async {
    //TODO Add support for flat coil also

    final coilProvider = Provider.of<CoilProvider>(context, listen: false);

    // User wants to add coil
    if (addingComponent) {
      final HelicalCoil? helicalCoil = (await Navigator.pushNamed(
        context,
        HelicalCoilCalculatorScreen.id,
        arguments: HelicalCoilArgs(editing: true),
      )) as HelicalCoil;

      if (helicalCoil == null) {
        return;
      }

      insertPrimaryCoil(helicalCoil, coilProvider);
    } else {
      final HelicalCoil? helicalCoil = (await Navigator.pushNamed(
        context,
        HelicalCoilCalculatorScreen.id,
        arguments: HelicalCoilArgs(editing: true, coil: coilProvider.coil.primaryCoil),
      )) as HelicalCoil;

      if (helicalCoil == null) {
        return;
      }

      updatePrimaryCoil(helicalCoil, coilProvider);
    }
  }

  void updatePrimaryCoil(HelicalCoil helicalCoil, CoilProvider provider) {
    final primaryCoil = PrimaryCoil(
      coilType: ComponentType.helicalCoil.index,
      turns: helicalCoil.turns,
      wireSpacing: helicalCoil.wireSpacing,
      wireDiameter: helicalCoil.wireDiameter,
      coilDiameter: helicalCoil.coilDiameter,
      inductance: helicalCoil.inductance,
    );

    provider.setPrimaryCoil(primaryCoil);
    Provider.of<DriftCoilDao>(context, listen: false).updatePrimaryCoil(provider.coil);
  }

  void insertPrimaryCoil(HelicalCoil helicalCoil, CoilProvider provider) {
    final primaryCoil = PrimaryCoil(
      coilType: ComponentType.helicalCoil.index,
      turns: helicalCoil.turns,
      wireSpacing: helicalCoil.wireSpacing,
      wireDiameter: helicalCoil.wireDiameter,
      coilDiameter: helicalCoil.coilDiameter,
      inductance: helicalCoil.inductance,
    );

    provider.setPrimaryCoil(primaryCoil);
    Provider.of<DriftCoilDao>(context, listen: false).insertPrimary(provider.coil);
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
        sideText: isPrimary ? "Primary" : "Secondary",
        assetImagePath: '',
        assetColor: Colors.blue,
        components: const [],
      );
      switch (type) {
        case ComponentType.capacitor:
          dialog = ComponentInfoDialog(
            componentName: "Capacitor",
            sideText: isPrimary ? "Primary" : "Secondary",
            assetImagePath: '',
            assetColor: Colors.blue,
            components: [],
          );
          break;
        case ComponentType.helicalCoil:
          dialog = ComponentInfoDialog(
            componentName: "Helical coil",
            sideText: isPrimary ? "Primary" : "Secondary",
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
          dialog = ComponentInfoDialog(
            componentName: "Toroid topload",
            sideText: isPrimary ? "Primary" : "Secondary",
            assetImagePath: 'assets/toroid_icon.png',
            assetColor: Colors.blueAccent,
            components: getComponentItems(coil, type, isPrimary),
          );
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

          final inductance = helicalCoil.inductance.toStringWithPrefix(3);
          final wireDiameter = helicalCoil.wireDiameter.toStringWithPrefix();
          final wireSpacing = helicalCoil.wireSpacing.toStringWithPrefix();

          components = [
            ComponentData(
              name: "Inductance",
              value: inductance.toHenry(), //Converter().convertToMicro(helicalCoil.inductance).toStringAsFixed(2) + " µH",
              imageAssetPath: "assets/icons/inductance_icon.png",
            ),
            ComponentData(
              name: "Wire diameter",
              value: wireDiameter.toMeter(),
              imageAssetPath: "assets/icons/diameter_icon.png",
            ),
            ComponentData(
              name: "Wire spacing",
              value: wireSpacing.toMeter(),
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
              value: Converter().convertFromDefaultToMicro(coil.primaryCoil?.inductance).toStringAsFixed(2) + " µH",
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
      color: Theme.of(context).listTileTheme.tileColor, //lightThemeBackgroundColor
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
                style: Theme.of(context).textTheme.displaySmall,
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
