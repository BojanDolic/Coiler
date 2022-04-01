import 'package:coiler_app/dao/DriftCoilDao.dart';
import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:coiler_app/providers/CoilProvider.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/list_constants.dart';
import 'package:coiler_app/util/util_functions.dart';
import 'package:coiler_app/widgets/border_container.dart';
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

  void updateInfo() async {
    var coilName = coilDescController.text;

    //var currentCoilName = Provider.of<CoilProvider>(context, listen: false).coil.coilInfo.coilName;
    if (coilName.isEmpty) {
      return;
    }

    Provider.of<CoilProvider>(context, listen: false).coil.coilInfo.coilDesc =
        coilName.trim();

    Provider.of<DriftCoilDao>(context, listen: false)
        .updateCoilInfo(Provider.of<CoilProvider>(context, listen: false).coil);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    coilDescController.text = Provider.of<CoilProvider>(context, listen: true)
        .coil
        .coilInfo
        .coilDesc; //= coil.coilDesc;
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
                          updateInfo();
                          setState(() {
                            isEditingInfo = false;
                          });
                        },
                        icon: const Icon(Icons.check)),
              ],
              backgroundColor: const Color(0xFFf9fcff),
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 2,
                title: Text(
                  Provider.of<CoilProvider>(context, listen: false)
                      .coil
                      .coilInfo
                      .coilName,
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
                                autocorrect: false,
                                maxLines: null,
                                maxLength: isEditingInfo ? 130 : null,
                                style: normalTextStyleOpenSans14,
                                decoration: InputDecoration(
                                  hintText: (coilDescController.text.isEmpty &&
                                          !isEditingInfo)
                                      ? "Project description not provided"
                                      : Provider.of<CoilProvider>(context)
                                          .coil
                                          .coilInfo
                                          .coilDesc,
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
                        Consumer<CoilProvider>(
                          builder: (context, coilProvider, child) {
                            return BorderContainer(
                              child: Column(
                                children: [
                                  PrimaryFrequencyContainer(
                                    primaryCoilTap: () async {
                                      coilProvider.setPrimaryCoil(
                                        PrimaryCoil(
                                            coilType: "HELICAL",
                                            inductance: 0.000015,
                                            wireDiameter: 0.040),
                                      );

                                      Provider.of<DriftCoilDao>(context,
                                              listen: false)
                                          .insertPrimary(
                                              Provider.of<CoilProvider>(context,
                                                      listen: false)
                                                  .coil);

                                      //TODO Navigate to add or edit component
                                    },
                                  ),
                                  const SizedBox(
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
                                        "" /*
                                      displayResonantFrequency(
                                          coil.primary.frequency)*/
                                        ,
                                        maxLines: 2,
                                      ),
                                      trailing: IconButton(
                                        onPressed: () async {
                                          /*if (hasSecondaryComponents(coil)) {
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
                                        }*/
                                        },
                                        icon: const Icon(Icons.edit),
                                        //TODO add icon for calculating
                                        /*icon: hasSecondaryComponents(coil)
                                          ? const Icon(
                                              Icons.calculate_outlined,
                                              color: Colors.lightBlue,
                                            )
                                          : const Icon(Icons.edit),*/
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Visibility(
                          visible: Util.isSolidStateCoil(
                              Provider.of<CoilProvider>(context, listen: false)
                                  .coil),
                          child: CapBankContainer(),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: Util.isSparkGapCoil(
                            Provider.of<CoilProvider>(context, listen: false)
                                .coil)
                        ? true
                        : false,
                    child: BorderContainer(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: TextButton(
                          child: Text(
                              "Calculate your spark gap distance\nTEST ADD HELICAL PRIMARY !"),
                          onPressed: () async {},
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
                visible: !Util.isSolidStateCoil(
                    Provider.of<CoilProvider>(context, listen: false).coil),
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
                      if (Util.hasPrimary(
                          Provider.of<CoilProvider>(context, listen: false)
                              .coil)) {
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
                visible: !Util.isSolidStateCoil(
                    Provider.of<CoilProvider>(context, listen: false).coil),
                child: const SizedBox(
                  height: 6,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !Util.isSolidStateCoil(
                        Provider.of<CoilProvider>(context, listen: false).coil),
                    child: CoilComponentWidget(
                      assetName: "assets/caps_icon.png",
                      value: "", //getBankCapText(coil),
                      title: "MMC",
                      backgroundColor: Colors.blue,
                      isComponentAdded:
                          true, //!(getBankCapText(coil) == "Not added"),
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
                    value: hasHelicalCoil(
                            Provider.of<CoilProvider>(context, listen: true)
                                .coil)
                        ? "${Converter().convertUnits(coilProvider.coil.primaryCoil?.inductance, Units.DEFAULT, Units.MICRO).toStringAsFixed(4)} uH"
                        : "Not added",
                    assetName: "assets/helical_coil_icon.png",
                    backgroundColor: Colors.orange,
                    isComponentAdded: hasHelicalCoil(
                        Provider.of<CoilProvider>(context, listen: true).coil),
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
        subtitle: Text(
            "No data" //coil.mmcBank.capacitance.toStringAsFixed(4) + " nF",
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

/*String getBankCapText(Coil coil) {
  if (coil.mmcBank.capacitance == 0) {
    return "Not added";
  } else {
    return coil.mmcBank.capacitance.toStringAsFixed(2);
  }
}*/

/*bool hasSecondaryComponents(Coil coil) {
  return (coil.secondary.inductance != 0 &&
      (coil.sphereTopload != null || coil.toroidTopload != null));
}*/

/*bool hasPrimaryComponents(Coil coil) {
  if (coil.coilType == Converter.getCoilType(CoilType.DRSSTC) ||
      coil.coilType == Converter.getCoilType(CoilType.SPARK_GAP)) {
    //return (coil.helicalPrimary != null && coil.mmcBank.capacitance != 0);
    return true;
  } else if (coil.coilType == Converter.getCoilType(CoilType.SSTC)) {
    return true;
    */ /*return (coil.helicalPrimary != null ||
        coil.helicalPrimary != null); //TODO Needs to be flat coil check*/ /*
  }
  return false;
}*/

bool hasHelicalCoil(Coil coil) {
  return (coil.primaryCoil != null && coil.primaryCoil?.coilType == "HELICAL");
  //return (coil.helicalPrimary != null);
}
