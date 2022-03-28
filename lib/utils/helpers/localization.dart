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

  String getVerseEndSymbol(int verseNumber) {
    var arabicNumeric = '';
    var digits = verseNumber.toString().split("").toList();

    for (var e in digits) {
      if (e == "0") {
        arabicNumeric += "٠";
      }
      if (e == "1") {
        arabicNumeric += "۱";
      }
      if (e == "2") {
        arabicNumeric += "۲";
      }
      if (e == "3") {
        arabicNumeric += "۳";
      }
      if (e == "4") {
        arabicNumeric += "۴";
      }
      if (e == "5") {
        arabicNumeric += "۵";
      }
      if (e == "6") {
        arabicNumeric += "۶";
      }
      if (e == "7") {
        arabicNumeric += "۷";
      }
      if (e == "8") {
        arabicNumeric += "۸";
      }
      if (e == "9") {
        arabicNumeric += "۹";
      }
    }

    return '\u06dd' + arabicNumeric.toString();
  }
}
