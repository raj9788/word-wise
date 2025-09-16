import 'package:flutter/material.dart';
import 'game_screen.dart';
import '../services/tts_service.dart';
import '../models/game_difficulty.dart';

class HomeScreen extends StatelessWidget {
  final TTSService tts = TTSService();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[300]!,
              Colors.blue[600]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'WordWise',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                ...GameDifficulty.values
                    .map((difficulty) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              tts.speak('Starting ${difficulty.label} mode');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      GameScreen(difficulty: difficulty),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 20,
                              ),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Text(
                              difficulty.label,
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => tts.speak(
                      'How to play: Create words from the letters on the wheel. Tap a letter to select it, and tap the word to hear it spoken.'),
                  child: const Text(
                    'How to Play',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
