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

  factory Juz.fromJson(Map<String, dynamic> json) => Juz(
        index: json['index'] as int,
        name: json['name'] as String,
        englishName: json['englishName'] as String,
        surahsRange:
            SurahsRange.fromJson(json['surahs_range'] as Map<String, dynamic>),
      );

  final int index;
  @override
  final String name;
  @override
  final String englishName;
  final SurahsRange surahsRange;

  String get otherName =>
      !Store.locale.languageCode.startsWith('ar') ? name : englishName;
  static List<Juz> listFromRawJson(String str) {
    List<dynamic> maps = json.decode(str) as List<dynamic>;

    return maps.map((e) => Juz.fromJson(e as Map<String, dynamic>)).toList();
  }

  bool containsSurah(int number) =>
      number >= surahsRange.start && number <= surahsRange.end;
}

class SurahsRange {
  SurahsRange({
    required this.start,
    required this.end,
  });

  factory SurahsRange.fromJson(Map<String, dynamic> json) => SurahsRange(
        start: json['start'] as int,
        end: json['end'] as int,
      );

  final int start;
  final int end;
}
