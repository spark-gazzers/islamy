import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/quran_page.dart';
import 'package:islamy/quran/models/surah.dart';

part '../../generated/adapters/quran/the_holy_quran.dart';

@HiveType(typeId: 5)
class TheHolyQuran {
  TheHolyQuran({
    required this.surahs,
    required this.edition,
  });

  factory TheHolyQuran.fromRawJson(String str) =>
      TheHolyQuran.fromJson(json.decode(str) as Map<String, dynamic>);

  factory TheHolyQuran.fromJson(Map<String, dynamic> json) => TheHolyQuran(
        surahs: List<Surah>.from(
          (json['surahs'] as List<dynamic>)
              .whereType<Map<dynamic, dynamic>>()
              .map<Surah>(
                (Map<dynamic, dynamic> e) =>
                    Surah.fromJson(e.cast<String, dynamic>()),
              ),
        ),
        edition: Edition.fromJson(json['edition'] as Map<String, dynamic>),
      );

  @override
  bool operator ==(Object other) =>
      other is TheHolyQuran && other.edition == edition;

  @override
  int get hashCode => edition.hashCode;

  List<QuranPage> get pages {
    _pages ??= QuranPage.formatQuran(surahs);
    return _pages!;
  }

  List<QuranPage>? _pages;
  @HiveField(0)
  final List<Surah> surahs;
  @HiveField(1)
  final Edition edition;

  TheHolyQuran copyWith({
    List<Surah>? surahs,
    Edition? edition,
  }) =>
      TheHolyQuran(
        surahs: surahs ?? this.surahs,
        edition: edition ?? this.edition,
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'surahs': List<dynamic>.from(
          surahs.map<Map<String, dynamic>>((Surah x) => x.toJson()),
        ),
        'edition': edition.toJson(),
      };
}
