import 'dart:math';
import '../models/letter.dart';
import '../models/game_difficulty.dart';

class WordGeneratorService {
  // Sample word list - in a real app, this would come from a larger dictionary
  static const List<String> _wordList = [
    // 4-5 letter words
    'word', 'play', 'game', 'mind', 'leaf', 'song', 'rain', 'blue',
    'hope', 'dream', 'light', 'dance', 'space',
    // 5-6 letter words
    'wonder', 'bright', 'planet', 'flower', 'wisdom', 'temple',
    'silent', 'coffee', 'garden', 'purple',
    // 7-9 letter words
    'elephant', 'mountain', 'sunshine', 'butterfly', 'precious',
    'moonlight', 'symphony', 'universe', 'adventure', 'brilliant',
    'wonderful', 'discovery', 'happiness'
  ];

  List<String> generateWords(GameDifficulty difficulty) {
    final words = _wordList
        .where((word) =>
            word.length >= difficulty.minWordLength &&
            word.length <= difficulty.maxWordLength)
        .map((word) => word.toUpperCase()) // Convert all words to uppercase
        .toList();

    words.shuffle();
    return words.take(difficulty.totalWords).toList();
  }

  List<Letter> generateLettersFromWords(List<String> words) {
    final Set<String> uniqueLetters = {};
    final Map<String, int> letterFrequency = {};

    // Count frequency of each letter in target words
    for (final word in words) {
      final upperWord = word.toUpperCase();
      for (final char in upperWord.split('')) {
        uniqueLetters.add(char);
        letterFrequency[char] = (letterFrequency[char] ?? 0) + 1;
      }
    }

    // Calculate extra letters based on difficulty and word lengths
    final averageWordLength =
        words.fold<int>(0, (sum, word) => sum + word.length) ~/ words.length;
    final extraLetterCount = _calculateExtraLetters(averageWordLength);

    // Generate confusing letters based on actual letters
    final extraLetters = _generateStrategicLetters(
        uniqueLetters, letterFrequency, extraLetterCount);
    uniqueLetters.addAll(extraLetters);

    // Convert to Letter objects, giving higher points to less frequent letters
    final letters = uniqueLetters.map((char) {
      final frequency = letterFrequency[char] ?? 1;
      final points = _calculateLetterPoints(frequency);
      return Letter(
        character: char,
        points: points,
      );
    }).toList();

    // Shuffle letters for random placement
    letters.shuffle();
    return letters;
  }

  int _calculateExtraLetters(int averageWordLength) {
    // Add more extra letters for longer words to increase difficulty
    if (averageWordLength <= 4) return 3; // Easy: few extra letters
    if (averageWordLength <= 6) return 5; // Medium: moderate extra letters
    return 7; // Hard: many extra letters
  }

  Set<String> _generateStrategicLetters(
      Set<String> existingLetters, Map<String, int> frequency, int count) {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    final extras = <String>{};

    // Common letter pairs to make game more challenging
    const commonPairs = {
      'A': ['E', 'I', 'O', 'U'],
      'E': ['A', 'I', 'Y'],
      'I': ['E', 'Y'],
      'O': ['A', 'E', 'U'],
      'U': ['E', 'O'],
      'T': ['D', 'G'],
      'N': ['M', 'G'],
      'R': ['L', 'N'],
      'S': ['Z', 'C'],
    };

    // First try to add confusing similar letters
    for (final letter in existingLetters) {
      if (extras.length >= count) break;
      if (commonPairs.containsKey(letter)) {
        for (final similar in commonPairs[letter]!) {
          if (!existingLetters.contains(similar) &&
              !extras.contains(similar) &&
              extras.length < count) {
            extras.add(similar);
          }
        }
      }
    }

    // Fill remaining slots with random letters
    while (extras.length < count) {
      final char = alphabet[random.nextInt(alphabet.length)];
      if (!existingLetters.contains(char) && !extras.contains(char)) {
        extras.add(char);
      }
    }

    return extras;
  }

  int _calculateLetterPoints(int frequency) {
    // Rarer letters are worth more points
    if (frequency == 1) return 3; // Unique letters
    if (frequency == 2) return 2; // Somewhat common letters
    return 1; // Common letters
  }
}
