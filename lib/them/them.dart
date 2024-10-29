import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.grey.withOpacity(0.8),
  cardColor: Colors.grey,
  appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade400),
  bottomAppBarTheme: BottomAppBarTheme(
    color: Colors.grey.shade400,
    shadowColor: Colors.grey[600],
  ),
  scaffoldBackgroundColor: Colors.grey[300],
  colorScheme: ColorScheme.light(
    primary: Colors.grey[400]!,
    secondary: Colors.black,
    surface: Colors.grey.shade200,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey.withOpacity(0.3),
  cardColor: Colors.amber.withOpacity(0.6),
  appBarTheme: AppBarTheme(backgroundColor: Colors.black.withOpacity(0.1)),
  bottomAppBarTheme: BottomAppBarTheme(
    color: Colors.black.withOpacity(0.1),
    shadowColor: Colors.grey[800],
  ),
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.dark(
    primary: Colors.grey[600]!,
    secondary: Colors.amber.withOpacity(0.6),
    surface: Colors.grey.shade800,
    onPrimary: Colors.black,
    onSecondary: Colors.white.withOpacity(0.6),
    onSurface: Colors.white,
  ),
);
