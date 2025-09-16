import 'dart:math';
import '../models/letter.dart';
import '../models/game_difficulty.dart';

class WordGeneratorService {
  // Sample word list - in a real app, this would come from a larger dictionary
  static const Map<String, String> _wordHints = {
    'WORD': 'A group of letters that has meaning',
    'PLAY': 'To have fun or engage in activities',
    'GAME': 'An activity with rules that people enjoy',
    'MIND': 'Where thoughts and memories live',
    'LEAF': 'A green part of a tree that falls in autumn',
    'SONG': 'Music with words that people sing',
    'RAIN': 'Water that falls from clouds',
    'BLUE': 'The color of the sky on a clear day',
    'HOPE': 'A feeling of wanting something good to happen',
    'DREAM': 'Stories in your mind while sleeping',
    'LIGHT': 'Makes things bright and helps us see',
    'DANCE': 'Moving your body to music',
    'SPACE': 'The vast area beyond Earth\'s atmosphere',
    'WONDER': 'To feel curious or amazed about something',
    'BRIGHT': 'Full of light or very intelligent',
    'PLANET': 'A large round object that orbits the sun',
    'FLOWER': 'A colorful plant that smells nice',
    'WISDOM': 'Knowledge gained from experience',
    'TEMPLE': 'A place of worship or sacred building',
    'SILENT': 'Making no sound or noise',
    'COFFEE': 'A hot drink that wakes you up',
    'GARDEN': 'A place where plants and flowers grow',
    'PURPLE': 'A color between red and blue',
    'ELEPHANT': 'A large gray animal with a long trunk',
    'MOUNTAIN': 'A very high hill reaching into the sky',
    'SUNSHINE': 'Bright light from the sun',
    'BUTTERFLY': 'A beautiful insect with colorful wings',
    'PRECIOUS': 'Very valuable or important',
    'MOONLIGHT': 'Light that comes from the moon at night',
    'SYMPHONY': 'A long piece of music for orchestra',
    'UNIVERSE': 'All of space and everything in it',
    'BRILLIANT': 'Extremely clever or very bright',
    'DISCOVERY': 'Finding something new',
    'HAPPINESS': 'The feeling of being happy',
    // --- New Words and Hints Below ---

    // 4-5 Letter Words
    'OPEN': 'Not closed or covered; available',
    'STAR': 'A luminous ball of gas in the night sky',
    'TIME': 'The indefinite continued progress of existence',
    'BOOK': 'A set of printed pages bound together',
    'FIRE': 'Combustion or burning, producing light and heat',
    'HOME': 'The place where one lives permanently',
    'RIVER': 'A large natural stream of water flowing to the sea',
    'WIND': 'The perceptible natural movement of air',
    'CLOUD': 'A visible mass of water droplets in the air',
    'GRASS': 'Common green plant with thin leaves',
    'SMART': 'Having or showing quick intelligence',
    'CANDY': 'A sweet food made with sugar',
    'HAPPY': 'Feeling or showing pleasure or contentment',
    'QUIET': 'Making little or no noise',
    'EAGLE': 'A large bird of prey with a hooked beak',
    'FIGHT': 'A violent confrontation or struggle',
    'PEACE': 'Freedom from disturbance; tranquility',
    'TRUTH': 'The quality or state of being true',
    'BRAVE': 'Ready to face danger or pain',
    'FRESH': 'Newly made or obtained; not stale',
    'SWEET': 'Having the pleasant taste of sugar',
    'LUCKY': 'Having good things happen by chance',
    'STORY': 'An account of imaginary or real people and events',
    'BRISK': 'Active, fast, and energetic',
    'CHAIR': 'A separate seat for one person',
    'TABLE': 'A piece of furniture with a flat top',
    'HEART': 'The organ that pumps blood',
    'RHYTHM': 'A strong, regular, repeated pattern of movement or sound',
    'MAGIC': 'The power of apparently influencing events by supernatural means',
    'SMILE': 'A facial expression indicating pleasure',

    // 6-7 Letter Words
    'OCEAN': 'A very large expanse of sea',
    'SECRET': 'Not known or seen by others',
    'FREEDOM': 'The power or right to act, speak, or think as one wants',
    'JOURNEY': 'An act of traveling from one place to another',
    'HARMONY': 'Agreement or concord',
    'SERENE': 'Calm, peaceful, and untroubled',
    'MYSTERY': 'Something that is difficult or impossible to understand',
    'GLOWING': 'Emitting a steady light without flame',
    'DAZZLE': 'To impress someone deeply',
    'WHISPER': 'To speak very softly using one\'s breath',
    'REFLECT': 'To throw back light, heat, or sound',
    'ELEGANT': 'Graceful and stylish in appearance or manner',
    'GENIUS': 'Exceptional intellectual or creative power',
    'TREASURE':
        'A quantity of precious metals, gems, or other valuable objects',
    'TWINKLE': 'Shine with a rapidly changing light',
    'ENIGMA': 'A person or thing that is mysterious',
    'SPECTRA': 'A band of colors, as produced by light',
    'AURORA': 'A natural electrical phenomenon in the sky',
    'CASCADE':
        'A small waterfall, typically one of several that fall in stages down a steep rocky slope.',
    'GLEAMING': 'Shining brightly, especially with reflected light.',

    // 8-10 Letter Words
    'ADVENTURE': 'An exciting or daring experience',
    'BEAUTIFUL': 'Pleasing to the senses or mind aesthetically',
    'CREATIVE': 'Relating to or involving the use of the imagination',
    'DELICIOUS': 'Highly pleasant to the taste',
    'FANTASTIC': 'Extraordinarily good or attractive',
    'GRATEFUL': 'Feeling or showing appreciation for something received',
    'ILLUSION': 'A deceptive appearance or impression',
    'JOYFULLY': 'In a way that expresses joy',
    'KINDNESS': 'The quality of being friendly, generous, and considerate',
    'LUMINIOUS': 'Emitting or reflecting light; shining',
    'MAGNIFICENT': 'Impressively beautiful, elaborate, or extravagant',
    'NOSTALGIA': 'A sentimental longing or wistful affection for the past',
    'OPTIMISTIC': 'Hopeful and confident about the future',
    'PARADISE': 'An ideal or idyllic place',
    'QUESTING': 'Searching for something',
    'RADIANT': 'Sending out light; shining or glowing brightly',
    'SERENDIPITY':
        'The occurrence and development of events by chance in a happy or beneficial way',
    'TRANQUIL': 'Free from disturbance; calm',
    'UNIQUE': 'Being the only one of its kind',
    'VIBRANT': 'Full of energy and enthusiasm',
    'WHIMSICAL': 'Playfully quaint or fanciful',
    'ZENITH': 'The point in the sky directly above an observer',
    'EXCELLENT': 'Extremely good; outstanding',
    'FASCINATE': 'To draw the exclusive attention of; enthrall',
    'EFFERVESCE': 'To emit bubbles of gas; to be vivacious and enthusiastic.',
    'GLISTENING': 'Shining with a sparkling light.',
    'HOSPITALITY': 'The friendly reception and entertainment of guests.',
    'INGENIOUS': 'Clever, original, and inventive.',
    'JUBILATION': 'A feeling of great happiness and triumph.',
    'KALEIDOSCOPE': 'A constantly changing pattern or sequence of elements.',
    'MAJESTIC': 'Having or showing impressive beauty or scale.',
    'NURTURING':
        'Caring for and encouraging the growth or development of someone or something.',
    'PICTURESQUE':
        'Visually attractive, especially in a quaint or pretty style.',
    'RESPLENDENT': 'Shining brilliantly; very showy.',
    'STUPENDOUS': 'Extremely impressive.',
    'TENACIOUS': 'Holding fast; characterized by keeping a firm hold.',
    'UBIQUITOUS': 'Present, appearing, or found everywhere.',
    'VIVACIOUS':
        'Attractively lively and animated (typically used of a woman).',
    'WONDERFUL':
        'Inspiring delight, pleasure, or admiration; extremely good; marvelous.'
  };

  static const List<String> _wordList = [
    // 4-5 letter words
    'word', 'play', 'game', 'mind', 'leaf', 'song', 'rain', 'blue',
    'hope', 'dream', 'light', 'dance', 'space', 'open', 'star',
    'time', 'book', 'fire', 'home', 'river', 'wind', 'cloud', 'grass',
    'smart', 'candy', 'happy', 'quiet', 'eagle', 'fight', 'peace',
    'truth', 'brave', 'fresh', 'sweet', 'lucky', 'story', 'brisk',
    'chair', 'table', 'heart', 'rhythm', 'magic', 'smile',

    // 6-7 letter words
    'wonder', 'bright', 'planet', 'flower', 'wisdom', 'temple',
    'silent', 'coffee', 'garden', 'purple', 'ocean', 'secret',
    'freedom', 'journey', 'harmony', 'serene', 'mystery', 'glowing',
    'dazzle', 'whisper', 'cascade', 'reflect', 'elegant', 'genius',
    'treasure', 'twinkle', 'enigma', 'spectra', 'aurora', 'gleaming',

    // 8-10+ letter words
    'elephant', 'mountain', 'sunshine', 'butterfly', 'precious',
    'moonlight', 'symphony', 'universe', 'adventure', 'brilliant',
    'wonderful', 'discovery', 'happiness', 'beautiful', 'creative',
    'delicious', 'fantastic', 'grateful', 'illusion', 'joyfully',
    'kindness', 'luminious', 'magnificent', 'nostalgia', 'optimistic',
    'paradise', 'questing', 'radiant', 'serendipity', 'tranquil',
    'unique', 'vibrant', 'whimsical', 'zenith', 'excellent',
    'fascinate', 'effervesce', 'glistening', 'hospitality', 'ingenious',
    'jubilation', 'kaleidoscope', 'majestic', 'nurturing', 'picturesque',
    'resplendent', 'stupendous', 'tenacious', 'ubiquitous', 'vivacious',
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

  String? getWordHint(String word) {
    return _wordHints[word.toUpperCase()];
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
