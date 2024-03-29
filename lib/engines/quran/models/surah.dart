import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:islamy/engines/quran/models/alquran_cloud_object.dart';
import 'package:islamy/engines/quran/models/ayah.dart';
import 'package:islamy/engines/quran/models/enums.dart';
import 'package:islamy/engines/quran/models/the_holy_quran.dart';

part '../../../generated/adapters/quran/surah.dart';

/// [TheHolyQuran] surah with it's ayahs ,the revelation type
/// and it's number in [TheHolyQuran].
@HiveType(typeId: 6)
class Surah extends AlquranCloudObject {
  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.ayahs,
  });

  factory Surah.fromRawJson(String str) =>
      Surah.fromJson(json.decode(str) as Map<String, dynamic>);

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
        number: json['number'] as int,
        name: json['name'] as String,
        englishName: json['englishName'] as String,
        englishNameTranslation: json['englishNameTranslation'] as String,
        revelationType: RevelationType.values
            .byName((json['revelationType'] as String).toLowerCase()),
        ayahs: List<Ayah>.from(
          (json['ayahs'] as List<dynamic>)
              .whereType<Map<String, dynamic>>()
              .map<Ayah>(Ayah.fromJson),
        ),
      );

  @HiveField(0)
  final int number;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String englishName;
  @HiveField(3)
  final String englishNameTranslation;
  @HiveField(4)
  final RevelationType revelationType;
  @HiveField(5)
  final List<Ayah> ayahs;

  @override
  bool operator ==(Object other) => other is Surah && other.number == number;
  @override
  int get hashCode => number.hashCode;

  Surah copyWith({
    int? number,
    String? name,
    String? englishName,
    String? englishNameTranslation,
    RevelationType? revelationType,
    List<Ayah>? ayahs,
  }) =>
      Surah(
        number: number ?? this.number,
        name: name ?? this.name,
        englishName: englishName ?? this.englishName,
        englishNameTranslation:
            englishNameTranslation ?? this.englishNameTranslation,
        revelationType: revelationType ?? this.revelationType,
        ayahs: ayahs ?? this.ayahs,
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'number': number,
        'name': name,
        'englishName': englishName,
        'englishNameTranslation': englishNameTranslation,
        'revelationType': revelationType.name,
        'ayahs': List<Map<String, dynamic>>.from(
          ayahs.map<Map<String, dynamic>>((Ayah x) => x.toJson()),
        ),
      };
}
