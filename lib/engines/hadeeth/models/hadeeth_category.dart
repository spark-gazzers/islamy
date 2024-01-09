import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part '../../../generated/adapters/hadeeth/hadeeth_category.dart';

@HiveType(typeId: 11)

/// A class that represents a hadeeth category.
class HadeethCategory {
  const HadeethCategory({
    required this.id,
    required this.title,
    required this.hadeethsCount,
    required this.parentId,
    required this.language,
  });
  factory HadeethCategory.fromRawJson(String str, String language) =>
      HadeethCategory.fromJson(
          json.decode(str) as Map<String, dynamic>, language);

  factory HadeethCategory.fromJson(
    Map<String, dynamic> json,
    String language,
  ) =>
      HadeethCategory(
        id: json['id'] as String,
        title: json['title'] as String,
        hadeethsCount: json['hadeeths_count'] as String,
        parentId: json['parent_id'] as String?,
        language: language,
      );

  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String hadeethsCount;
  @HiveField(3)
  final String? parentId;
  @HiveField(4)
  final String language;

  static List<HadeethCategory> listFrom(
          List<Map<String, dynamic>> json, String langauge) =>
      List<HadeethCategory>.from(json
          .map<HadeethCategory>((e) => HadeethCategory.fromJson(e, langauge)));

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'hadeeths_count': hadeethsCount,
        'parent_id': parentId,
      };
  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) =>
      other is HadeethCategory && id == other.id && other.language == language;
}
