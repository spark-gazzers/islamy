import 'package:hive_flutter/hive_flutter.dart';
part 'enums_values.g.dart';

@HiveType(typeId: 1)
class EnumValues {
  @HiveField(0)
  final Map<String, dynamic> map;
  @HiveField(1)
  Map<dynamic, String>? reverseMap;

  EnumValues(this.map);

  Map<dynamic, String> get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
