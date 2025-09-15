import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  String _lastSpoken = '';
  bool _isSpeaking = false;

  TTSService() {
    _initTTS();
  }

  Future<void> _initTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts
        .setVoice({"name": "en-us-x-sfg#male_1-local", "locale": "en-US"});
    await _flutterTts
        .setSpeechRate(0.5); // Slower speech rate for better comprehension
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await _initTTS();
    }
    await _flutterTts.stop(); // Stop any ongoing speech
    await _flutterTts.speak(text);
  }

  Future<void> speakLetter(String letter) async {
    if (_isSpeaking || letter == _lastSpoken) return;

    _isSpeaking = true;
    _lastSpoken = letter;
    // Speak individual letters clearly
    await speak(letter);
    _isSpeaking = false;
  }

  Future<void> speakWord(String word) async {
    if (word == _lastSpoken) return;
    _lastSpoken = word;

    // First spell out the word letter by letter
    for (var letter in word.split('')) {
      await speakLetter(letter);
      await Future.delayed(const Duration(milliseconds: 250));
    }
    // Then pronounce the whole word
    await Future.delayed(const Duration(milliseconds: 500));
    await speak(word);
  }

  Future<void> speakLetterInWord(String letter, String currentWord) async {
    if (_isSpeaking) return;

    _isSpeaking = true;
    await speakLetter(letter);

    // If we have a word of 3 or more letters, speak it
    if (currentWord.length >= 3 && currentWord != _lastSpoken) {
      await Future.delayed(const Duration(milliseconds: 100));
      await speak(currentWord);
      _lastSpoken = currentWord;
    }
    _isSpeaking = false;
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  void dispose() {
    _flutterTts.stop();
  }
}
