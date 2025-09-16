import 'letter.dart';
import 'game_difficulty.dart';

class GameState {
  final GameDifficulty difficulty;
  final List<String> targetWords;
  final List<String> discoveredWords;
  final List<Letter> availableLetters;
  final Map<String, int>
      hintLevels; // 0 = no hint, 1 = partial reveal, 2 = full hint
  final int score;

  GameState({
    required this.difficulty,
    required this.targetWords,
    required this.discoveredWords,
    required this.availableLetters,
    Map<String, int>? hintLevels,
    this.score = 0,
  }) : this.hintLevels = hintLevels ?? {};

  bool get isCompleted => discoveredWords.length == targetWords.length;

  double get progressPercentage => targetWords.isEmpty
      ? 0
      : (discoveredWords.length / targetWords.length) * 100;

  GameState copyWith({
    GameDifficulty? difficulty,
    List<String>? targetWords,
    List<String>? discoveredWords,
    List<Letter>? availableLetters,
    Map<String, int>? hintLevels,
    int? score,
  }) {
    return GameState(
      difficulty: difficulty ?? this.difficulty,
      targetWords: targetWords ?? this.targetWords,
      discoveredWords: discoveredWords ?? this.discoveredWords,
      availableLetters: availableLetters ?? this.availableLetters,
      hintLevels: hintLevels ?? this.hintLevels,
      score: score ?? this.score,
    );
  }

  String getHiddenWord(String word) {
    if (discoveredWords.contains(word)) {
      return word;
    }

    final hintLevel = hintLevels[word] ?? 0;
    if (hintLevel == 0) {
      return '*' * word.length;
    } else if (hintLevel == 1) {
      // Show first letter, last letter, and one middle letter
      final chars = List.filled(word.length, '*');
      chars[0] = word[0]; // First letter
      chars[word.length - 1] = word[word.length - 1]; // Last letter
      if (word.length > 3) {
        chars[word.length ~/ 2] = word[word.length ~/ 2]; // Middle letter
      }
      return chars.join();
    }
    return word; // Full reveal for hint level 2
  }

  bool checkWord(String word) {
    // Convert input word to uppercase for comparison
    final upperWord = word.toUpperCase();
    if (targetWords.contains(upperWord) &&
        !discoveredWords.contains(upperWord)) {
      return true;
    }
    return false;
  }
}
