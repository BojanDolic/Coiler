import 'package:coiler_app/dao/CoilDao.dart';
import 'package:coiler_app/entities/CapacitorBank.dart';
import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/list_constants.dart';
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

  String displayResonantFrequency(double freq) {
    String resFreqText = "";

    if (freq > 0) {
      resFreqText = freq.toStringAsFixed(4) + " kHz";
    } else {
      resFreqText = "No data. Click edit to calculate the frequency !";
    }

    return resFreqText;
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
              backgroundColor: Colors.white,
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
                          Text(
                            "Coil specifications:",
                            style: boldCategoryTextStyle,
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          BorderContainer(
                            child: ListTile(
                              leading: Image.asset(
                                "assets/resfreq_icon.png",
                                color: Colors.blue,
                                width: 42,
                                height: 42,
                              ),
                              title: Text("Resonant frequency"),
                              subtitle: Text(
                                displayResonantFrequency(
                                    coil.primary.frequency),
                                maxLines: 2,
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  //TODO Navigate to resonant frequency calculator
                                },
                                icon: Icon(Icons.edit),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          BorderContainer(
                            child: ListTile(
                              leading: Image.asset(
                                "assets/caps_icon.png",
                                color: Colors.orange,
                                width: 42,
                                height: 42,
                              ),
                              title: Text("MMC capacitance"),
                              subtitle: Text(
                                coil.mmcBank.capacitance.toStringAsFixed(4) +
                                    " nF",
                              ),
                            ),
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
                          child: Text("Calculate your spark gap distance !"),
                          onPressed: () async {
                            var bank = CapacitorBank(
                              parallelCapacitorCount: 5,
                              seriesCapacitorCount: 6,
                              capacitance: 26.6,
                            );

                            coil.mmcBank = bank;

                            dao.updateCoil(coil);
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
