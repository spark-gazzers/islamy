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
    ),
  );

  static ThemeData _adapt(ThemeData theme) => theme.copyWith(
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

  static ThemeData lightTheme = _adapt(_lightBase);
  static const Color _lightGreyBackgroundColor = Color(0xfff4f4f4);
  static Color greyBackgroundColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? _lightGreyBackgroundColor
          : _lightGreyBackgroundColor;
}
