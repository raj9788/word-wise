import 'package:flutter/material.dart';
import '../models/word.dart';
import '../services/tts_service.dart';

class WordDisplay extends StatelessWidget {
  final Word currentWord;
  final TTSService tts;
  final VoidCallback onClear;

  const WordDisplay({
    Key? key,
    required this.currentWord,
    required this.tts,
    required this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              if (currentWord.word.isNotEmpty) {
                tts.speakWord(currentWord.word);
              }
            },
            child: Text(
              currentWord.word.isEmpty
                  ? 'Tap letters to form a word'
                  : currentWord.word,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: currentWord.isValid ? Colors.green : Colors.blue[700],
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (currentWord.word.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: onClear,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => tts.speakWord(currentWord.word),
                  icon: const Icon(Icons.volume_up_outlined),
                  label: const Text('Speak'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
