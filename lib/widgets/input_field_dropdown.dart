import 'package:coiler_app/util/color_constants.dart' as ColorUtil;
import 'package:coiler_app/util/constants.dart';
import 'package:coiler_app/util/extensions/theme_extension.dart';
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
    this.errorText,
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
  final String? errorText;
  final Units dropDownValue;
  final List<DropdownMenuItem<Units>> dropDownList;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) => onTextChanged(value),
      validator: (text) => validator(text),
      controller: controller,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      style: theme.textTheme.displayMedium,
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
              color: context.isDarkTheme() ? Colors.grey.shade800 : ColorUtil.lightestBlue, //const Color(0xffe1efff),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              widthFactor: 1,
              child: DropdownButton<Units>(
                borderRadius: BorderRadius.circular(9),
                value: dropDownValue,
                style:
                    theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold), //normalTextStyleOpenSans14.copyWith(color: Colors.black87),
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
        errorText: errorText,
        hintStyle: theme.inputDecorationTheme.labelStyle,
        labelStyle: theme.inputDecorationTheme.labelStyle, //theme.textTheme.displayMedium, // (errorText == null) ? theme.primaryColor : Colors.red
        floatingLabelStyle: MaterialStateTextStyle.resolveWith((states) {
          var color = theme.textTheme.displayMedium?.color;

          if (states.contains(MaterialState.error)) {
            color = Colors.red;
          } else if (states.contains(MaterialState.focused)) {
            color = theme.primaryColor;
          }

          //final color = (states.contains(MaterialState.error)) ? Colors.red : theme.primaryColor;
          return (theme.inputDecorationTheme.floatingLabelStyle?.copyWith(color: color))!;
        }),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(9),
        ),
        enabledBorder: theme.inputDecorationTheme.enabledBorder,
      ),
    );
  }

  TextStyle? getLabelStyle(ThemeData theme, Set<MaterialState> states) {
    var style = theme.inputDecorationTheme.labelStyle;

    if (states.contains(MaterialState.focused)) {
      style = theme.inputDecorationTheme.labelStyle?.copyWith(color: theme.primaryColor);
    } else if (states.contains(MaterialState.error)) {
      style = theme.inputDecorationTheme.labelStyle?.copyWith(color: Colors.red);
    }
    return style!;
  }
}
