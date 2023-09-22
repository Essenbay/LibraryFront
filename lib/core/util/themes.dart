import 'package:flutter/material.dart';
import 'package:libraryfront/core/util/colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        background: AppColors.white,
        primary: AppColors.primaryLight3,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.black,
      ));
}
