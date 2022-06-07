import 'package:flutter/material.dart';

// pages
import 'package:flutter_dota2_web/screens/player/player-main.dart';

ThemeData _customTheme() {
  return ThemeData(
    primaryColor: const Color.fromRGBO(245, 245, 245, .87),
    scaffoldBackgroundColor: const Color.fromRGBO(25, 32, 35, 1),
    backgroundColor: const Color.fromRGBO(14, 84, 113, 1),
    cardColor: const Color(0xFF883B2D),
    textSelectionTheme: const TextSelectionThemeData(
    selectionColor: Color(0xFFFEDBD0),
    ),
    errorColor: Colors.red,
    buttonTheme: ThemeData.light().buttonTheme.copyWith(
    buttonColor: const Color(0xFFFEDBD0),
    colorScheme: ThemeData.light().colorScheme.copyWith(
      secondary: const Color.fromRGBO(14, 84, 113, 0.37),
      ),
    ),
    buttonBarTheme: ThemeData.light().buttonBarTheme.copyWith(
    buttonTextTheme: ButtonTextTheme.accent,
    ),
    primaryIconTheme: ThemeData.light().primaryIconTheme.copyWith(
    color: const Color.fromRGBO(245, 245, 245, .87),
    ),
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love Dota2',
      theme: _customTheme(),
      home: const PlayerMain(),
    );
  }
}
