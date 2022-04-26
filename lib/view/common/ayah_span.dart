import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/theme.dart';
import 'package:islamy/utils/helper.dart';

/// This span handles the proper formatting of [Ayah.text].
class AyahSpan extends TextSpan {
  AyahSpan({
    required Ayah ayah,
    VoidCallback? onTap,
    VoidCallback? onLongTap,
    bool isSelected = false,
    bool includeNumber = true,
  }) : super(
          children: <InlineSpan>[
            TextSpan(
              children: AyahTajweedSplitter.formatAyah(
                ayah,
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
              ),
              style: TextStyle(
                background: Paint()
                  ..color = isSelected
                      ? ThemeBuilder.lightTheme.colorScheme.secondaryContainer
                      : Colors.transparent,
              ),
            ),
            if (includeNumber) AyahsNumberSpan(ayah: ayah),
          ],
          style: TextStyle(
            fontFamily: QuranStore.settings.quranFont,
            fontSize: QuranStore.settings.quranFontSize,
            color: Colors.black,
          ),
        );
}

/// The span to show [Ayah.numberInSurah].
///
/// The class changes the interprets the number as arabic number to
/// parse in the uthmanic font as ayah rounded icon.
class AyahsNumberSpan extends TextSpan {
  AyahsNumberSpan({
    required Ayah ayah,
  }) : super(
          text: Helper.localization
              .getVerseEndSymbol(ayah.numberInSurah, TextDirection.ltr),
          locale: const Locale('ar_SA'),
          style: TextStyle(
            fontFamily: 'QuranFont 2',
            locale: const Locale('ar_SA'),
            fontSize: QuranStore.settings.quranFontSize + 10,
          ),
        );
}
