import 'letter.dart';
import 'game_difficulty.dart';

class GameState {
  final GameDifficulty difficulty;
  final List<String> targetWords;
  final List<String> discoveredWords;
  final List<Letter> availableLetters;
  final int score;

  GameState({
    required this.difficulty,
    required this.targetWords,
    required this.discoveredWords,
    required this.availableLetters,
    this.score = 0,
  });

  bool get isCompleted => discoveredWords.length == targetWords.length;

  double get progressPercentage => targetWords.isEmpty
      ? 0
      : (discoveredWords.length / targetWords.length) * 100;

  String getHiddenWord(String word) {
    return discoveredWords.contains(word) ? word : '*' * word.length;
  }

  GameState copyWith({
    GameDifficulty? difficulty,
    List<String>? targetWords,
    List<String>? discoveredWords,
    List<Letter>? availableLetters,
    int? score,
  }) {
    return GameState(
      difficulty: difficulty ?? this.difficulty,
      targetWords: targetWords ?? this.targetWords,
      discoveredWords: discoveredWords ?? this.discoveredWords,
      availableLetters: availableLetters ?? this.availableLetters,
      score: score ?? this.score,
    );
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
