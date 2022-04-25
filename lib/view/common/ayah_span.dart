import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/quran_manager.dart';
import 'package:islamy/theme.dart';
import 'package:islamy/utils/helper.dart';
import 'package:islamy/utils/store.dart';

/// This span handles the proper formatting of [Ayah.text].
class AyahSpan extends TextSpan {
  AyahSpan({
    required Ayah ayah,
    VoidCallback? onTap,
    VoidCallback? onLongTap,
    bool isSelected = false,
  }) : super(
          children: <InlineSpan>[
            ...AyahTajweedSplitter.formatAyah(
              ayah,
              recognizer: MultiTapGestureRecognizer(
                longTapDelay: const Duration(milliseconds: 300),
              )
                ..onLongTapDown = (int pointer, TapDownDetails details) {
                  print('object');
                  if (onLongTap != null) {
                    HapticFeedback.heavyImpact();
                    onLongTap();
                  }
                }
                ..onTap = (_) => onTap?.call(),
            ),
            AyahsNumberSpan(ayah: ayah),
          ],
          style: TextStyle(
            fontFamily: Store.quranFont,
            fontSize: Store.quranFontSize,
            color: Colors.black,
            background: Paint()
              ..color = isSelected
                  ? ThemeBuilder.lightTheme.colorScheme.tertiaryContainer
                  : Colors.transparent,
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
          style: const TextStyle(
            fontFamily: 'QuranFont 2',
            locale: Locale('ar_SA'),
          ),
        );
}
