import 'package:flutter/material.dart';
import 'package:track_fit/core/theme/app_palette.dart';

class AppTheme {
  static final darkThemeMode = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppPallete.backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPallete.backgroundColor,
        elevation: 0,
      ),
      chipTheme: const ChipThemeData(
        color: MaterialStatePropertyAll(AppPallete.backgroundColor),
        side: BorderSide.none,
      ));
}
