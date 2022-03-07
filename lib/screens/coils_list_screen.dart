import 'package:coiler_app/dao/CoilDao.dart';
import 'package:coiler_app/entities/Coil.dart';
import 'package:coiler_app/util/constants.dart' as Constants;
import 'package:coiler_app/util/conversion.dart';
import 'package:coiler_app/util/list_constants.dart';
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

  final coilNameController = TextEditingController();

  void createCoil() async {
    var coilName = coilNameController.text;

    if (coilName.isEmpty) {
      return;
    }

    coilDao.insertCoil(
      Coil(null, coilName, "", Converter.getCoilType(coilType), 0.0),
    );
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
        label: Text("New coil"),
        icon: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text(
                    "Add new coil",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Close",
                        style: Constants.normalTextStyleOpenSans14,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          createCoil();
                        });
                        coilNameController.clear();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Add",
                        style: Constants.normalTextStyleOpenSans14.copyWith(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                  content: StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: coilNameController,
                            onChanged: (text) {
                              setState(() {
                                coilName = text;
                              });
                            },
                            maxLength: 16,
                            decoration: InputDecoration(
                                hintText: "Enter coil name",
                                labelText: "Coil name",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                errorText: coilName.isEmpty
                                    ? "Name can't be empty"
                                    : null),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: DropdownButton<Constants.CoilType>(
                              value: coilType,
                              items: coilTypeDropDownList,
                              onChanged: (value) {
                                setState(() {
                                  coilType = value!;
                                  print(coilType);
                                });
                              },
                              isExpanded: true,
                              underline: Container(),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                );
              });
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      onTap: () {
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
                        coils[index].coilName,
                        style: Constants.boldCategoryTextStyle,
                      ),
                      subtitle: Text(
                        coils[index].coilDesc,
                        style: Constants.lightCategoryTextStyle,
                      ),
                      trailing: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onSelected: (text) {
                          if (text == "delete") {
                            coilDao.deleteCoil(coils[index]);
                          } else if (text == "copy") {
                            Clipboard.setData(
                              ClipboardData(
                                text: "COIL INFORMATION\n\n"
                                    "Name: ${coils[index].coilName}\n"
                                    "Resonant frequency: ${coils[index].resonantFrequency}",
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Information copied to clipboard",
                                  style: Constants.normalTextStyleOpenSans14
                                      .copyWith(color: Colors.white),
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: "copy",
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Copy information"),
                                  Icon(
                                    Icons.copy,
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delete",
                                    style: Constants.normalTextStyleOpenSans14,
                                  ),
                                  Icon(
                                    Icons.highlight_remove_outlined,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),

                      /*Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  coilDao.deleteCoil(coils[index]);
                                },
                                icon: Icon(
                                  Icons.highlight_remove,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: "COIL INFORMATION\n\n"
                                            "Name: ${coils[index].coilName}\n"
                                            "Resonant frequency: ${coils[index].resonantFrequency}"));
                                  },
                                  icon: Icon(Icons.copy)),
                            ],
                          ),*/
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}
