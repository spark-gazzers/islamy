import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/theme.dart';
import 'package:islamy/utils/helper.dart';

class AyahSpan extends TextSpan {
  AyahSpan({
    required Ayah ayah,
    VoidCallback? onTap,
    VoidCallback? onLongTap,
    bool isSelected = false,
  }) : super(
          children: <InlineSpan>[
            ...AyahTajweedSplitter.formatAyah(ayah),
            TextSpan(
              recognizer: MultiTapGestureRecognizer(
                longTapDelay: const Duration(milliseconds: 300),
              )
                ..onLongTapDown = (int pointer, TapDownDetails details) {
                  if (onLongTap != null) {
                    HapticFeedback.heavyImpact();
                    onLongTap();
                  }
                }
                ..onTap = (_) => onTap?.call(),
              style: TextStyle(
                background: Paint()
                  ..color = isSelected
                      ? ThemeBuilder.lightTheme.colorScheme.tertiaryContainer
                      : Colors.transparent,
                decoration:
                    isSelected ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
            AyahsNumberSpan(ayah: ayah),
          ],
        );
}

class AyahsNumberSpan extends TextSpan {
  AyahsNumberSpan({
    required Ayah ayah,
  }) : super(
          text: Helper.localization
              .getVerseEndSymbol(ayah.numberInSurah, TextDirection.ltr),
          locale: const Locale('ar_SA'),
          style: const TextStyle(
            fontFamily: 'QuranFont 2',
            locale: Locale('ar_SA'),
          ),
        );
}
