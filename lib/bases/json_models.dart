import 'dart:convert' show json;

/// This class sole purpose is to give documentation to most methods used by
/// models generated from json responses
abstract class JsonModel {
  /// Convenient method to turn this instance to storable json-like [Map].
  Map<String, dynamic> toJson();

  /// Convenient method to turn this instance to storable json [String].
  String toRawJson() => json.encode(toJson());
}
