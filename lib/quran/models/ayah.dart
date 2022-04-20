import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:islamy/quran/models/sajda.dart';
import 'package:islamy/quran/models/the_holy_quran.dart';

part 'ayah.g.dart';

@HiveType(typeId: 7)

/// A class that represents data associated with an ayah in the quran
///
/// the properies [audio] and [audioSecondary] will not be null only if
/// the parent [TheHolyQuran] format is [Format.audio]
class Ayah {
  Ayah({
    required this.audio,
    required this.audioSecondary,
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  factory Ayah.fromRawJson(String str) =>
      Ayah.fromJson(json.decode(str) as Map<String, dynamic>);

  factory Ayah.fromJson(Map<String, dynamic> json) => Ayah(
        number: json['number'] as int,
        text: json['text'] as String,
        numberInSurah: json['numberInSurah'] as int,
        juz: json['juz'] as int,
        manzil: json['manzil'] as int,
        page: json['page'] as int,
        ruku: json['ruku'] as int,
        hizbQuarter: json['hizbQuarter'] as int,
        sajda: json['sajda'] == false
            ? null
            : Sajda.fromJson(json['sajda'] as Map<String, dynamic>),
        audio: json['audio'] as String,
        audioSecondary: json['audioSecondary'] == null
            ? null
            : List<String>.from(
                (json['audioSecondary'] as List<String>)
                    .map<String>((String x) => x),
              ),
      );

  @override
  bool operator ==(Object other) => other is Ayah && other.number == number;

  @override
  int get hashCode => number.hashCode;

  @HiveField(0)
  final int number;
  @HiveField(1)
  final String text;
  @HiveField(2)
  final int numberInSurah;
  @HiveField(3)
  final int juz;
  @HiveField(4)
  final int manzil;
  @HiveField(5)
  final int page;
  @HiveField(6)
  final int ruku;
  @HiveField(7)
  final int hizbQuarter;
  @HiveField(8)
  final Sajda? sajda;
  @HiveField(9)
  final String? audio;
  @HiveField(10)
  final List<String>? audioSecondary;

  Ayah copyWith({
    int? number,
    String? text,
    int? numberInSurah,
    int? juz,
    int? manzil,
    int? page,
    int? ruku,
    int? hizbQuarter,
    Sajda? sajda,
    String? audio,
    List<String>? audioSecondary,
  }) =>
      Ayah(
        number: number ?? this.number,
        text: text ?? this.text,
        numberInSurah: numberInSurah ?? this.numberInSurah,
        juz: juz ?? this.juz,
        manzil: manzil ?? this.manzil,
        page: page ?? this.page,
        ruku: ruku ?? this.ruku,
        hizbQuarter: hizbQuarter ?? this.hizbQuarter,
        sajda: sajda ?? this.sajda,
        audio: audio ?? this.audio,
        audioSecondary: audioSecondary ?? this.audioSecondary,
      );

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'number': number,
        'text': text,
        'numberInSurah': numberInSurah,
        'juz': juz,
        'manzil': manzil,
        'page': page,
        'ruku': ruku,
        'hizbQuarter': hizbQuarter,
        'sajda': sajda?.toJson(),
        'audio': audio,
        'audioSecondary': audioSecondary == null
            ? null
            : List<dynamic>.from(audioSecondary!.map<String>((String x) => x)),
      };
}
