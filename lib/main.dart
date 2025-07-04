import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const BMICalculatorApp());

class BMIController extends ChangeNotifier {
  double _height = 150.0;
  double _weight = 60.0;

  double get height => _height;
  double get weight => _weight;

  set height(double value) {
    _height = value;
    notifyListeners();
  }

  set weight(double value) {
    _weight = value;
    notifyListeners();
  }

  double get bmi => _weight / pow((_height / 100), 2);

  String get category {
    final b = bmi;
    if (b < 18.5) return "Underweight";
    if (b < 24.9) return "Normal";
    if (b < 29.9) return "Overweight";
    return "Obese";
  }

  Color get categoryColor {
    final b = bmi;
    if (b < 18.5) return Colors.blue;
    if (b < 24.9) return Colors.green;
    if (b < 29.9) return Colors.orange;
    return Colors.red;
  }

  String getRandomDialog() {
    final dialogs = {
      "Underweight": [
        "Kha lo thoda!",
        "Salman bhai kehti, 'Yeh kya hawa ho?'",
        "Bro, protein shake le le!",
        "Akele salad se kaam nahi chalega",
        "Burger khilaun kya?"
      ],
      "Normal": [
        "Perfect bro, Bilkul Dabangg!",
        "Fit ho, hit ho!",
        "Kya baat! Ek number!",
        "Salman bhai bhi kahe: 'Sahi ja rahe ho'",
        "Body toh banni chahiye!"
      ],
      "Overweight": [
        "Bas kar bhai, sab kuch kha jaega kya?",
        "Zyada ho gaya bhai, treadmill dhoondh!",
        "Moti biceps nahi pet!",
        "Aaloo kam, salad zyada!",
        "Dum hai par dher bhi hai!"
      ],
      "Obese": [
        "Kya re bhai, gym kab chalu karein?",
        "Ye body nahi gola ban gaya!",
        "Salman bhai bhi confuse ho jaye!",
        "Chal bhai walk pe!",
        "Ab bas, pizza ka break!"
      ]
    };
    final list = dialogs[category] ?? ["Bhai kuch toh gadbad hai"];
    list.shuffle();
    return list.first;
  }

  void reset() {
    _height = 150.0;
    _weight = 60.0;
    notifyListeners();
  }
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BMIController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0F172A),
        ),
        home: const BMIScreen(),
      ),
    );
  }
}

class BMIScreen extends StatelessWidget {
  const BMIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BMIController>(context);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Icon(Icons.fitness_center, color: Colors.amber, size: 60),
                  const SizedBox(height: 20),
                  Text(
                    'BMI Calculator',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  customSlider(
                    label: 'Height',
                    unit: 'cm',
                    value: controller.height,
                    onChanged: (val) => controller.height = val,
                    min: 100,
                    max: 220,
                  ),
                  const SizedBox(height: 20),
                  customSlider(
                    label: 'Weight',
                    unit: 'kg',
                    value: controller.weight,
                    onChanged: (val) => controller.weight = val,
                    min: 30,
                    max: 150,
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Your BMI',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          controller.bmi.toStringAsFixed(1),
                          style: GoogleFonts.poppins(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          controller.category,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            color: controller.categoryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            controller.getRandomDialog(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: controller.reset,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reset"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget customSlider({
    required String label,
    required String unit,
    required double value,
    required Function(double) onChanged,
    required double min,
    required double max,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ${value.toStringAsFixed(0)} $unit',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
        ),
        Slider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: Colors.amber,
          thumbColor: Colors.white,
        ),
      ],
    );
  }
}
