import 'dart:convert';

import 'package:hive_flutter/adapters.dart';

part 'sajda.g.dart';

@HiveType(typeId: 8)
class Sajda {
  Sajda({
    required this.id,
    required this.recommended,
    required this.obligatory,
  });
  @HiveField(0)
  final int id;
  @HiveField(1)
  final bool recommended;
  @HiveField(2)
  final bool obligatory;

  Sajda copyWith({
    int? id,
    bool? recommended,
    bool? obligatory,
  }) =>
      Sajda(
        id: id ?? this.id,
        recommended: recommended ?? this.recommended,
        obligatory: obligatory ?? this.obligatory,
      );

  factory Sajda.fromRawJson(String str) => Sajda.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sajda.fromJson(Map<String, dynamic> json) => Sajda(
        id: json["id"],
        recommended: json["recommended"],
        obligatory: json["obligatory"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "recommended": recommended,
        "obligatory": obligatory,
      };
}
