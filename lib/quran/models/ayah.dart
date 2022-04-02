import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:islamy/quran/models/sajda.dart';

part 'ayah.g.dart';

@HiveType(typeId: 7)
class Ayah {
  @override
  operator ==(Object other) => other is Ayah && other.number == number;
  @override
  int get hashCode => number.hashCode;
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

  factory Ayah.fromRawJson(String str) => Ayah.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Ayah.fromJson(Map<String, dynamic> json) => Ayah(
        number: json["number"],
        text: json["text"],
        numberInSurah: json["numberInSurah"],
        juz: json["juz"],
        manzil: json["manzil"],
        page: json["page"],
        ruku: json["ruku"],
        hizbQuarter: json["hizbQuarter"],
        sajda: json["sajda"] == false ? null : Sajda.fromJson(json["sajda"]),
        audio: json["audio"],
        audioSecondary: json["audioSecondary"] == null
            ? null
            : List<String>.from(json["audioSecondary"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "text": text,
        "numberInSurah": numberInSurah,
        "juz": juz,
        "manzil": manzil,
        "page": page,
        "ruku": ruku,
        "hizbQuarter": hizbQuarter,
        "sajda": sajda?.toJson(),
        "audio": audio,
        "audioSecondary": audioSecondary == null
            ? null
            : List<dynamic>.from(audioSecondary!.map((x) => x)),
      };
}
