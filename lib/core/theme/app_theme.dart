
import 'package:dev/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

import 'color_palette.dart';

class AppTheme {

  static ThemeData get light => ThemeData(

    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    textTheme: AppTextStyles.textTheme(false),
    appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.black,
  )
  ) ;

  static ThemeData get dark => ThemeData(

    colorScheme: ColorScheme.fromSeed(seedColor:Colors.white,
      brightness: Brightness.dark,),
    useMaterial3: true,
    textTheme: AppTextStyles.textTheme(true),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
    ),

  );


}
