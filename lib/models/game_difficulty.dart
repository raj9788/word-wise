enum GameDifficulty {
  easy(
    minWordLength: 4,
    maxWordLength: 5,
    totalWords: 6,
    label: 'Easy',
  ),
  challenging(
    minWordLength: 5,
    maxWordLength: 6,
    totalWords: 8,
    label: 'Challenging',
  ),
  limitBreaker(
    minWordLength: 7,
    maxWordLength: 9,
    totalWords: 10,
    label: 'Limit Breaker',
  );

  final int minWordLength;
  final int maxWordLength;
  final int totalWords;
  final String label;

  const GameDifficulty({
    required this.minWordLength,
    required this.maxWordLength,
    required this.totalWords,
    required this.label,
  });
}
