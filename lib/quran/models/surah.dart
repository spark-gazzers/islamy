import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:islamy/quran/models/ayah.dart';
import 'package:islamy/quran/models/enums.dart';

part 'surah.g.dart';

@HiveType(typeId: 6)
class Surah {
  @override
  String toString() {
    return number.toString();
  }

  String get name => arabicName.substring(arabicName.indexOf(' ') + 1);
  @override
  operator ==(Object other) => other is Surah && other.number == number;
  @override
  int get hashCode => number.hashCode;
  Surah({
    required this.number,
    required this.arabicName,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });
  @HiveField(0)
  final int number;
  @HiveField(1)
  final String arabicName;
  @HiveField(2)
  final String englishName;
  @HiveField(3)
  final String englishNameTranslation;
  @HiveField(4)
  final RevelationType revelationType;
  @HiveField(5)
  final List<Ayah> ayahs;

  Surah copyWith({
    int? number,
    String? arabicName,
    String? englishName,
    String? englishNameTranslation,
    RevelationType? revelationType,
    List<Ayah>? ayahs,
  }) =>
      Surah(
        number: number ?? this.number,
        arabicName: arabicName ?? this.arabicName,
        englishName: englishName ?? this.englishName,
        englishNameTranslation:
            englishNameTranslation ?? this.englishNameTranslation,
        revelationType: revelationType ?? this.revelationType,
        ayahs: ayahs ?? this.ayahs,
      );

  factory Surah.fromRawJson(String str) => Surah.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
        number: json["number"],
        arabicName: json["name"],
        englishName: json["englishName"],
        englishNameTranslation: json["englishNameTranslation"],
        revelationType: revelationTypeValues.map[json["revelationType"]]!,
        ayahs: List<Ayah>.from(json["ayahs"].map((x) => Ayah.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "name": arabicName,
        "englishName": englishName,
        "englishNameTranslation": englishNameTranslation,
        "revelationType": revelationTypeValues.reverse[revelationType]!,
        "ayahs": List<dynamic>.from(ayahs.map((x) => x.toJson())),
      };
}
