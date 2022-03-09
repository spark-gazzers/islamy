import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:islamy/quran/models/edition.dart';
import 'package:islamy/quran/models/surah.dart';

part 'text_quran.g.dart';

@HiveType(typeId: 5)
class TheHolyQuran {
  TheHolyQuran({
    required this.surahs,
    required this.edition,
  });
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

  factory TheHolyQuran.fromRawJson(String str) =>
      TheHolyQuran.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TheHolyQuran.fromJson(Map<String, dynamic> json) => TheHolyQuran(
        surahs: List<Surah>.from(json["surahs"].map((x) => Surah.fromJson(x))),
        edition: Edition.fromJson(json["edition"]),
      );

  Map<String, dynamic> toJson() => {
        "surahs": List<dynamic>.from(surahs.map((x) => x.toJson())),
        "edition": edition.toJson(),
      };
}
