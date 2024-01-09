import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part '../../../generated/adapters/hadeeth/hadeeth_language.dart';

@HiveType(typeId: 10)

/// A class that represents a language provided from [hadeethenc](https://HadeethEnc.com/)
class HadeethLanguage {
  const HadeethLanguage({
    required this.code,
    required this.native,
  });

  factory HadeethLanguage.fromRawJson(String str) =>
      HadeethLanguage.fromJson(json.decode(str) as Map<String, dynamic>);

  factory HadeethLanguage.fromJson(Map<String, dynamic> json) =>
      HadeethLanguage(
        code: json['code'] as String,
        native: json['native'] as String,
      );
  @override
  bool operator ==(Object other) =>
      other is HadeethLanguage && other.code == code;

  static List<HadeethLanguage> listFrom(List<Map<String, dynamic>> json) =>
      List<HadeethLanguage>.from(
          json.map<HadeethLanguage>(HadeethLanguage.fromJson));
  @HiveField(0)
  final String code;
  @HiveField(1)
  final String native;

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'native': native,
      };
}
