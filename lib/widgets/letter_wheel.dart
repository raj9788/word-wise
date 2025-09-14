import 'dart:math';
import 'package:flutter/material.dart';
import '../models/letter.dart';
import '../services/tts_service.dart';
import 'letter_circle.dart';

class LetterWheel extends StatelessWidget {
  final List<Letter> letters;
  final Function(Letter) onLetterSelected;
  final TTSService tts;

  const LetterWheel({
    Key? key,
    required this.letters,
    required this.onLetterSelected,
    required this.tts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(letters.length, (index) {
          final angle = (2 * pi * index) / letters.length;
          final radius = 200.0; // Radius of the wheel

          return Positioned(
            left: 150 + radius * cos(angle) - 30,
            top: 150 + radius * sin(angle) - 30,
            child: LetterCircle(
              letter: letters[index],
              onTap: () => onLetterSelected(letters[index]),
              tts: tts,
            ),
          );
        }),
      ),
    );
  }

  // Helper method to shuffle the letters
  static List<Letter> shuffleLetters(List<Letter> letters) {
    final List<Letter> shuffled = List.from(letters);
    final random = Random();
    for (var i = shuffled.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }
    return shuffled;
  }
}
