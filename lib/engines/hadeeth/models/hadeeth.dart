import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part '../../../generated/adapters/hadeeth/hadeeth.dart';

@HiveType(typeId: 12)
class Hadeeth extends HiveObject {
  Hadeeth({
    required this.id,
    required this.title,
    required this.translations,
  });

  factory Hadeeth.fromRawJson(String str) =>
      Hadeeth.fromJson(json.decode(str) as Map<String, dynamic>);

  factory Hadeeth.fromJson(Map<String, dynamic> json) => Hadeeth(
        id: json['id'] as String,
        title: json['title'] as String,
        translations: List<String>.from(
            (json['translations'] as List<dynamic>).map((x) => x as String)),
      );

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final List<String> translations;

  static List<Hadeeth> listFrom(List<Map<String, dynamic>> json) =>
      List<Hadeeth>.from(json.map<Hadeeth>(Hadeeth.fromJson));

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'translations': List<dynamic>.from(translations.map((String x) => x)),
      };
}
