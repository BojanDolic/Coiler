import 'package:flutter/material.dart';

class CapacitorScreen extends StatefulWidget {
  const CapacitorScreen({Key? key}) : super(key: key);

  static const String id = "/calculators/mmc";

  @override
  _CapacitorScreenState createState() => _CapacitorScreenState();
}

class _CapacitorScreenState extends State<CapacitorScreen> {
  double capacitance = 0.0;
  double capMultiplier = .0000001;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          capacitance = double.parse(value);
                        });
                      },
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: "Enter capacitance of one capacitor",
                        labelText: "Capacitance",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                    ),
                    child: DropdownButton<double>(
                      value: capMultiplier,
                      items: [
                        DropdownMenuItem(
                          child: Text("uF"),
                          value: .0000001,
                        ),
                        DropdownMenuItem(
                          child: Text("nF"),
                          value: .0000000001,
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          capMultiplier = value!;
                        });
                      },
                      isDense: true,
                    ),
                  )
                ],
              ),
              TextButton(
                onPressed: () {
                  var finalCapacitance = capacitance * capMultiplier;

                  print(finalCapacitance);
                  print(capacitance);
                  print(capMultiplier);

                  var formula = (capacitance * 5) / 10;
                  var formulaFinal = formula * capMultiplier;

                  print(formula.toStringAsFixed(2));
                  print(formulaFinal);
                },
                child: Text("Calculate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
