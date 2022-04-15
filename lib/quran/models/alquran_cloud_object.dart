import 'package:islamy/utils/store.dart';

abstract class AlquranCloudObject {
  late final String name;
  late final String englishName;

  String get localizedName =>
      Store.locale.toLanguageTag().startsWith('ar') ? name : englishName;
}
