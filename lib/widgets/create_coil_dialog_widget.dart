import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/list_constants.dart';
import 'package:flutter/material.dart';

class CreateCoilDialog extends StatelessWidget {
  const CreateCoilDialog({
    Key? key,
    required this.coilNameController,
    required this.coilType,
    required this.onAddClick,
    required this.onTextChanged,
    required this.onCoilTypeChanged,
    required this.formKey,
  }) : super(key: key);

  final TextEditingController coilNameController;
  final CoilType coilType;
  final GlobalKey formKey;
  final VoidCallback onAddClick;
  final ValueSetter<String> onTextChanged;
  final ValueSetter<CoilType?> onCoilTypeChanged;

  @override
  Widget build(BuildContext context) {
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
            coilNameController.clear();
            Navigator.pop(context);
          },
          child: const Text(
            "Close",
            style: normalTextStyleOpenSans14,
          ),
        ),
        TextButton(
          onPressed: onAddClick,
          child: Text(
            "Add",
            style: normalTextStyleOpenSans14.copyWith(
                color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        )
      ],
      content: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: coilNameController,
              onChanged: onTextChanged,
              maxLength: 16,
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return "Name can't be empty";
                } else if (text.isNotEmpty && text.length < 4) {
                  return "Min 4 characters";
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                hintText: "Enter coil name",
                labelText: "Coil name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 3,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black45),
                borderRadius: BorderRadius.circular(9),
              ),
              child: DropdownButton<CoilType>(
                borderRadius: BorderRadius.circular(9),
                value: coilType,
                items: coilTypeDropDownList,
                onChanged: onCoilTypeChanged,
                isExpanded: true,
                underline: Container(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
