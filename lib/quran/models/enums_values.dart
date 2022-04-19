import 'package:hive_flutter/hive_flutter.dart';
part 'enums_values.g.dart';

@HiveType(typeId: 1)
class EnumValues {
  EnumValues(this.map);

  @HiveField(0)
  final Map<String, dynamic> map;
  @HiveField(1)
  Map<dynamic, String>? reverseMap;

  Map<dynamic, String> get reverse {
    reverseMap ??= map.map<dynamic, String>(
      (String k, dynamic v) => MapEntry<dynamic, String>(v, k),
    );
    return reverseMap!;
  }
}
