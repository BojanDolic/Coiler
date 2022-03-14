import 'package:coiler_app/dao/CoilDao.dart';
import 'package:coiler_app/entities/CapacitorBank.dart';
import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/entities/HelicalPrimary.dart';
import 'package:coiler_app/entities/SecondaryCoil.dart';
import 'package:coiler_app/screens/calculators/helical_coil_screen.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/list_constants.dart';
import 'package:coiler_app/util/util_functions.dart';
import 'package:coiler_app/widgets/border_container.dart';
import 'package:flutter/material.dart';

class CoilInfoScreen extends StatefulWidget {
  const CoilInfoScreen({Key? key, required this.coilDao}) : super(key: key);

  static const String id = "/main/coils/coil_info";

  final CoilDao coilDao;

  @override
  State<CoilInfoScreen> createState() => _CoilInfoScreenState();
}

class _CoilInfoScreenState extends State<CoilInfoScreen> {
  late CoilDao dao;
  final converter = Converter();

  bool isEditingInfo = false;
  bool isInfoPanelExpanded = false;

  final coilDescController = TextEditingController();

  void updateInfo(Coil coil) async {
    var coilName = coilDescController.text;

    if (coilName.isEmpty) {
      return;
    }

    setState(() {
      coil.coilDesc = coilName;
    });

    dao.updateCoil(coil);
  }

  @override
  void initState() {
    super.initState();
    dao = widget.coilDao;
  }

  @override
  Widget build(BuildContext context) {
    final coil = ModalRoute.of(context)!.settings.arguments as Coil;
    print(coil.mmcBank);
    print(coil.mmcBank.capacitance);
    coilDescController.text = coil.coilDesc;
    return Scaffold(
      backgroundColor: const Color(0xFFf9fcff),
      body: SafeArea(
        child: CustomScrollView(
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
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      )
                    : IconButton(
                        onPressed: () async {
                          updateInfo(coil);
                          setState(() {
                            isEditingInfo = false;
                          });
                        },
                        icon: Icon(Icons.check)),
              ],
              backgroundColor: const Color(0xFFf9fcff),
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 2,
                title: Text(
                  coil.coilName,
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
                          Container(
                            child: Column(
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
                                  autocorrect: false,
                                  maxLines: null,
                                  maxLength: isEditingInfo ? 130 : null,
                                  style: normalTextStyleOpenSans14,
                                  decoration: InputDecoration(
                                    hintText:
                                        (coilDescController.text.isEmpty &&
                                                !isEditingInfo)
                                            ? "Project description not provided"
                                            : "",
                                    disabledBorder: InputBorder.none,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(8),
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
                              children: [
                                PrimaryFrequencyContainer(
                                  coil: coil,
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                BorderContainer(
                                  child: ListTile(
                                    leading: Image.asset(
                                      "assets/resfreq_icon.png",
                                      color: Colors.lightBlue,
                                      width: 42,
                                      height: 42,
                                    ),
                                    title: const Text("Secondary frequency"),
                                    subtitle: Text(
                                      displayResonantFrequency(
                                          coil.primary.frequency),
                                      maxLines: 2,
                                    ),
                                    trailing: IconButton(
                                      onPressed: () async {
                                        if (hasSecondaryComponents(coil)) {
                                          //TODO NAVIGATE TO FREQUENCY CALCULATION
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "You need to add secondary components to calculate resonant frequency",
                                                style: normalTextStyleOpenSans14
                                                    .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              action: SnackBarAction(
                                                  textColor: Colors.white,
                                                  label: "ADD",
                                                  onPressed: () async {
                                                    if (coil.secondary
                                                            .inductance ==
                                                        0) {
                                                      final secondary =
                                                          await Navigator.pushNamed(
                                                              context,
                                                              HelicalCoilCalculatorScreen
                                                                  .id);

                                                      if (secondary != null &&
                                                          secondary
                                                              is SecondaryCoil) {
                                                        print(
                                                            "Returned value:\nFrequency ${secondary.frequency}");
                                                      } else {
                                                        print("Value is null");
                                                      }
                                                    } else if (coil
                                                                .toroidTopload ==
                                                            null ||
                                                        coil.sphereTopload ==
                                                            null) {
                                                      //TODO Navigate to selecting a topload
                                                    }
                                                  }),
                                              duration:
                                                  const Duration(seconds: 4),
                                              backgroundColor: Colors.redAccent,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(9),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      icon: hasSecondaryComponents(coil)
                                          ? const Icon(
                                              Icons.calculate_outlined,
                                              color: Colors.lightBlue,
                                            )
                                          : const Icon(Icons.edit),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Visibility(
                            visible: coil.coilType !=
                                Converter.getCoilType(CoilType.SSTC),
                            child: CapBankContainer(coil: coil),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: coil.coilType ==
                            Converter.getCoilType(CoilType.SPARK_GAP)
                        ? true
                        : false,
                    child: BorderContainer(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: TextButton(
                          child: Text(
                              "Calculate your spark gap distance\nTEST ADD HELICAL PRIMARY !"),
                          onPressed: () async {
                            var bank = CapacitorBank(
                              parallelCapacitorCount: 5,
                              seriesCapacitorCount: 6,
                              capacitance: 26.6,
                            );

                            //coil.mmcBank = bank;
                            coil.helicalPrimary = HelicalPrimaryCoil(
                              inductance: 10.1,
                              turns: 8,
                              wireSpacing: 0.01,
                              wireDiameter: 0.8,
                              coilDiameter: 17,
                            );

                            await dao.updateCoil(coil);
                            setState(() {});
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
    );
  }
}

class PrimaryFrequencyContainer extends StatelessWidget {
  const PrimaryFrequencyContainer({
    Key? key,
    required this.coil,
  }) : super(key: key);

  final Coil coil;

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Visibility(
            visible: !Util.isSolidStateCoil(coil),
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
                displayResonantFrequency(coil.primary.frequency),
                maxLines: 2,
              ),
              trailing: IconButton(
                onPressed: () {
                  if (hasPrimaryComponents(coil)) {
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
                        backgroundColor:
                            Colors.blue.shade800, //const Color(0xFFc9383b),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        action: SnackBarAction(
                            textColor: Colors.white,
                            label: "ADD",
                            onPressed: () {
                              if (coil.primary.inductance == 0) {
                                //TODO Navigate to secondary coil calculator
                              } else if (coil.mmcBank.capacitance == 0) {
                                //TODO Navigate to calculating mmc
                              }
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
            visible: !Util.isSolidStateCoil(coil),
            child: const SizedBox(
              height: 6,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: !Util.isSolidStateCoil(coil),
                child: CoilComponentWidget(
                  assetName: "assets/caps_icon.png",
                  value: getBankCapText(coil),
                  title: "MMC",
                  backgroundColor: Colors.blue,
                  isComponentAdded: !(getBankCapText(coil) == "Not added"),
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
                value: hasHelicalCoil(coil)
                    ? "${coil.helicalPrimary!.inductance} uH"
                    : "Not added",
                assetName: "assets/helical_coil_icon.png",
                backgroundColor: Colors.orange,
                isComponentAdded: hasHelicalCoil(coil),
                onTap: () {
                  //TODO Navigate to add or edit component
                },
              ),
            ],
          )
        ],
      ),
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
          padding: const EdgeInsets.only(
            bottom: 6,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 90,
                    height: 70,
                    decoration: BoxDecoration(
                      color: isComponentAdded
                          ? (backgroundColor ?? Colors.white38)
                          : Colors.white54,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                  ),
                  isComponentAdded
                      ? Image.asset(
                          assetName,
                          width: 36,
                          height: 36,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.add,
                        ),
                ],
                alignment: Alignment.center,
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
    required this.coil,
  }) : super(key: key);

  final Coil coil;

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
        subtitle: Text(
          coil.mmcBank.capacitance.toStringAsFixed(4) + " nF",
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

String getBankCapText(Coil coil) {
  if (coil.mmcBank.capacitance == 0) {
    return "Not added";
  } else {
    return coil.mmcBank.capacitance.toStringAsFixed(2);
  }
}

bool hasSecondaryComponents(Coil coil) {
  return (coil.secondary.inductance != 0 &&
      (coil.sphereTopload != null || coil.toroidTopload != null));
}

bool hasPrimaryComponents(Coil coil) {
  if (coil.coilType == Converter.getCoilType(CoilType.DRSSTC) ||
      coil.coilType == Converter.getCoilType(CoilType.SPARK_GAP)) {
    return (coil.helicalPrimary != null && coil.mmcBank.capacitance != 0);
  } else if (coil.coilType == Converter.getCoilType(CoilType.SSTC)) {
    return (coil.helicalPrimary != null ||
        coil.helicalPrimary != null); //TODO Needs to be flat coil check
  }
  return false;
}

bool hasHelicalCoil(Coil coil) {
  return (coil.helicalPrimary != null);
}
