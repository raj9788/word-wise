import 'package:flutter/material.dart';
import '../models/letter.dart';
import '../models/word.dart';
import '../models/game_state.dart';
import '../models/game_difficulty.dart';
import '../services/tts_service.dart';
import '../services/word_generator_service.dart';
import '../widgets/letter_wheel.dart';
import '../widgets/word_display.dart';

class GameScreen extends StatefulWidget {
  final GameDifficulty difficulty;

  const GameScreen({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TTSService tts = TTSService();
  final WordGeneratorService wordGenerator = WordGeneratorService();

  late GameState gameState;
  late List<Letter> letters;
  late Word currentWord;
  late List<String> targetWords;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    // Generate words based on difficulty
    targetWords = wordGenerator.generateWords(widget.difficulty);
    print('Target Words: $targetWords');
    // Generate letters from the target words
    letters = wordGenerator.generateLettersFromWords(targetWords);

    // Initialize game state
    gameState = GameState(
      difficulty: widget.difficulty,
      targetWords: targetWords,
      discoveredWords: [],
      availableLetters: letters,
    );

    // Initialize current word
    currentWord = Word(letters: []);
  }

  void onLetterSelected(Letter letter) {
    setState(() {
      if (!letter.isSelected) {
        letter.isSelected = true;
        final newWord = Word(
          letters: [...currentWord.letters, letter],
        );

        // Check if the word is valid and can be discovered
        final wordStr = newWord.word.toUpperCase();
        if (gameState.checkWord(wordStr)) {
          // Word discovered!
          gameState = gameState.copyWith(
              discoveredWords: [...gameState.discoveredWords, wordStr]);
          // Speak the discovered word
          tts.speak("Word found: $wordStr");
          // Clear the selection after a brief delay
          Future.delayed(const Duration(milliseconds: 500), clearWord);
        } else {
          currentWord = newWord;
        }
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

  Future<void> _showHintDialog(String word) async {
    final hint = wordGenerator.getWordHint(word);
    if (hint == null) return;

    final hintLevel = gameState.hintLevels[word] ?? 0;
    final isLastHint = hintLevel >= 1;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Word Hint'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hintLevel > 0) ...[
                Text(
                  gameState.getHiddenWord(word),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(hint),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            if (!isLastHint)
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    gameState = gameState.copyWith(
                      hintLevels: {
                        ...gameState.hintLevels,
                        word: (gameState.hintLevels[word] ?? 0) + 1,
                      },
                    );
                  });
                  tts.speak(hint);
                  Navigator.of(context).pop();
                },
                child: Text(hintLevel == 0 ? 'Show Letters' : 'Reveal Word'),
              ),
          ],
        );
      },
    );
  }

  Future<void> _showGiveUpDialog() async {
    final undiscoveredWords = targetWords
        .where((word) => !gameState.discoveredWords.contains(word))
        .toList();

    final percentComplete =
        (gameState.discoveredWords.length / targetWords.length * 100).round();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'You found $percentComplete% of the words!',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Here are the words you missed:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...undiscoveredWords
                  .map((word) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              '• $word',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.red,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.volume_up),
                              onPressed: () => tts.speak(word),
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ))
                  .toList(),
              const SizedBox(height: 16),
              Text(
                percentComplete >= 70
                    ? 'Great effort! You were so close!'
                    : percentComplete >= 40
                        ? 'Not bad! Keep practicing to improve!'
                        : 'Don\'t give up! You can do better!',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Return to home screen
              },
              child: const Text('Quit Game'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  initializeGame(); // Start a new game
                });
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWordList() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: targetWords.length,
        itemBuilder: (context, index) {
          final word = targetWords[index];
          final isDiscovered = gameState.discoveredWords.contains(word);
          return Card(
            color: isDiscovered ? Colors.green.shade100 : Colors.white,
            child: InkWell(
              onLongPress: !isDiscovered ? () => _showHintDialog(word) : null,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        gameState.getHiddenWord(word),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDiscovered
                              ? Colors.green
                              : Colors.blue.shade700,
                        ),
                      ),
                      if (!isDiscovered &&
                          (gameState.hintLevels[word] ?? 0) > 0)
                        const Icon(
                          Icons.lightbulb,
                          color: Colors.amber,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade300, Colors.blue.shade600],
          ),
        ),
        child: SafeArea(
          child: Column(
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
                      'Score: ${gameState.discoveredWords.length}/${gameState.targetWords.length}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.flag, color: Colors.white),
                      label: const Text(
                        'Give Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _showGiveUpDialog,
                    ),
                  ],
                ),
              ),
              _buildWordList(),
              const Spacer(),
              WordDisplay(
                currentWord: currentWord,
                tts: tts,
                onClear: clearWord,
              ),
              const SizedBox(height: 20),
              LetterWheel(
                letters: letters,
                onLetterSelected: onLetterSelected,
                tts: tts,
              ),
              // const SizedBox(height: 40),
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
