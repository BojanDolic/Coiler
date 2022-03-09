import 'package:coiler_app/dao/CoilDao.dart';
import 'package:coiler_app/entities/CapacitorBank.dart';
import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/entities/PrimaryCoil.dart';
import 'package:coiler_app/screens/coil_info_screen.dart';
import 'package:coiler_app/util/constants.dart' as Constants;
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/list_constants.dart';
import 'package:coiler_app/widgets/create_coil_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CoilsListScreen extends StatefulWidget {
  const CoilsListScreen({Key? key, required this.coilDao}) : super(key: key);

  final CoilDao coilDao;

  static const String id = "/main/coils";

  @override
  State<CoilsListScreen> createState() => _CoilsListScreenState();
}

class _CoilsListScreenState extends State<CoilsListScreen> {
  late CoilDao coilDao;

  String coilName = "";
  var coilType = Constants.CoilType.SPARK_GAP;
  final dialogFormKey = GlobalKey<FormState>();

  final coilNameController = TextEditingController();

  void createCoil() async {
    var coilName = coilNameController.text;

    coilDao.insertCoil(
      Coil(
          coilName: coilName,
          coilDesc: "",
          coilType: Converter.getCoilType(coilType),
          primary: PrimaryCoil(coilType: ""),
          mmcBank: CapacitorBank()),
    );
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
            setState(() {
              createCoil();
            });
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
    coilDao = widget.coilDao;
  }

  @override
  Widget build(BuildContext context) {
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
            stream: coilDao.getCoils(),
            initialData: [],
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.data != null && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No data available",
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
                        Navigator.pushNamed(context, CoilInfoScreen.id,
                            arguments: coil);
                        //TODO Navigate to coil screen
                      },
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: Colors.grey.shade300)),
                      contentPadding: const EdgeInsets.all(9),
                      leading: Image.asset(
                        "assets/tcoil_icon.png",
                        width: 46,
                        height: 46,
                      ),
                      title: Text(
                        coil.coilName,
                        style: Constants.boldCategoryTextStyle,
                      ),
                      subtitle: Text(
                        coil.coilDesc,
                        style: Constants.lightCategoryTextStyle,
                      ),
                      trailing: PopupMenu(coilDao: coilDao, coil: coil),
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
    required this.coilDao,
    required this.coil,
  }) : super(key: key);

  final CoilDao coilDao;
  final Coil coil;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      onSelected: (text) {
        if (text == Constants.ACTION_DELETE) {
          coilDao.deleteCoil(coil);
        } else if (text == Constants.ACTION_COPY_INFO) {
          Clipboard.setData(
            ClipboardData(
              text: "COIL INFORMATION\n\n"
                  "Name: ${coil.coilName}\n"
                  "Resonant frequency: ${coil.primary.frequency}",
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Information copied to clipboard",
                style: Constants.normalTextStyleOpenSans14
                    .copyWith(color: Colors.white),
              ),
              duration: const Duration(milliseconds: 1500),
            ),
          );
        }
      },
      itemBuilder: (context) {
        return popupCoilButtonActions;
      },
    );
  }
}
