import 'package:intl/intl.dart';
import 'package:islamy/utils/store.dart';

/// Base class ment for localization of the object name
abstract class AlquranCloudObject {
  /// The arabic name
  String get name;

  /// The english name
  String get englishName;

  /// Returns the arabic name if the [Bidi.isRtlLanguage]
  /// on the app locale returns true.
  String get localizedName =>
      Bidi.isRtlLanguage(Store.locale.toLanguageTag()) ? name : englishName;
}
