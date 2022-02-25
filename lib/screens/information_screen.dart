import 'package:coiler_app/util/constants.dart';
import 'package:flutter/material.dart';

class InformationScreen extends StatelessWidget {
  const InformationScreen({Key? key}) : super(key: key);

  static const String id = "/information";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Image.asset(
                        "assets/info_icon.png",
                        color: Colors.purple,
                        width: 48,
                        height: 48,
                      ),
                    ),
                    Text("Information",
                        style: boldCategoryTextStyle.copyWith(
                          fontSize: 22,
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
