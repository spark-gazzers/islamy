import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:islamy/quran/models/alquran_cloud_object.dart';
import 'package:islamy/quran/models/enums.dart';

part 'edition.g.dart';

/// The quran edition.
///
/// Editions are genuinely container for quran specific meta like
/// foramt,revelation and type ...
@HiveType(typeId: 0)
class Edition extends HiveObject with AlquranCloudObject {
  Edition({
    required this.identifier,
    required this.language,
    required this.name,
    required this.englishName,
    required this.format,
    required this.type,
    required this.direction,
  });
  factory Edition.fromRawJson(String str) =>
      Edition.fromJson(json.decode(str) as Map<String, dynamic>);

  factory Edition.fromJson(Map<String, dynamic> json) => Edition(
        identifier: json['identifier'] as String,
        language: json['language'] as String,
        name: json['name'] as String,
        englishName: json['englishName'] as String,
        format: Format.values.byName(json['format'] as String),
        type: QuranContentType.values.byName(json['type'] as String),
        direction: Direction.values.byName(
          json['direction'] as String? ??
              // if the [direction] is not specified try and get it
              // from the language property
              (intl.Bidi.isRtlLanguage(json['language'].toString())
                  ? Direction.rtl.toString()
                  : Direction.ltr.toString()),
        ),
      );

  static List<Edition> listFrom(List<Map<String, dynamic>> json) =>
      List<Edition>.from(json.map<Edition>(Edition.fromJson));

  @override
  bool operator ==(Object other) =>
      other is Edition && other.identifier == identifier;
  @override
  int get hashCode => identifier.hashCode;

  @HiveField(0)
  final String identifier;
  @HiveField(1)
  final String language;
  @override
  @HiveField(2)
  final String name;
  @override
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

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'identifier': identifier,
        'language': language,
        'name': name,
        'englishName': englishName,
        'format': format.name,
        'type': type.name,
        'direction': direction.name,
      };
}
