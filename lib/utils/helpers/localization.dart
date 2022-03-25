part of helper;

class _LocalizationHelper {
  const _LocalizationHelper._();
  static const _LocalizationHelper instance = _LocalizationHelper._();
  static late Map<String, String> _localeNames;
  Future<void> init() async {
    _localeNames = Map.from(json.decode(
        await rootBundle.loadString('assets/config/locale_names.json')));
  }

  String nameOf(Locale locale) {
    String key = locale.toLanguageTag().replaceAll('-', '_').toLowerCase();
    if (_localeNames.containsKey(key)) {
      return _localeNames[key]!;
    }
    if (locale.countryCode != null &&
        _localeNames[locale.countryCode] != null) {
      return _localeNames[locale.countryCode]!;
    }
    throw 'not found locale$locale';
  }

  bool equals(Locale l1, Locale l2) =>
      l1.toLanguageTag().replaceAll('-', '_').toLowerCase() ==
      l2.toLanguageTag().replaceAll('-', '_').toLowerCase();
}
