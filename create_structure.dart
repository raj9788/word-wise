import 'dart:io';

void main() {
  final basePath = Directory.current.path;

  final structure = {
    'lib/': [
      'main.dart',
      'models/letter.dart',
      'models/word.dart',
      'services/tts_service.dart',
      'widgets/letter_circle.dart',
      'widgets/word_display.dart',
      'widgets/letter_wheel.dart',
      'screens/home_screen.dart',
      'screens/game_screen.dart',
    ],
    'assets/': [] // You can add files later here
  };

  final pubspecPath = '$basePath/pubspec.yaml';

  print('📁 Creating project structure...\n');

  structure.forEach((folder, files) {
    final folderPath = '$basePath/word_wise/$folder';
    Directory(folderPath).createSync(recursive: true);
    print('✅ Created folder: $folderPath');

    for (final file in files) {
      final filePath = '$folderPath$file';
      final fileObj = File(filePath);
      if (!fileObj.existsSync()) {
        fileObj.createSync(recursive: true);
        fileObj.writeAsStringSync(_generatePlaceholder(file));
        print('  📄 Created file: $filePath');
      }
    }
  });

  // Create pubspec.yaml if it doesn't exist
  final pubspecFile = File(pubspecPath);
  if (!pubspecFile.existsSync()) {
    pubspecFile.writeAsStringSync(_pubspecTemplate());
    print('\n📄 Created pubspec.yaml');
  }

  print('\n✅ All done! Your basic project structure is ready.');
}

String _generatePlaceholder(String fileName) {
  final baseName = fileName.split('/').last;
  return '''
// $baseName
// TODO: Implement $baseName

''';
}

String _pubspecTemplate() {
  return '''
name: word_wise
description: A word game for children with dyslexia
version: 1.0.0+1

environment:
  sdk: ">=2.18.0 <3.0.0"

dependencies:
  flutter:
    sdk: flutter
  flutter_tts: ^4.2.3
  provider: ^6.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - assets/
''';
}
