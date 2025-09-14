import 'letter.dart';

class Word {
  final List<Letter> letters;
  final String definition;
  final bool isValid;

  Word({
    required this.letters,
    this.definition = '',
    this.isValid = false,
  });

  String get word => letters.map((l) => l.character).join();
  int get points => letters.fold(0, (sum, letter) => sum + letter.points);

  Word copyWith({
    List<Letter>? letters,
    String? definition,
    bool? isValid,
  }) {
    return Word(
      letters: letters ?? this.letters,
      definition: definition ?? this.definition,
      isValid: isValid ?? this.isValid,
    );
  }

  factory Word.fromLetters(List<Letter> letters) {
    return Word(
      letters: letters,
      definition: '', // Could be fetched from a dictionary API
      isValid: false, // Could be validated against a word list
    );
  }

  @override
  String toString() => word;
}
