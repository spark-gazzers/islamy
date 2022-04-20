import 'dart:convert';

import 'package:islamy/quran/models/enums.dart';

// A meta that holds the most important data of the [TheHolyQuran] meta's.
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

  factory QuranMeta.fromRawJson(String str) =>
      QuranMeta.fromJson(json.decode(str) as Map<String, dynamic>);

  factory QuranMeta.fromJson(Map<String, dynamic> json) => QuranMeta(
        ayahs: Ayahs.fromJson(json['ayahs'] as Map<String, dynamic>),
        surahs: Surahs.fromJson(json['surahs'] as Map<String, dynamic>),
        sajdas: Sajdas.fromJson(json['sajdas'] as Map<String, dynamic>),
        rukus: HizbQuarters.fromJson(json['rukus'] as Map<String, dynamic>),
        pages: HizbQuarters.fromJson(json['pages'] as Map<String, dynamic>),
        manzils: HizbQuarters.fromJson(json['manzils'] as Map<String, dynamic>),
        hizbQuarters:
            HizbQuarters.fromJson(json['hizbQuarters'] as Map<String, dynamic>),
        juzs: HizbQuarters.fromJson(json['juzs'] as Map<String, dynamic>),
      );

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
  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'ayahs': ayahs.toJson(),
        'surahs': surahs.toJson(),
        'sajdas': sajdas.toJson(),
        'rukus': rukus.toJson(),
        'pages': pages.toJson(),
        'manzils': manzils.toJson(),
        'hizbQuarters': hizbQuarters.toJson(),
        'juzs': juzs.toJson(),
      };
}

class Ayahs {
  Ayahs({
    required this.count,
  });

  factory Ayahs.fromRawJson(String str) =>
      Ayahs.fromJson(json.decode(str) as Map<String, dynamic>);

  factory Ayahs.fromJson(Map<String, dynamic> json) => Ayahs(
        count: json['count'] as int,
      );

  final int count;

  Ayahs copyWith({
    int? count,
  }) =>
      Ayahs(
        count: count ?? this.count,
      );
  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'count': count,
      };
}

class HizbQuarters {
  HizbQuarters({
    required this.count,
    required this.references,
  });

  factory HizbQuarters.fromRawJson(String str) =>
      HizbQuarters.fromJson(json.decode(str) as Map<String, dynamic>);

  factory HizbQuarters.fromJson(Map<String, dynamic> json) => HizbQuarters(
        count: json['count'] as int,
        references: List<HizbQuartersReference>.from(
          (json['references'] as List<Map<String, dynamic>>)
              .map<HizbQuartersReference>(HizbQuartersReference.fromJson),
        ),
      );

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

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => <String, dynamic>{
        'count': count,
        'references': List<dynamic>.from(
          references.map<Map<String, dynamic>>(
            (HizbQuartersReference x) => x.toJson(),
          ),
        ),
      };
}

class HizbQuartersReference {
  HizbQuartersReference({
    required this.surah,
    required this.ayah,
  });

  factory HizbQuartersReference.fromRawJson(String str) =>
      HizbQuartersReference.fromJson(json.decode(str) as Map<String, dynamic>);

  factory HizbQuartersReference.fromJson(Map<String, dynamic> json) =>
      HizbQuartersReference(
        surah: json['surah'] as int,
        ayah: json['ayah'] as int,
      );

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

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => <String, dynamic>{
        'surah': surah,
        'ayah': ayah,
      };
}

class Sajdas {
  Sajdas({
    required this.count,
    required this.references,
  });

  factory Sajdas.fromRawJson(String str) =>
      Sajdas.fromJson(json.decode(str) as Map<String, dynamic>);

  factory Sajdas.fromJson(Map<String, dynamic> json) => Sajdas(
        count: json['count'] as int,
        references: List<SajdasReference>.from(
          (json['references'] as List<Map<String, dynamic>>)
              .map<SajdasReference>(SajdasReference.fromJson),
        ),
      );

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

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'count': count,
        'references': List<dynamic>.from(
          references
              .map<Map<String, dynamic>>((SajdasReference x) => x.toJson()),
        ),
      };
}

class SajdasReference {
  SajdasReference({
    required this.surah,
    required this.ayah,
    required this.recommended,
    required this.obligatory,
  });

  factory SajdasReference.fromRawJson(String str) =>
      SajdasReference.fromJson(json.decode(str) as Map<String, dynamic>);

  factory SajdasReference.fromJson(Map<String, dynamic> json) =>
      SajdasReference(
        surah: json['surah'] as int,
        ayah: json['ayah'] as int,
        recommended: json['recommended'] as bool,
        obligatory: json['obligatory'] as bool,
      );

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

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => <String, dynamic>{
        'surah': surah,
        'ayah': ayah,
        'recommended': recommended,
        'obligatory': obligatory,
      };
}

class Surahs {
  Surahs({
    required this.count,
    required this.references,
  });

  factory Surahs.fromRawJson(String str) =>
      Surahs.fromJson(json.decode(str) as Map<String, dynamic>);

  factory Surahs.fromJson(Map<String, dynamic> json) => Surahs(
        count: json['count'] as int,
        references: List<SurahsReference>.from(
          (json['references'] as List<Map<String, dynamic>>)
              .map<SurahsReference>(SurahsReference.fromJson),
        ),
      );

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

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'count': count,
        'references': List<Map<String, dynamic>>.from(
          references
              .map<Map<String, dynamic>>((SurahsReference x) => x.toJson()),
        ),
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

  factory SurahsReference.fromRawJson(String str) =>
      SurahsReference.fromJson(json.decode(str) as Map<String, dynamic>);

  factory SurahsReference.fromJson(Map<String, dynamic> json) =>
      SurahsReference(
        number: json['number'] as int,
        name: json['name'] as String,
        englishName: json['englishName'] as String,
        englishNameTranslation: json['englishNameTranslation'] as String,
        numberOfAyahs: json['numberOfAyahs'] as int,
        revelationType:
            RevelationType.values.byName(json['revelationType'] as String),
      );

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

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'number': number,
        'name': name,
        'englishName': englishName,
        'englishNameTranslation': englishNameTranslation,
        'numberOfAyahs': numberOfAyahs,
        'revelationType': revelationType.name,
      };
}
