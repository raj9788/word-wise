import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const WordWiseApp());
}

class WordWiseApp extends StatelessWidget {
  const WordWiseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WordWise',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // fontFamily:
        //     'OpenDyslexic', // If you have this font, it helps with dyslexia
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
