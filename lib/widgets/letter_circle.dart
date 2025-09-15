import 'package:flutter/material.dart';
import '../models/letter.dart';
import '../services/tts_service.dart';

class LetterCircle extends StatelessWidget {
  final Letter letter;
  final VoidCallback onTap;
  final TTSService tts;

  const LetterCircle({
    Key? key,
    required this.letter,
    required this.onTap,
    required this.tts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        tts.speakLetter(letter.character);
        onTap();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: letter.isSelected ? Colors.blue[200] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter.character.toUpperCase(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: letter.isSelected ? Colors.white : Colors.blue[700],
            ),
          ),
        ),
      ),
    );
  }
}
