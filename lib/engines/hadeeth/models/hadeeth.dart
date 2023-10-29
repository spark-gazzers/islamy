import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part '../../../generated/adapters/hadeeth/hadeeth.dart';

@HiveType(typeId: 12)
class Hadeeth extends HiveObject {
  Hadeeth({
    required this.id,
    required this.title,
    required this.translations,
    required this.languageCode,
    required this.category,
  });

  factory Hadeeth.fromRawJson(
    String str,
    String languageCode,
    String? category,
  ) =>
      Hadeeth.fromJson(
          json.decode(str) as Map<String, dynamic>, languageCode, category);

  factory Hadeeth.fromJson(
    Map<String, dynamic> json,
    String languageCode,
    String? category,
  ) =>
      Hadeeth(
        id: json['id'] as String,
        title: json['title'] as String,
        translations: List<String>.from((json['translations'] as List<dynamic>)
            .map((dynamic x) => x as String)),
        languageCode: languageCode,
        category: category,
      );

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final List<String> translations;
  @HiveField(3)
  final String languageCode;
  @HiveField(4)
  final String? category;

  static List<Hadeeth> listFrom(
    List<Map<String, dynamic>> json,
    String languageCode,
    String? category,
  ) =>
      List<Hadeeth>.from(json.map<Hadeeth>(
        (Map<String, dynamic> e) => Hadeeth.fromJson(e, languageCode, category),
      ));

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'translations': List<dynamic>.from(translations.map((String x) => x)),
      };

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      other is Hadeeth && other.id == id && other.languageCode == languageCode;
}
