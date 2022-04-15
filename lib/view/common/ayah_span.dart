import 'package:flutter/gestures.dart' show LongPressGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/utils/helper.dart';

class AyahSpan extends TextSpan {
  AyahSpan({
    required Ayah ayah,
    required TextDirection direction,
    required VoidCallback? onTap,
    required VoidCallback? onLongTap,
    required bool isSelected,
  }) : super(
          children: <InlineSpan>[
            TextSpan(
              text: ayah.text,
              recognizer: LongPressGestureRecognizer()
                ..onLongPressCancel = onTap
                ..onLongPress = () {
                  if (onLongTap != null) {
                    HapticFeedback.heavyImpact();
                    onLongTap();
                  }
                },
            ),
            AyahsNumberSpan(ayah: ayah, direction: direction),
          ],
          style: TextStyle(
            background: Paint()
              ..color = isSelected ? Colors.red : Colors.transparent,
            decoration:
                isSelected ? TextDecoration.underline : TextDecoration.none,
          ),
        );
}

class AyahsNumberSpan extends TextSpan {
  AyahsNumberSpan({
    required Ayah ayah,
    required TextDirection direction,
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
