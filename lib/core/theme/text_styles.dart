import 'package:flutter/material.dart';

import 'AppFonts.dart';
import 'color_palette.dart';


class AppTextStyles {

  static TextTheme  textTheme(bool isDark ) =>  TextTheme(

    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      fontFamily: AppFonts.primary,
      color: isDark ? Colors.white:  Colors.black,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      fontFamily: AppFonts.primary,
      color: isDark ? Colors.white:  Colors.black,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: AppFonts.primary,
      color: isDark ? Colors.white:  Colors.black,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontFamily: AppFonts.primary,
      color: isDark ? Colors.white:  Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontFamily: AppFonts.primary,
      color: isDark ? Colors.white:  Colors.black,
    ),
  );
}
