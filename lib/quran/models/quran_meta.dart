import 'dart:convert';

import 'package:islamy/quran/models/enums.dart';

class QuranMeta {
  QuranMeta({
    required this.ayahs,
    required this.surahs,
    required this.sajdas,
    required this.rukus,
    required this.pages,
    required this.manzils,
    required this.hizbQuarters,
    required this.juzs,
  });

  final Ayahs ayahs;
  final Surahs surahs;
  final Sajdas sajdas;
  final HizbQuarters rukus;
  final HizbQuarters pages;
  final HizbQuarters manzils;
  final HizbQuarters hizbQuarters;
  final HizbQuarters juzs;

  QuranMeta copyWith({
    Ayahs? ayahs,
    Surahs? surahs,
    Sajdas? sajdas,
    HizbQuarters? rukus,
    HizbQuarters? pages,
    HizbQuarters? manzils,
    HizbQuarters? hizbQuarters,
    HizbQuarters? juzs,
  }) =>
      QuranMeta(
        ayahs: ayahs ?? this.ayahs,
        surahs: surahs ?? this.surahs,
        sajdas: sajdas ?? this.sajdas,
        rukus: rukus ?? this.rukus,
        pages: pages ?? this.pages,
        manzils: manzils ?? this.manzils,
        hizbQuarters: hizbQuarters ?? this.hizbQuarters,
        juzs: juzs ?? this.juzs,
      );

  factory QuranMeta.fromRawJson(String str) =>
      QuranMeta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuranMeta.fromJson(Map<String, dynamic> json) => QuranMeta(
        ayahs: Ayahs.fromJson(json["ayahs"]),
        surahs: Surahs.fromJson(json["surahs"]),
        sajdas: Sajdas.fromJson(json["sajdas"]),
        rukus: HizbQuarters.fromJson(json["rukus"]),
        pages: HizbQuarters.fromJson(json["pages"]),
        manzils: HizbQuarters.fromJson(json["manzils"]),
        hizbQuarters: HizbQuarters.fromJson(json["hizbQuarters"]),
        juzs: HizbQuarters.fromJson(json["juzs"]),
      );

  Map<String, dynamic> toJson() => {
        "ayahs": ayahs.toJson(),
        "surahs": surahs.toJson(),
        "sajdas": sajdas.toJson(),
        "rukus": rukus.toJson(),
        "pages": pages.toJson(),
        "manzils": manzils.toJson(),
        "hizbQuarters": hizbQuarters.toJson(),
        "juzs": juzs.toJson(),
      };
}

class Ayahs {
  Ayahs({
    required this.count,
  });

  final int count;

  Ayahs copyWith({
    int? count,
  }) =>
      Ayahs(
        count: count ?? this.count,
      );

  factory Ayahs.fromRawJson(String str) => Ayahs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ayahs.fromJson(Map<String, dynamic> json) => Ayahs(
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
      };
}

class HizbQuarters {
  HizbQuarters({
    required this.count,
    required this.references,
  });

  final int count;
  final List<HizbQuartersReference> references;

  HizbQuarters copyWith({
    int? count,
    List<HizbQuartersReference>? references,
  }) =>
      HizbQuarters(
        count: count ?? this.count,
        references: references ?? this.references,
      );

  factory HizbQuarters.fromRawJson(String str) =>
      HizbQuarters.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HizbQuarters.fromJson(Map<String, dynamic> json) => HizbQuarters(
        count: json["count"],
        references: List<HizbQuartersReference>.from(
            json["references"].map((x) => HizbQuartersReference.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "references": List<dynamic>.from(references.map((x) => x.toJson())),
      };
}

class HizbQuartersReference {
  HizbQuartersReference({
    required this.surah,
    required this.ayah,
  });

  final int surah;
  final int ayah;

  HizbQuartersReference copyWith({
    int? surah,
    int? ayah,
  }) =>
      HizbQuartersReference(
        surah: surah ?? this.surah,
        ayah: ayah ?? this.ayah,
      );

  factory HizbQuartersReference.fromRawJson(String str) =>
      HizbQuartersReference.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HizbQuartersReference.fromJson(Map<String, dynamic> json) =>
      HizbQuartersReference(
        surah: json["surah"],
        ayah: json["ayah"],
      );

  Map<String, dynamic> toJson() => {
        "surah": surah,
        "ayah": ayah,
      };
}

class Sajdas {
  Sajdas({
    required this.count,
    required this.references,
  });

  final int count;
  final List<SajdasReference> references;

  Sajdas copyWith({
    int? count,
    List<SajdasReference>? references,
  }) =>
      Sajdas(
        count: count ?? this.count,
        references: references ?? this.references,
      );

  factory Sajdas.fromRawJson(String str) => Sajdas.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sajdas.fromJson(Map<String, dynamic> json) => Sajdas(
        count: json["count"],
        references: List<SajdasReference>.from(
            json["references"].map((x) => SajdasReference.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "references": List<dynamic>.from(references.map((x) => x.toJson())),
      };
}

class SajdasReference {
  SajdasReference({
    required this.surah,
    required this.ayah,
    required this.recommended,
    required this.obligatory,
  });

  final int surah;
  final int ayah;
  final bool recommended;
  final bool obligatory;

  SajdasReference copyWith({
    int? surah,
    int? ayah,
    bool? recommended,
    bool? obligatory,
  }) =>
      SajdasReference(
        surah: surah ?? this.surah,
        ayah: ayah ?? this.ayah,
        recommended: recommended ?? this.recommended,
        obligatory: obligatory ?? this.obligatory,
      );

  factory SajdasReference.fromRawJson(String str) =>
      SajdasReference.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SajdasReference.fromJson(Map<String, dynamic> json) =>
      SajdasReference(
        surah: json["surah"],
        ayah: json["ayah"],
        recommended: json["recommended"],
        obligatory: json["obligatory"],
      );

  Map<String, dynamic> toJson() => {
        "surah": surah,
        "ayah": ayah,
        "recommended": recommended,
        "obligatory": obligatory,
      };
}

class Surahs {
  Surahs({
    required this.count,
    required this.references,
  });

  final int count;
  final List<SurahsReference> references;

  Surahs copyWith({
    int? count,
    List<SurahsReference>? references,
  }) =>
      Surahs(
        count: count ?? this.count,
        references: references ?? this.references,
      );

  factory Surahs.fromRawJson(String str) => Surahs.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Surahs.fromJson(Map<String, dynamic> json) => Surahs(
        count: json["count"],
        references: List<SurahsReference>.from(
            json["references"].map((x) => SurahsReference.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "references": List<dynamic>.from(references.map((x) => x.toJson())),
      };
}

class SurahsReference {
  SurahsReference({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final RevelationType revelationType;

  SurahsReference copyWith({
    int? number,
    String? name,
    String? englishName,
    String? englishNameTranslation,
    int? numberOfAyahs,
    RevelationType? revelationType,
  }) =>
      SurahsReference(
        number: number ?? this.number,
        name: name ?? this.name,
        englishName: englishName ?? this.englishName,
        englishNameTranslation:
            englishNameTranslation ?? this.englishNameTranslation,
        numberOfAyahs: numberOfAyahs ?? this.numberOfAyahs,
        revelationType: revelationType ?? this.revelationType,
      );

  factory SurahsReference.fromRawJson(String str) =>
      SurahsReference.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SurahsReference.fromJson(Map<String, dynamic> json) =>
      SurahsReference(
        number: json["number"],
        name: json["name"],
        englishName: json["englishName"],
        englishNameTranslation: json["englishNameTranslation"],
        numberOfAyahs: json["numberOfAyahs"],
        revelationType: revelationTypeValues.map[json["revelationType"]]!,
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "name": name,
        "englishName": englishName,
        "englishNameTranslation": englishNameTranslation,
        "numberOfAyahs": numberOfAyahs,
        "revelationType": revelationTypeValues.reverse[revelationType],
      };
}
