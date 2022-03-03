import 'package:coiler_app/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldDropDown extends StatelessWidget {
  const InputFieldDropDown({
    Key? key,
    required this.controller,
    required this.onTextChanged,
    required this.validator,
    this.inputType = const TextInputType.numberWithOptions(decimal: true),
    this.hintText = "",
    this.labelText = "",
    required this.dropDownValue,
    required this.onDropDownChanged,
    required this.dropDownList,
    this.inputFormatters = const [],
  }) : super(key: key);

  final TextEditingController controller;
  final Function(String? text) validator;
  final ValueSetter<String> onTextChanged;
  final Function(Units? unit) onDropDownChanged;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType inputType;
  final String hintText;
  final String labelText;
  final Units dropDownValue;
  final List<DropdownMenuItem<Units>> dropDownList;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) => onTextChanged(value),
      validator: (text) => validator(text),
      controller: controller,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        suffixIcon: Padding(
          padding: const EdgeInsets.only(
            right: 9,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffe1efff),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              widthFactor: 1,
              child: DropdownButton<Units>(
                borderRadius: BorderRadius.circular(9),
                value: dropDownValue,
                style:
                    normalTextStyleOpenSans14.copyWith(color: Colors.black87),
                underline: Container(),
                items: dropDownList,
                onChanged: (value) => onDropDownChanged(value),
                isDense: true,
              ),
            ),
          ),
        ),
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
        ),
      ),
    );
  }
}
