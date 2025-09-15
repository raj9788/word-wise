import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../models/letter.dart';
import '../services/tts_service.dart';
import 'letter_circle.dart';

class LinePainter extends CustomPainter {
  final List<Letter> selectedLetters;
  final Function(Letter) getLetterPosition;
  final Offset? currentPointer;

  LinePainter({
    required this.selectedLetters,
    required this.getLetterPosition,
    this.currentPointer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedLetters.isEmpty) return;

    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    var start = getLetterPosition(selectedLetters.first);
    path.moveTo(start.dx, start.dy);

    // Draw lines between selected letters
    for (var i = 1; i < selectedLetters.length; i++) {
      final end = getLetterPosition(selectedLetters[i]);
      path.lineTo(end.dx, end.dy);
    }

    // Draw line to current pointer position if selecting
    if (currentPointer != null && selectedLetters.isNotEmpty) {
      final lastLetter = selectedLetters.last;
      final lastPos = getLetterPosition(lastLetter);
      final linePath = Path()
        ..moveTo(lastPos.dx, lastPos.dy)
        ..lineTo(currentPointer!.dx, currentPointer!.dy);

      canvas.drawPath(linePath, paint..color = Colors.white.withOpacity(0.3));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return true;
  }
}

class LetterWheel extends StatefulWidget {
  final List<Letter> letters;
  final Function(Letter) onLetterSelected;
  final TTSService tts;

  const LetterWheel({
    Key? key,
    required this.letters,
    required this.onLetterSelected,
    required this.tts,
  }) : super(key: key);

  static List<Letter> shuffleLetters(List<Letter> letters) {
    final List<Letter> shuffled = List.from(letters);
    final random = Random();
    for (var i = shuffled.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }
    return shuffled;
  }

  @override
  State<LetterWheel> createState() => _LetterWheelState();
}

class _LetterWheelState extends State<LetterWheel> {
  Letter? _startLetter;
  Letter? _currentLetter;
  final List<Letter> _selectedLetters = [];
  final GlobalKey _wheelKey = GlobalKey();
  bool _isSelecting = false;
  Offset? _currentPointer;

  String _getCurrentWord() {
    return _selectedLetters.map((l) => l.character).join();
  }

  void _handlePointerDown(Offset globalPosition, PointerDeviceKind kind) {
    final RenderBox box =
        _wheelKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(globalPosition);
    _startLetter = _findNearestLetter(localPosition);

    if (_startLetter != null) {
      _isSelecting = true;
      setState(() {
        _selectedLetters.clear();
        _selectedLetters.add(_startLetter!);
        widget.onLetterSelected(_startLetter!);
        widget.tts
            .speakLetterInWord(_startLetter!.character, _getCurrentWord());
      });
    }
  }

  void _handlePointerMove(Offset globalPosition, PointerDeviceKind kind) {
    if (!_isSelecting) return;

    final RenderBox box =
        _wheelKey.currentContext!.findRenderObject() as RenderBox;
    final localPosition = box.globalToLocal(globalPosition);
    final nearestLetter = _findNearestLetter(localPosition);

    setState(() {
      _currentPointer = localPosition;

      if (nearestLetter != null && nearestLetter != _currentLetter) {
        _currentLetter = nearestLetter;
        if (!_selectedLetters.contains(nearestLetter)) {
          _selectedLetters.add(nearestLetter);
          widget.onLetterSelected(nearestLetter);
          widget.tts
              .speakLetterInWord(nearestLetter.character, _getCurrentWord());
        }
      }
    });
  }

  void _handlePointerUp() {
    if (!_isSelecting) return;

    setState(() {
      _isSelecting = false;
      _startLetter = null;
      _currentLetter = null;
      _currentPointer = null;

      // If we have a valid word, speak it
      final word = _getCurrentWord();
      if (word.length >= 3) {
        widget.tts.speakWord(word);
      }
    });
  }

  Letter? _findNearestLetter(Offset position) {
    const wheelSize = 450.0;
    const radius = 160.0;
    const centerOffset = wheelSize / 2;

    Letter? nearest;
    double minDistance = double.infinity;

    for (var letter in widget.letters) {
      final angle =
          (2 * pi * widget.letters.indexOf(letter)) / widget.letters.length;
      final letterX = centerOffset + radius * cos(angle);
      final letterY = centerOffset + radius * sin(angle);

      final distance = (position - Offset(letterX, letterY)).distance;
      if (distance < minDistance && distance < 45) {
        minDistance = distance;
        nearest = letter;
      }
    }
    return nearest;
  }

  Offset _getLetterPosition(Letter letter) {
    const wheelSize = 450.0;
    const radius = 160.0;
    const centerOffset = wheelSize / 2;

    final index = widget.letters.indexOf(letter);
    final angle = (2 * pi * index) / widget.letters.length;
    return Offset(
      centerOffset + radius * cos(angle),
      centerOffset + radius * sin(angle),
    );
  }

  @override
  Widget build(BuildContext context) {
    const wheelSize = 450.0;
    const radius = 160.0;
    const centerOffset = wheelSize / 2;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Listener(
        onPointerDown: (event) =>
            _handlePointerDown(event.position, event.kind),
        onPointerMove: (event) =>
            _handlePointerMove(event.position, event.kind),
        onPointerUp: (event) => _handlePointerUp(),
        child: SizedBox(
          key: _wheelKey,
          width: wheelSize,
          height: wheelSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isSelecting && _selectedLetters.isNotEmpty)
                CustomPaint(
                  size: const Size(wheelSize, wheelSize),
                  painter: LinePainter(
                    selectedLetters: _selectedLetters,
                    getLetterPosition: _getLetterPosition,
                    currentPointer: _currentPointer,
                  ),
                ),
              ...List.generate(widget.letters.length, (index) {
                final angle = (2 * pi * index) / widget.letters.length;
                return Positioned(
                  left: centerOffset + radius * cos(angle) - 30,
                  top: centerOffset + radius * sin(angle) - 30,
                  child: LetterCircle(
                    letter: widget.letters[index],
                    onTap: () {
                      setState(() {
                        _selectedLetters.clear();
                        _selectedLetters.add(widget.letters[index]);
                      });
                      widget.onLetterSelected(widget.letters[index]);
                      widget.tts.speakLetterInWord(
                          widget.letters[index].character, _getCurrentWord());
                    },
                    tts: widget.tts,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
