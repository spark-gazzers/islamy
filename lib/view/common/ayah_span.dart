import 'package:flutter/material.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/utils/helper.dart';

class AyahSpan extends TextSpan {
  AyahSpan({
    required Ayah ayah,
    required TextDirection direction,
  }) : super(
          children: <InlineSpan>[
            TextSpan(text: ayah.text),
            AyahsNumberSpan(ayah: ayah, direction: direction),
          ],
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
