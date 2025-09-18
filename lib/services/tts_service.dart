import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  String _lastSpoken = '';
  bool _isSpeaking = false;
  final Map<String, String> _pronunciationRules = {
    'A': 'ay',
    'B': 'bee',
    'C': 'see',
    'D': 'dee',
    'E': 'ee',
    'F': 'ef',
    'G': 'gee',
    'H': 'aitch',
    'I': 'eye',
    'J': 'jay',
    'K': 'kay',
    'L': 'el',
    'M': 'em',
    'N': 'en',
    'O': 'oh',
    'P': 'pee',
    'Q': 'cue',
    'R': 'ar',
    'S': 'es',
    'T': 'tee',
    'U': 'you',
    'V': 'vee',
    'W': 'double you',
    'X': 'ex',
    'Y': 'why',
    'Z': 'zee',
  };

  TTSService() {
    _initTTS();
  }

  Future<void> _initTTS() async {
    try {
      await _flutterTts.setLanguage("en-US");

      // Set a specific voice for better reliability
      await _flutterTts
          .setVoice({"name": "en-us-x-sfg#male_1-local", "locale": "en-US"});

      await _flutterTts.setSpeechRate(0.4); // Slower for clearer pronunciation
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      // Set completion handler
      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
      });

      // Set error handler
      _flutterTts.setErrorHandler((msg) {
        _isSpeaking = false;
        print('TTS Error: $msg');
      });

      _isInitialized = true;
    } catch (e) {
      print('TTS Initialization Error: $e');
      _isInitialized = false;
    }
  }

  Future<void> speak(String text, {bool useSpelling = false}) async {
    if (!_isInitialized) {
      await _initTTS();
    }
    if (!_isInitialized) return; // Don't proceed if initialization failed

    try {
      await _flutterTts.stop(); // Stop any ongoing speech
      if (useSpelling && text.length == 1) {
        // Use pronunciation rules for single letters
        final pronunciation = _pronunciationRules[text.toUpperCase()] ?? text;
        await _flutterTts.speak(pronunciation);
      } else {
        await _flutterTts.speak(text);
      }
    } catch (e) {
      print('TTS Speak Error: $e');
      _isSpeaking = false;
    }
  }

  Future<void> speakLetter(String letter) async {
    if (_isSpeaking || letter == _lastSpoken) return;

    _isSpeaking = true;
    _lastSpoken = letter;
    await speak(letter, useSpelling: true);
    await Future.delayed(const Duration(milliseconds: 50));
    _isSpeaking = false;
  }

  Future<void> speakWord(String word) async {
    if (word == _lastSpoken) return;
    _lastSpoken = word;

    try {
      _isSpeaking = true;

      // First spell out the word letter by letter
      for (var i = 0; i < word.length; i++) {
        final letter = word[i];
        await speakLetter(letter);

        // Longer pause between letters for better clarity
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // Slight pause before saying the complete word
      await Future.delayed(const Duration(milliseconds: 600));

      // Say "The word is" for better context
      await speak("The word is");
      await Future.delayed(const Duration(milliseconds: 300));

      // Say the complete word slowly
      await _flutterTts.setSpeechRate(0.3);
      await speak(word);
      await Future.delayed(const Duration(milliseconds: 300));

      // Repeat the word at normal speed
      await _flutterTts.setSpeechRate(0.4);
      await speak(word);
    } catch (e) {
      print('TTS Word Error: $e');
    } finally {
      _isSpeaking = false;
    }
  }

  Future<void> speakLetterInWord(String letter, String currentWord) async {
    if (_isSpeaking) return;

    try {
      _isSpeaking = true;
      await speakLetter(letter);

      // If we have a word of 3 or more letters, speak it
      if (currentWord.length >= 3 && currentWord != _lastSpoken) {
        await Future.delayed(const Duration(milliseconds: 200));
        await speak(currentWord);
        _lastSpoken = currentWord;
      }
    } catch (e) {
      print('TTS Letter in Word Error: $e');
    } finally {
      _isSpeaking = false;
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  void dispose() {
    _flutterTts.stop();
  }
}
