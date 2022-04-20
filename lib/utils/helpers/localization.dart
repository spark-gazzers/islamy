part of helper;

class _Localization {
  const _Localization._();
  static const _Localization instance = _Localization._();
  static late Map<String, String> _localeNames;
  Future<void> init() async {
    _localeNames = Map<String, String>.from(
      (json.decode(
        await rootBundle.loadString('assets/config/locale_names.json'),
      ) as Map<dynamic, dynamic>)
          .cast<String, String>(),
    );
  }

  String nameOf(Locale locale) {
    final String key =
        locale.toLanguageTag().replaceAll('-', '_').toLowerCase();
    if (_localeNames.containsKey(key)) {
      return _localeNames[key]!;
    }
    if (locale.countryCode != null &&
        _localeNames[locale.countryCode] != null) {
      return _localeNames[locale.countryCode]!;
    }
    throw StateError('not found locale$locale');
  }

  bool equals(Locale l1, Locale l2) =>
      l1.toLanguageTag().replaceAll('-', '_').toLowerCase() ==
      l2.toLanguageTag().replaceAll('-', '_').toLowerCase();

  String getVerseEndSymbol(int verseNumber, TextDirection direction) {
    final StringBuffer arabicNumeric = StringBuffer();

    final List<String> digits = verseNumber.toString().split('').toList();
    const List<String> english = <String>[
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '0'
    ];
    const List<String> arabic = <String>[
      '١',
      '٢',
      '٣',
      '٤',
      '٥',
      '٦',
      '٧',
      '٨',
      '٩',
      '٠'
    ];
    for (final String e in digits) {
      arabicNumeric.write(arabic[english.indexOf(e)]);
    }
    return arabicNumeric.toString();
  }
}
