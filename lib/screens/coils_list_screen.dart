import 'package:coiler_app/dao/DriftCoilDao.dart';
import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/entities/CoilInfo.dart';
import 'package:coiler_app/providers/CoilProvider.dart';
import 'package:coiler_app/screens/coil_info_screen.dart';
import 'package:coiler_app/util/SnackbarUtil.dart';
import 'package:coiler_app/util/constants.dart' as Constants;
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/list_constants.dart';
import 'package:coiler_app/widgets/create_coil_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CoilsListScreen extends StatefulWidget {
  const CoilsListScreen({Key? key}) : super(key: key);

  static const String id = "/main/coils";

  @override
  State<CoilsListScreen> createState() => _CoilsListScreenState();
}

class _CoilsListScreenState extends State<CoilsListScreen> {
  String coilName = "";
  var coilType = Constants.CoilType.SPARK_GAP;
  final dialogFormKey = GlobalKey<FormState>();

  final coilNameController = TextEditingController();

  void createCoil() async {
    var coilName = coilNameController.text;

    Coil coil = Coil();
    coil.coilInfo = CoilInfo(coilName: coilName, coilType: Converter.getCoilType(coilType));

    Provider.of<DriftCoilDao>(context, listen: false).insertCoil(coil);

    /*var coilId = await coilDao.insertCoil(
      Coil(
        coilName: coilName,
        coilDesc: "",
        coilType: Converter.getCoilType(coilType),
        primary: PrimaryCoil(coilType: ""),
        secondary: SecondaryCoil(),
        sparkGap: Sparkgap(),
        mmcBank: CapacitorBank(),
      ),
    );

    coilDao.insertPrimary(
      HelicalPrimaryBase(coilId: coilId),
    );*/
  }

  Widget openDialog() {
    return StatefulBuilder(builder: (context, setState) {
      return CreateCoilDialog(
        coilNameController: coilNameController,
        coilType: coilType,
        formKey: dialogFormKey,
        onTextChanged: (text) {
          setState(() {
            coilName = text;
          });
        },
        onCoilTypeChanged: (coilType) {
          setState(() {
            this.coilType = coilType!;
          });
        },
        onAddClick: () async {
          if (dialogFormKey.currentState!.validate()) {
            //setState(() {
            createCoil();
            //});
            coilNameController.clear();
            Navigator.pop(context);
          }
        },
      );
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final coilDaoProvider = Provider.of<DriftCoilDao>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        isExtended: true,
        label: const Text("New coil"),
        icon: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return openDialog();
            },
          );
        },
      ),
      body: SafeArea(
        child: StreamBuilder<List<Coil>>(
            stream: coilDaoProvider.getCoils(),
            initialData: [],
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data != null && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No coils found\nTry to add new coil !",
                    textAlign: TextAlign.center,
                    style: Constants.normalTextStyleOpenSans14,
                  ),
                );
              }

              var coils = snapshot.requireData;

              return ListView.builder(
                itemCount: coils.length,
                itemBuilder: (context, index) {
                  var coil = coils[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      onTap: () {
                        Provider.of<CoilProvider>(context, listen: false).coil = coil;
                        Navigator.pushNamed(context, CoilInfoScreen.id, arguments: coil);
                      },
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade300)),
                      contentPadding: const EdgeInsets.all(9),
                      leading: Image.asset(
                        "assets/tcoil_icon.png",
                        width: 46,
                        height: 46,
                      ),
                      title: Text(
                        coil.coilInfo.coilName,
                        style: Constants.boldCategoryTextStyle,
                      ),
                      subtitle: Text(
                        coil.coilInfo.coilDesc,
                        style: Constants.lightCategoryTextStyle,
                      ),
                      trailing: PopupMenu(coil: coil),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}

class PopupMenu extends StatelessWidget {
  const PopupMenu({
    Key? key,
    required this.coil,
  }) : super(key: key);

  final Coil coil;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onSelected: (text) {
        if (text == Constants.ACTION_DELETE) {
          Provider.of<DriftCoilDao>(context, listen: false).deleteCoil(coil);
        } else if (text == Constants.ACTION_COPY_INFO) {
          copyCoilInfoToClipBoard(context);
        }
      },
      itemBuilder: (context) {
        return popupCoilButtonActions;
      },
    );
  }

  void copyCoilInfoToClipBoard(BuildContext context) {
    Clipboard.setData(
      ClipboardData(
          text: "COIL INFORMATION\n\n"
              "Name: ${coil.coilInfo.coilName}\n"
              "Coil type: ${coil.coilInfo.coilType}\n"
              "${coil.primaryCoil != null ? coil.primaryCoil.toString() : ""}\n"
              "${coil.topload != null ? coil.topload.toString() : ""}\n"),
    );
    SnackbarUtil.showInfoSnackBar(context: context, text: "Coil information copied to clipboard.");
  }
}
