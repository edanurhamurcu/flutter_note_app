import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.amber,
    primaryColor: Colors.amber,
    brightness: Brightness.light,
    dividerColor: Colors.grey[300],
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.black),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.amber,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.grey,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: InputBorder.none,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.amber),
      trackColor: WidgetStateProperty.all(Colors.amber[200]),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 4,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.amber,
    primaryColor: Colors.amber,
    brightness: Brightness.dark,
    dividerColor: Colors.grey[800],
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black26,
      elevation: 0,
      titleTextStyle: TextStyle(color: Colors.white),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.amber,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.grey,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(Colors.amber),
      trackColor: WidgetStateProperty.all(Colors.amber[700]),
    ),
    cardTheme: CardTheme(
      color: Colors.black38,
      elevation: 4,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      focusColor: Colors.amber,
      hoverColor: Colors.red,
      fillColor: Colors.green,
      border: InputBorder.none,
    ),
  );

  static ThemeData setDarkTheme(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }

  static ThemeData setLightTheme(bool isDarkMode) {
    return isDarkMode ? lightTheme : darkTheme;
  }
}
