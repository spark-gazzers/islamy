import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
part '../../../generated/adapters/hadeeth/hadeeth_details.dart';

@HiveType(typeId: 13)
class HadeethDetails {
  HadeethDetails({
    required this.id,
    required this.title,
    required this.hadeeth,
    required this.attribution,
    required this.grade,
    required this.explanation,
    required this.hints,
    required this.categories,
    required this.translations,
    required this.wordsMeanings,
    required this.reference,
    required this.category,
    required this.language,
  });

  factory HadeethDetails.fromRawJson(
    String str,
    String category,
    String language,
  ) =>
      HadeethDetails.fromJson(
          json.decode(str) as Map<String, dynamic>, category, language);

  factory HadeethDetails.fromJson(
    Map<String, dynamic> json,
    String category,
    String language,
  ) {
    final List<WordsMeaning> meanings = <WordsMeaning>[];
    if (json['words_meanings'] != null) {
      for (final data in json['words_meanings'] as List<dynamic>) {
        if (data['word'] != null && data['meaning'] != null) {
          meanings.add(WordsMeaning.fromJson(data as Map<String, dynamic>));
        }
      }
    }
    return HadeethDetails(
      id: json['id'] as String,
      title: json['title'] as String,
      hadeeth: json['hadeeth'] as String,
      attribution: json['attribution'] as String,
      grade: json['grade'] as String,
      explanation: json['explanation'] as String?,
      hints: List<String>.from((json['hints'] as List).map((x) => x)),
      categories: List<String>.from((json['categories'] as List).map((x) => x)),
      translations:
          List<String>.from((json['translations'] as List).map((x) => x)),
      wordsMeanings: meanings,
      reference: json['reference'] as String?,
      category: category,
      language: language,
    );
  }
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String hadeeth;
  @HiveField(3)
  String attribution;
  @HiveField(4)
  String grade;
  @HiveField(5)
  String? explanation;
  @HiveField(6)
  List<String> hints;
  @HiveField(7)
  List<String> categories;
  @HiveField(8)
  List<String> translations;
  @HiveField(9)
  List<WordsMeaning>? wordsMeanings;
  @HiveField(10)
  String? reference;
  @HiveField(11)
  String category;
  @HiveField(12)
  String language;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'hadeeth': hadeeth,
        'attribution': attribution,
        'grade': grade,
        'explanation': explanation,
        'hints': List<dynamic>.from(hints.map((String x) => x)),
        'categories': List<dynamic>.from(categories.map((String x) => x)),
        'translations': List<dynamic>.from(translations.map((String x) => x)),
        'words_meanings': wordsMeanings?.map((WordsMeaning e) => e.toJson()),
        'reference': reference,
      };
}

@HiveType(typeId: 14)
class WordsMeaning {
  WordsMeaning({
    required this.word,
    required this.meaning,
  });

  factory WordsMeaning.fromRawJson(String str) =>
      WordsMeaning.fromJson(json.decode(str) as Map<String, dynamic>);

  factory WordsMeaning.fromJson(Map<String, dynamic> json) => WordsMeaning(
        word: json['word'] as String,
        meaning: json['meaning'] as String,
      );
  @HiveField(0)
  String word;
  @HiveField(1)
  String meaning;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'word': word,
        'meaning': meaning,
      };
}
