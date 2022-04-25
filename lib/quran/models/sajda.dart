import 'dart:convert';

import 'package:hive_flutter/adapters.dart';

part '../../generated/adapters/quran/sajda.dart';

@HiveType(typeId: 8)
class Sajda {
  Sajda({
    required this.id,
    required this.recommended,
    required this.obligatory,
  });

  factory Sajda.fromRawJson(String str) =>
      Sajda.fromJson(json.decode(str) as Map<String, dynamic>);

  factory Sajda.fromJson(Map<String, dynamic> json) => Sajda(
        id: json['id'] as int,
        recommended: json['recommended'] as bool,
        obligatory: json['obligatory'] as bool,
      );

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

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'recommended': recommended,
        'obligatory': obligatory,
      };
}
