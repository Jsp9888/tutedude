import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Allowed package for custom fonts

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Creative Counter',
      theme: ThemeData(
        // Using a light theme with subtle adjustments to ensure contrast with gradients
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const InteractiveCounterScreen(),
    );
  }
}

class InteractiveCounterScreen extends StatefulWidget {
  const InteractiveCounterScreen({super.key});

  @override
  State<InteractiveCounterScreen> createState() =>
      _InteractiveCounterScreenState();
}

class _InteractiveCounterScreenState extends State<InteractiveCounterScreen> {
  int _counter = 0;
  String _currentEmoji = '😐';
  // Mark as late and initialize in initState to ensure static members are ready.
  late List<Color> _currentGradientColors;

  // Pre-define a list of emojis for mood progression
  static const List<String> _emojis = [
    '😐', // Neutral (0-4)
    '🙂', // Slightly Happy (5-9)
    '😄', // Happy (10-14)
    '🤩', // Excited (15-19)
    '🥳', // Celebration (20-24)
    '🚀', // Blast off (25+)
  ];

  // Pre-define a list of harmonious color pairs for gradients
  static const List<List<Color>> _gradientColors = [
    [Color(0xFF8EC5FC), Color(0xFFE0C3FC)], // Blue to Purple
    [Color(0xFFFFADAD), Color(0xFFFFCCB3)], // Pink to Orange
    [Color(0xFFB5EAD7), Color(0xFFC7CEEA)], // Green to Light Purple
    [Color(0xFFF7CAC9), Color(0xFF92A8D1)], // Coral to Steel Blue
    [Color(0xFFEAD2AC), Color(0xFFF8EDEB)], // Muted Orange to Cream
    [Color(0xFFFEE140), Color(0xFFFA709A)], // Gold to Pink (Celebration)
  ];

  @override
  void initState() {
    super.initState();
    // Initialize _currentGradientColors here after the static _gradientColors is surely available.
    _currentGradientColors = _gradientColors[0];
  }

  void _incrementCounter() {
    setState(() {
      _counter++;

      // Determine the emoji based on the counter value
      int emojiIndex = (_counter ~/ 5).clamp(0, _emojis.length - 1);
      _currentEmoji = _emojis[emojiIndex];

      // Determine the gradient colors based on the counter value
      int gradientIndex = (_counter ~/ 5).clamp(0, _gradientColors.length - 1);
      _currentGradientColors = _gradientColors[gradientIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Make Scaffold transparent
      extendBodyBehindAppBar: true, // Allow body to go behind app bar
      appBar: AppBar(
        title: Text(
          'Creative Counter',
          style: GoogleFonts.outfit(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent, // Make app bar blend with background
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 700), // Smooth transition for background
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _currentGradientColors,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // AnimatedSwitcher for smooth emoji transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: Text(
                  _currentEmoji,
                  key: ValueKey<String>(_currentEmoji), // Key for animation
                  style: const TextStyle(fontSize: 100), // Large emoji
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Count:',
                style: GoogleFonts.outfit(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: const Offset(2.0, 2.0),
                      blurRadius: 3.0,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              // AnimatedSwitcher for smooth counter text transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Text(
                  '$_counter', // Counter value
                  key: ValueKey<int>(_counter), // Key for animation
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 80, // Larger font size
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: const Offset(3.0, 3.0),
                        blurRadius: 5.0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Center the FAB
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          backgroundColor: Colors.white, // White FAB background
          // Icon color dynamically matches the starting color of the current gradient
          foregroundColor: _currentGradientColors.first,
          shape: const CircleBorder(), // Ensure circular shape
          child: const Icon(Icons.add, size: 36), // Larger icon
        ),
      ),
    );
  }
}