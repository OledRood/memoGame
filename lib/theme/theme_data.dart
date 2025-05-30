import 'package:flutter/material.dart';

class AppTheme {
  static const String primaryFontFamily = 'noir-pro-semi-bold-italic';

  static ThemeData get lightTheme => ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: const TextTheme(
            bodyLarge: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: primaryFontFamily),
            labelLarge: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: primaryFontFamily,
              fontWeight: FontWeight.w400, //Q1/10
            )),
        textButtonTheme: TextButtonThemeData(style: ButtonStyle(backgroundColor:
            WidgetStateProperty.resolveWith((Set<WidgetState> state) {
          if (state.contains(WidgetState.pressed)) {
            return Colors.deepPurple;
          }
          return Colors.white;
        }))),

        // ========== Кнопки ==========
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            textStyle: ThemeData.light().textTheme.labelLarge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
}
