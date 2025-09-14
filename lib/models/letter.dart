class Letter {
  final String character;
  final int points;
  bool isSelected;

  Letter({
    required this.character,
    this.points = 1,
    this.isSelected = false,
  });

  Letter copyWith({
    String? character,
    int? points,
    bool? isSelected,
  }) {
    return Letter(
      character: character ?? this.character,
      points: points ?? this.points,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  String toString() => character;
}
