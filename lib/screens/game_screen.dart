import 'package:flutter/material.dart';
import '../models/letter.dart';
import '../models/word.dart';
import '../services/tts_service.dart';
import '../widgets/letter_wheel.dart';
import '../widgets/word_display.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TTSService tts = TTSService();
  late List<Letter> letters;
  late Word currentWord;
  int score = 0;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    // Initialize with a set of letters (you can customize this)
    letters = [
      'A',
      'E',
      'I',
      'O',
      'U',
      'B',
      'C',
      'D',
      'F',
      'G',
      'H',
      'L',
      'M',
      'N',
      'P',
      'R',
      'S',
      'T',
      'W',
      'Y'
    ].map((char) => Letter(character: char)).toList();

    letters = LetterWheel.shuffleLetters(letters);
    currentWord = Word(letters: []);
  }

  void onLetterSelected(Letter letter) {
    setState(() {
      if (!letter.isSelected) {
        letter.isSelected = true;
        currentWord = Word(
          letters: [...currentWord.letters, letter],
          isValid: isValidWord(currentWord.word + letter.character),
        );
      }
    });
  }

  void clearWord() {
    setState(() {
      for (var letter in letters) {
        letter.isSelected = false;
      }
      currentWord = Word(letters: []);
    });
  }

  bool isValidWord(String word) {
    // TODO: Implement word validation against a dictionary
    // For now, let's consider words of length 3 or more as valid
    return word.length >= 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[300]!, Colors.blue[600]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Score: $score',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              WordDisplay(
                currentWord: currentWord,
                tts: tts,
                onClear: clearWord,
              ),
              LetterWheel(
                letters: letters,
                onLetterSelected: onLetterSelected,
                tts: tts,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    tts.dispose();
    super.dispose();
  }
}
