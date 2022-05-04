import 'package:coiler_app/screens/calculators_screen.dart';
import 'package:coiler_app/screens/coils_list_screen.dart';
import 'package:coiler_app/screens/information_screen.dart';
import 'package:coiler_app/util/color_constants.dart' as ColorUtil;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  static const String id = "/main";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/tcoil_icon.png",
                      width: 76,
                      height: 76,
                    ),
                    Text(
                      "Coiler",
                      style: theme.textTheme.headlineMedium?.copyWith(fontSize: 48),
                    ),
                    Text(
                      "Simple app for tesla coil calculations",
                      style: theme.textTheme.displaySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 26,
            ),
              CategoryCard(
                title: "Calculation",
                description: "A lot of different calculators for designing your tesla coils. Calculators like MMC, resonant frequency and so on.",
                image: Image.asset(
                  "assets/math_icon.png",
                  height: 42,
                  width: 42,
                  color: Colors.blue,
                ),
                onTap: () {
                  Navigator.pushNamed(context, CalculatorsScreen.id);
                },
              ),
              CategoryCard(
                title: "Your coils",
                description: "Here you can find all of your tesla coils.",
                image: Image.asset(
                  "assets/tesla_coil_outline_icon.png",
                  height: 42,
                  width: 42,
                  color: Colors.orange,
                ),
                onTap: () {
                  Navigator.pushNamed(context, CoilsListScreen.id);
                },
            ),
              CategoryCard(
                title: "Design guides",
                description: "Read about best practices when building coils and common mistakes to avoid.",
                image: Image.asset(
                  "assets/design_icon.png",
                  height: 42,
                  width: 42,
                  color: Colors.red,
                ),
                onTap: () {
                  //TODO Navigate to...
                },
              ),
              CategoryCard(
                title: "Miscellaneous",
                description: "Other things you can find useful.",
                image: Image.asset(
                  "assets/misc_icon.png",
                  height: 42,
                  width: 42,
                  color: Colors.green,
                ),
                onTap: () {
                  //TODO Navigate to...
                },
              ),
              CategoryCard(
                title: "Information",
                description: "Here you can find information about this app.",
                image: Image.asset(
                  "assets/info_icon.png",
                  height: 42,
                  width: 42,
                  color: Colors.purple,
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(InformationScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {

  const CategoryCard({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final String description;
  final Image image;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorUtil.borderColor),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: image,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 6,
                        right: 3,
                      ),
                      child: Text(
                        title,
                        style: theme.textTheme.headlineMedium,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 3,
                        bottom: 6,
                      ),
                      child: Text(
                        description,
                        style: theme.textTheme.displaySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
