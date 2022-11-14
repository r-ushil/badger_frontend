import 'package:flutter/material.dart';

ThemeData getThemeData() {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0x00bb86fc),
      secondary: const Color(0x0003dac6),
      background: Colors.black,
      tertiary: Colors.blueAccent,
    ),
    scaffoldBackgroundColor: const Color(0x00121212),
    fontFamily: "Segoe UI",
    textTheme: getTextTheme(),
    inputDecorationTheme: getInputDecorationTheme(),
  );
}

InputDecorationTheme getInputDecorationTheme() {
  return const InputDecorationTheme(
    labelStyle: TextStyle(fontSize: 18.0, color: Colors.white),
    prefixStyle: TextStyle(fontSize: 18.0, color: Colors.white),
  );
}

TextTheme getTextTheme() {
  return const TextTheme(
    displayLarge: TextStyle(
        fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 36.0, color: Colors.white),
  );
}
