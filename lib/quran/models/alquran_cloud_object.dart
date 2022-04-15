import 'package:islamy/utils/store.dart';

abstract class AlquranCloudObject {
  String get name;
  String get englishName;

  String get localizedName =>
      Store.locale.toLanguageTag().startsWith('ar') ? name : englishName;
}
