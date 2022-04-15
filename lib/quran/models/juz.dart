import 'dart:convert' show json;

import 'package:islamy/quran/models/alquran_cloud_object.dart';
import 'package:islamy/utils/store.dart';

class Juz extends AlquranCloudObject {
  Juz({
    required this.index,
    required this.name,
    required this.englishName,
    required this.surahsRange,
  });

  final int index;
  final String name;
  final String englishName;
  final SurahsRange surahsRange;

  String get otherName =>
      !Store.locale.languageCode.startsWith('ar') ? name : englishName;
  static List<Juz> listFromRawJson(String str) =>
      (json.decode(str) as List).map((e) => Juz.fromJson(e)).toList();

  factory Juz.fromJson(Map<String, dynamic> json) => Juz(
        index: json["index"],
        name: json["name"],
        englishName: json["englishName"],
        surahsRange: SurahsRange.fromJson(json["surahs_range"]),
      );
  bool containsSurah(int number) =>
      number >= surahsRange.start && number <= surahsRange.end;
}

class SurahsRange {
  SurahsRange({
    required this.start,
    required this.end,
  });

  final int start;
  final int end;

  factory SurahsRange.fromJson(Map<String, dynamic> json) => SurahsRange(
        start: json["start"],
        end: json["end"],
      );
}
