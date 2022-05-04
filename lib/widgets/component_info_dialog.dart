import 'package:coiler_app/entities/ComponentData.dart';
import 'package:flutter/material.dart';

class ComponentInfoDialog extends StatelessWidget {
  const ComponentInfoDialog({
    Key? key,
    required this.componentName,
    required this.sideText,
    required this.assetColor,
    required this.assetImagePath,
    required this.components,
  }) : super(key: key);

  final String assetImagePath;
  final String sideText;
  final String componentName;
  final Color assetColor;
  final List<ComponentData> components;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ImageIcon(
            AssetImage(assetImagePath),
            color: assetColor,
            size: 52,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            componentName,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            sideText,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(
            height: 24,
          ),
          Flexible(
            child: Container(
              width: double.maxFinite,
              child: ListView.builder(
                itemCount: components.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final component = components[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Card(
                      color: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      child: ListTile(
                        horizontalTitleGap: 6,
                        title: Text(component.name),
                        trailing: Text(component.value),
                        leading: component.imageAssetPath != null
                            ? ImageIcon(
                                AssetImage(component.imageAssetPath!),
                                color: assetColor,
                                size: 26,
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
