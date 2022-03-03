import 'package:coiler_app/util/constants.dart';
import 'package:flutter/material.dart';

class DropDownMenu<T> extends StatelessWidget {
  const DropDownMenu(
      {Key? key,
      required this.value,
      required this.items,
      required this.onSelect})
      : super(key: key);

  final List<DropdownMenuItem<T>> items;
  final T value;
  final ValueSetter<T?> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
      ),
      decoration: BoxDecoration(
        color: lightBlueColor,
        borderRadius: BorderRadius.circular(9),
      ),
      child: DropdownButton<T>(
        borderRadius: BorderRadius.circular(9),
        style: normalTextStyleOpenSans14,
        value: value,
        underline: Container(),
        items: items,
        onChanged: onSelect,
      ),
    );
  }
}
