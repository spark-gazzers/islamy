import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:islamy/quran/models/enums.dart';
import 'package:intl/intl.dart' as intl;
import 'package:islamy/quran/models/alquran_cloud_object.dart';
part 'edition.g.dart';

@HiveType(typeId: 0)
class Edition extends HiveObject with AlquranCloudObject {
  @override
  operator ==(Object other) =>
      other is Edition && other.identifier == identifier;
  @override
  int get hashCode => identifier.hashCode;
  Edition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    required this.direction,
  });

  @HiveField(0)
  final String identifier;
  @HiveField(1)
  final String language;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String englishName;
  @HiveField(4)
  final Format format;
  @HiveField(5)
  final QuranContentType type;
  @HiveField(6)
  final Direction direction;

  Edition copyWith({
    String? identifier,
    String? language,
    String? name,
    String? englishName,
    Format? format,
    QuranContentType? type,
    Direction? direction,
  }) =>
      Edition(
        identifier: identifier ?? this.identifier,
        language: language ?? this.language,
        name: name ?? this.name,
        englishName: englishName ?? this.englishName,
        format: format ?? this.format,
        type: type ?? this.type,
        direction: direction ?? this.direction,
      );

  factory Edition.fromRawJson(String str) => Edition.fromJson(json.decode(str));

  static List<Edition> listFrom(List json) =>
      List<Edition>.from(json.map((x) => Edition.fromJson(x)));
  String toRawJson() => json.encode(toJson());

  factory Edition.fromJson(Map<String, dynamic> json) => Edition(
        identifier: json["identifier"],
        language: json["language"],
        name: json["name"],
        englishName: json["englishName"],
        format: formatValues.map[json["format"]]!,
        type: typeValues.map[json["type"]]!,
        direction: directionValues.map[json["direction"]] ??
            (intl.Bidi.isRtlLanguage(json["language"].toString())
                ? Direction.rtl
                : Direction.ltr),
      );

  Map<String, dynamic> toJson() => {
        "identifier": identifier,
        "language": language,
        "name": name,
        "englishName": englishName,
        "format": formatValues.reverse[format],
        "type": typeValues.reverse[type],
        "direction": directionValues.reverse[direction],
      };
}
