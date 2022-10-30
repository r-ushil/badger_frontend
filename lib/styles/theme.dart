import 'package:flutter/material.dart';

ThemeData getThemeData() {
  return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black,
          secondary: Colors.grey,
          background: Colors.black,
          tertiary: Colors.blueAccent),
      scaffoldBackgroundColor: Colors.black,
      fontFamily: "Segoe UI",
      textTheme: getTextTheme());
}

TextTheme getTextTheme() {
  return const TextTheme(
    displayLarge: TextStyle(
        fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 36.0, color: Colors.white),
  );
}
