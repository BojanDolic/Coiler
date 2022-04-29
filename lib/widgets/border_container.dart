import 'package:coiler_app/util/color_constants.dart' as ColorUtil;
import 'package:flutter/material.dart';

/// [backgroundImage] is image asset path which displays image in the background of the container with certain opacity.
///
///
class BorderContainer extends StatelessWidget {
  const BorderContainer({
    Key? key,
    this.child,
    this.backgroundImage,
    this.elevated,
    this.padding = const EdgeInsets.all(9),
  }) : super(key: key);

  final Widget? child;
  final String? backgroundImage;
  final bool? elevated;
  final EdgeInsets padding;

  static const List<BoxShadow> shadows = [
    BoxShadow(
      color: Color(0xFFebebeb),
      blurRadius: 12,
      spreadRadius: 1,
      offset: Offset(0, 3),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).canvasColor,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          boxShadow: (elevated != null && elevated != false) ? shadows : [],
          border: Border.all(color: ColorUtil.borderColor), //Colors.black26
          borderRadius: BorderRadius.circular(16),
          image: backgroundImage != null
              ? DecorationImage(
                  opacity: 0.04,
                  fit: BoxFit.contain,
                  image: AssetImage(backgroundImage ?? ""),
                )
              : null,
        ),
        child: child,
      ),
    );
  }
}
