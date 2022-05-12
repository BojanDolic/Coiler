import 'package:coiler_app/util/color_constants.dart' as ColorUtil;
import 'package:coiler_app/util/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class DropDownMenu<T> extends StatelessWidget {
  const DropDownMenu({Key? key, required this.value, required this.items, required this.onSelect}) : super(key: key);

  final List<DropdownMenuItem<T>> items;
  final T value;
  final ValueSetter<T?> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
      ),
      decoration: BoxDecoration(
        color: context.isDarkTheme() ? Colors.grey.shade800 : ColorUtil.lightestBlue,
        borderRadius: BorderRadius.circular(9),
      ),
      child: DropdownButton<T>(
        borderRadius: BorderRadius.circular(9),
        style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
        value: value,
        underline: Container(),
        items: items,
        onChanged: onSelect,
      ),
    );
  }
}
