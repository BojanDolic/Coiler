import 'package:coiler_app/util/extensions/theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.controller,
      required this.onTextChanged,
      required this.validator,
      this.inputType = const TextInputType.numberWithOptions(decimal: true),
      this.hintText = "",
      this.labelText = "",
      this.maxLength,
      this.errorText,
      required this.unitText,
      required this.inputFormatter})
      : super(key: key);

  final TextEditingController controller;
  final Function(String? text) validator;
  final Function(dynamic value) onTextChanged;
  final List<TextInputFormatter> inputFormatter;
  final TextInputType inputType;
  final String hintText;
  final String labelText;
  final String unitText;
  final String? errorText;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) => onTextChanged(value),
      validator: (text) => validator(text),
      controller: controller,
      keyboardType: inputType,
      maxLines: 1,
      maxLength: maxLength,
      inputFormatters: inputFormatter,
      style: theme.textTheme.displayMedium,
      decoration: InputDecoration(
        suffixIcon: Padding(
          padding: const EdgeInsets.only(
            right: 9,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 9,
            ),
            decoration: BoxDecoration(
              color: context.getDropDownColor(),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Align(
              alignment: Alignment.center,
              widthFactor: 1,
              child: Text(
                unitText,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        hintStyle: theme.inputDecorationTheme.labelStyle,
        labelStyle: theme.inputDecorationTheme.labelStyle,
        floatingLabelStyle: MaterialStateTextStyle.resolveWith((states) {
          var color = theme.textTheme.displayMedium?.color;

          if (states.contains(MaterialState.error)) {
            color = Colors.red;
          } else if (states.contains(MaterialState.focused)) {
            color = theme.primaryColor;
          }
          return (theme.inputDecorationTheme.floatingLabelStyle?.copyWith(color: color))!;
        }),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor),
          borderRadius: BorderRadius.circular(9),
        ),
      ),
    );
  }
}
