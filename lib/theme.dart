import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeBuilder {
  const ThemeBuilder._();
  static final ThemeData _lightBase = ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xff37B898),
      primary: const Color(0xff37B898),
      background: Colors.white,
      error: const Color(0xffFF0000),
      brightness: Brightness.light,
      surface: Colors.white,
      surfaceVariant: const Color(0xfff4f4f4),
    ),
  );

  static ThemeData _adapt(ThemeData theme) => theme.copyWith(
        textTheme: theme.textTheme.copyWith(
          bodyText2: theme.textTheme.bodyText2?.copyWith(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: const Color(0xff778790),
          ),
          subtitle1: theme.textTheme.subtitle1?.copyWith(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            minimumSize: const Size(double.infinity, 60),
            padding: EdgeInsets.zero,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            elevation: 10.0,
            shadowColor: theme.primaryColor.withAlpha(100),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide(
              color: Color(0xffDFE0E5),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide(
              color: Color(0xffDFE0E5),
            ),
          ),
        ),
      );

  static CupertinoThemeData toCupertino(ThemeData theme) {
    CupertinoThemeData data =
        MaterialBasedCupertinoThemeData(materialTheme: theme);
    return data.copyWith(
      barBackgroundColor: theme.primaryColor,
      scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
      textTheme: data.textTheme.copyWith(
        navTitleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        navActionTextStyle: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.white70,
        ),
      ),
    );
  }

  static ThemeData get lightTheme => _adapt(_lightBase);
}
