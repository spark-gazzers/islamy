import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Utility to create and fix on-the-fly the [ThemeData]s of the app.
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
      tertiaryContainer: const Color(0xffFEAA00),
      onTertiaryContainer: Colors.white,
    ),
  );

  static ThemeData _adapt(ThemeData theme) => theme.copyWith(
        cupertinoOverrideTheme: _toCupertino(theme),
        platform: TargetPlatform.iOS,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
            TargetPlatform.values,
            value: (_) => const CupertinoPageTransitionsBuilder(),
          ),
        ),
        textTheme: theme.textTheme.copyWith(
          bodyText2: theme.textTheme.bodyText2?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: const Color(0xff778790),
          ),
          subtitle1: theme.textTheme.subtitle1?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            minimumSize: const Size(double.infinity, 60),
            padding: EdgeInsets.zero,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            elevation: 10,
            shadowColor: theme.primaryColor.withAlpha(100),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(
              color: Color(0xffDFE0E5),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(
              color: Color(0xffDFE0E5),
            ),
          ),
        ),
      );

  static CupertinoThemeData _toCupertino(ThemeData theme) {
    final CupertinoThemeData data =
        MaterialBasedCupertinoThemeData(materialTheme: theme);
    return data.copyWith(
      primaryColor: theme.primaryColor,
      barBackgroundColor: theme.primaryColor,
      scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
      primaryContrastingColor: Colors.white,
      textTheme: data.textTheme.copyWith(
        primaryColor: theme.primaryColor,
        navTitleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        navActionTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white70,
        ),
      ),
    );
  }

  /// The app light theme.
  static ThemeData get lightTheme => _adapt(_lightBase);
}
